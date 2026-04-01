---
name: vitest-4
description: >
  Vitest 4 testing patterns and best practices.
  Trigger: When writing tests - describe, it, expect, mock, spy, vi.fn, vi.mock.
license: Apache-2.0
metadata:
  author: prowler-cloud
  version: "1.0"
---

## Test Structure (REQUIRED)

```typescript
import { describe, it, test, expect, beforeEach, afterEach } from "vitest";

describe("UserService", () => {
  let service: UserService;

  beforeEach(() => {
    service = new UserService();
  });

  afterEach(() => {
    vi.restoreAllMocks();
  });

  // ✅ Use `it` for behavior descriptions
  it("should return user by id", () => {
    const user = service.getById("1");
    expect(user.name).toBe("Alice");
  });

  // ✅ Use `test` for unit assertions
  test("formatName trims whitespace", () => {
    expect(formatName("  Alice  ")).toBe("Alice");
  });
});

// ❌ NEVER: More than 2 levels of describe nesting
// ❌ NEVER: Tests without clear descriptions
```

## Assertions (REQUIRED)

```typescript
// ✅ Primitives — use toBe (strict ===)
expect(1 + 1).toBe(2);
expect(name).toBe("Alice");

// ✅ Objects/arrays — use toEqual (deep equality)
expect(user).toEqual({ id: "1", name: "Alice" });

// ✅ toStrictEqual — also checks undefined properties and class instances
expect(result).toStrictEqual(expected);

// ✅ Other matchers
expect(items).toContain("apple");
expect(items).toHaveLength(3);
expect(message).toMatch(/hello/i);

// ✅ Error testing
expect(() => divide(1, 0)).toThrow();
expect(() => parse("bad")).toThrowError("Invalid input");

// ✅ Async assertions
await expect(fetchUser("1")).resolves.toEqual({ name: "Alice" });
await expect(fetchUser("bad")).rejects.toThrow("Not found");

// ❌ NEVER: toBe for objects (compares references, not values)
expect(user).toBe({ id: "1" }); // WRONG — always fails
```

**Why?** `toBe` uses `Object.is`, `toEqual` recursively checks values, `toStrictEqual` additionally checks property existence and prototypes.

## Mock Functions (REQUIRED)

```typescript
import { vi, expect } from "vitest";

// ✅ Create mocks
const fn = vi.fn();
const typed = vi.fn<(name: string) => number>();

// ✅ Return values
fn.mockReturnValue(42);
fn.mockReturnValueOnce(1).mockReturnValueOnce(2);

// ✅ Async return values
fn.mockResolvedValue({ id: "1" });
fn.mockResolvedValueOnce({ id: "1" });
fn.mockRejectedValue(new Error("fail"));

// ✅ Custom implementation
fn.mockImplementation((x: number) => x * 2);
fn.mockImplementationOnce((x: number) => x * 3);

// ✅ Assertions
expect(fn).toHaveBeenCalled();
expect(fn).toHaveBeenCalledWith("hello");
expect(fn).toHaveBeenCalledTimes(2);
expect(fn).toHaveBeenCalledExactlyOnceWith("hello"); // Vitest-specific

// ❌ NEVER: Manual function stubs when vi.fn() exists
const stub = (...args: any[]) => "fake"; // WRONG
```

## Spies

```typescript
// ✅ Spy on existing methods (observes real behavior)
const spy = vi.spyOn(userService, "getById");
userService.getById("1");
expect(spy).toHaveBeenCalledWith("1");

// ✅ Override behavior while spying
vi.spyOn(console, "error").mockImplementation(() => {});

// ✅ Restore spies — ALWAYS in afterEach or config
afterEach(() => {
  vi.restoreAllMocks();
});
// Or in vitest.config.ts: restoreMocks: true

// ❌ NEVER: Forget to restore spies (leaks between tests)
```

## Module Mocking (REQUIRED)

```typescript
import { vi } from "vitest";
import { fetchUser } from "./api";

// ✅ Auto-mock entire module (all exports become vi.fn())
vi.mock("./api");

// ✅ Factory function for custom implementations
vi.mock("./api", () => ({
  fetchUser: vi.fn().mockResolvedValue({ name: "Mock" }),
}));

// ✅ Type-safe mock with importOriginal (keeps original + overrides)
vi.mock(import("./api"), async (importOriginal) => {
  const original = await importOriginal();
  return {
    ...original,
    fetchUser: vi.fn(original.fetchUser),
  };
});

// ✅ vi.hoisted — declare variables accessible in vi.mock factories
// (vi.mock is hoisted to top of file, so normal variables aren't accessible)
const mocks = vi.hoisted(() => ({
  fetchUser: vi.fn(),
}));

vi.mock("./api", () => ({
  fetchUser: mocks.fetchUser,
}));

// ✅ vi.mocked — type-safe access to mocked functions
vi.mock("./api");
vi.mocked(fetchUser).mockResolvedValue({ name: "Alice" });
vi.mocked(fetchUser, { partial: true }).mockResolvedValue({ ok: true });

// ✅ Spy on real implementations (no replacement)
vi.mock("./api", { spy: true });

// ❌ NEVER: vi.mock without factory when you need specific behavior
// ❌ NEVER: Reference outer variables in vi.mock factory without vi.hoisted
```

**Why?** `vi.mock` is hoisted above imports, so normal `const` declarations aren't available inside the factory. Use `vi.hoisted` to solve this.

## Async Testing

```typescript
// ✅ async/await in test functions
it("fetches user data", async () => {
  const user = await fetchUser("1");
  expect(user.name).toBe("Alice");
});

// ✅ resolves/rejects helpers
await expect(fetchUser("1")).resolves.toEqual({ name: "Alice" });
await expect(fetchUser("bad")).rejects.toThrow("Not found");

// ✅ Fake timers for setTimeout/setInterval
beforeEach(() => vi.useFakeTimers());
afterEach(() => vi.useRealTimers());

it("executes after delay", () => {
  const callback = vi.fn();
  setTimeout(callback, 1000);

  vi.advanceTimersByTime(1000);
  expect(callback).toHaveBeenCalledOnce();
});

it("runs all pending timers", () => {
  const callback = vi.fn();
  setTimeout(callback, 5000);

  vi.runAllTimers();
  expect(callback).toHaveBeenCalled();
});

it("mocks system time", () => {
  vi.setSystemTime(new Date("2025-01-01"));
  expect(new Date().getFullYear()).toBe(2025);
});
```

## Test Organization

```typescript
// ✅ AAA pattern: Arrange, Act, Assert
it("should calculate total", () => {
  // Arrange
  const cart = new Cart();
  cart.add({ price: 10, qty: 2 });

  // Act
  const total = cart.getTotal();

  // Assert
  expect(total).toBe(20);
});

// ✅ Parametrized tests with test.each
test.each([
  { input: 1, expected: "1" },
  { input: 2, expected: "2" },
  { input: -1, expected: "-1" },
])("converts $input to string '$expected'", ({ input, expected }) => {
  expect(String(input)).toBe(expected);
});

// ✅ Parallel tests
describe.concurrent("independent tests", () => {
  it("test A", async () => { /* ... */ });
  it("test B", async () => { /* ... */ });
});

// ✅ WIP markers
it.skip("not ready yet", () => {});
it.todo("implement validation logic");
it.only("debug this specific test", () => {}); // Remove before commit!

// ❌ NEVER: Multiple unrelated assertions in one test
// ❌ NEVER: Test files without .test.ts or .spec.ts suffix
```

## Snapshot Testing

```typescript
// ✅ Inline snapshots — preferred for small values
expect(formatDate(date)).toMatchInlineSnapshot(`"Jan 1, 2025"`);

// ✅ File snapshots — for larger structures
expect(renderComponent()).toMatchSnapshot();

// ❌ NEVER: Snapshots for large dynamic objects (fragile, noisy diffs)
expect(entireDatabaseResponse).toMatchSnapshot(); // WRONG
```

## Testing Patterns

```typescript
// ✅ Test behavior, not implementation
it("should reject invalid emails", () => {
  expect(validate("bad")).toEqual({ valid: false });
});

// ✅ Use dependency injection for testability
class OrderService {
  constructor(private readonly paymentGateway: PaymentGateway) {}
}

// ✅ Clear mocks in beforeEach (or clearMocks: true in config)
beforeEach(() => {
  vi.clearAllMocks();
});

// ✅ Prefer integration tests for services, unit tests for pure functions

// ❌ NEVER: Test private methods directly
// ❌ NEVER: Mock everything (over-mocking makes tests brittle)
// ❌ NEVER: Rely on test execution order
```

## Keywords

vitest, testing, unit test, mock, spy, vi.fn, vi.mock, vi.spyOn, vi.hoisted, vi.mocked, expect, describe, it, test, snapshot, fake timers, parametrized
