---
name: angular-21
description: >
  Angular 21 modern patterns with Signals and standalone components.
  Trigger: When writing Angular components - signals, resource, httpResource, inject, control flow.
license: Apache-2.0
metadata:
  author: prowler-cloud
  version: "1.0"
---

## Signals First (REQUIRED)

```typescript
// ✅ signal for state, computed for derived, effect for side effects
import { signal, computed, effect, linkedSignal } from "@angular/core";

count = signal(0);
doubled = computed(() => this.count() * 2);

constructor() {
  effect(() => console.log("Count changed:", this.count()));
}

increment() {
  this.count.update((c) => c + 1);
}

// ✅ linkedSignal: writable derived state that auto-syncs with source
options = signal(["Ground", "Air", "Sea"]);
selected = linkedSignal(() => this.options()[0]);
// selected() === 'Ground'
// selected.set('Sea') — manually override
// options.set(['Email', 'Postal']) — selected auto-resets to 'Email'

// ❌ NEVER: BehaviorSubject for component state
private count$ = new BehaviorSubject(0);
// ❌ NEVER: Manual subscription management
ngOnInit() { this.sub = this.obs$.subscribe(...); }
ngOnDestroy() { this.sub.unsubscribe(); }
```

**Why?** Signals are synchronous, glitch-free, and work with OnPush without markForCheck. linkedSignal replaces patterns where you need computed + manual reset.

## Standalone Components (REQUIRED)

```typescript
// ✅ All components are standalone by default — no NgModules needed
@Component({
  selector: "app-user-list",
  imports: [DatePipe, RouterLink, UserCardComponent],
  templateUrl: "./user-list.component.html",
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class UserListComponent {}

// ❌ NEVER: NgModule declarations
@NgModule({
  declarations: [UserListComponent],
})
```

**Why?** Standalone is the default since Angular 19. NgModules add indirection with no benefit for component declaration.

## New Control Flow (REQUIRED)

```html
<!-- ✅ @if / @else -->
@if (user(); as user) {
  <h1>{{ user.name }}</h1>
} @else {
  <p>Loading...</p>
}

<!-- ✅ @for — track is REQUIRED -->
@for (item of items(); track item.id) {
  <app-card [data]="item" />
} @empty {
  <p>No items found.</p>
}

<!-- ✅ @switch -->
@switch (status()) {
  @case ("active") { <span>Active</span> }
  @case ("inactive") { <span>Inactive</span> }
  @default { <span>Unknown</span> }
}

<!-- ✅ @defer for lazy loading -->
@defer (on viewport) {
  <app-heavy-chart [data]="chartData()" />
} @loading {
  <p>Loading chart...</p>
} @placeholder {
  <div class="chart-placeholder"></div>
}

<!-- ❌ NEVER: structural directives -->
<div *ngIf="user">...</div>
<div *ngFor="let item of items">...</div>
<div [ngSwitch]="status">...</div>
```

**Why?** Built-in control flow is faster (no directive overhead), supports `track` for optimal diffing, and enables `@defer` for lazy loading.

## Signal-Based Inputs/Outputs/Queries (REQUIRED)

```typescript
import {
  input, output, model,
  viewChild, viewChildren, contentChild, contentChildren,
} from "@angular/core";

// ✅ Signal inputs
name = input<string>();                    // InputSignal<string | undefined>
id = input.required<string>();             // InputSignal<string>
color = input("red");                      // InputSignal<string> with default

// ✅ Signal output
saved = output<User>();                    // OutputEmitterRef<User>
// template: (saved)="onSaved($event)"
// emit: this.saved.emit(user);

// ✅ model for two-way binding
checked = model(false);                    // ModelSignal<boolean>
// template: [(checked)]="isChecked"

// ✅ Signal queries
chart = viewChild.required<ElementRef>("chart");
items = viewChildren(ItemComponent);
header = contentChild(HeaderDirective);

// ❌ NEVER: decorator-based
@Input() name: string;
@Output() saved = new EventEmitter<User>();
@ViewChild("chart") chart: ElementRef;
```

**Why?** Signal-based APIs are reactive by default, type-safe, and compose naturally with computed/effect.

## Dependency Injection with inject() (REQUIRED)

```typescript
import { inject } from "@angular/core";

// ✅ inject() function in field initializers
export class UserService {
  private http = inject(HttpClient);
  private router = inject(Router);
  private config = inject(APP_CONFIG);
}

// ❌ NEVER: constructor injection
export class UserService {
  constructor(
    private http: HttpClient,
    private router: Router,
  ) {}
}
```

**Why?** `inject()` works in field initializers, is tree-shakable, and doesn't require constructor boilerplate.

## Resource API

```typescript
import { resource, Signal } from "@angular/core";
import { httpResource } from "@angular/common/http";

// ✅ resource() for generic async data
userId = input.required<string>();

userResource = resource({
  params: () => ({ id: this.userId() }),
  loader: ({ params }) => fetchUser(params),
});

// Access: .value(), .isLoading(), .error(), .status(), .hasValue()
firstName = computed(() =>
  this.userResource.hasValue() ? this.userResource.value().firstName : undefined,
);

// ✅ httpResource() for HTTP requests — auto re-fetches on signal changes
user = httpResource<User>(() => `/api/users/${this.userId()}`);

// httpResource with options
users = httpResource<User[]>({
  url: () => "/api/users",
  method: "GET",
  params: () => ({ role: this.roleFilter() }),
});
```

**Why?** Resources integrate async data into the signal graph. `httpResource` replaces manual HttpClient subscribe patterns with reactive, declarative fetching.

## Change Detection

```typescript
// ✅ ALWAYS: OnPush on every component
@Component({
  selector: "app-dashboard",
  changeDetection: ChangeDetectionStrategy.OnPush,
  template: `<h1>{{ title() }}</h1>`,
})
export class DashboardComponent {
  title = input.required<string>();
}

// ❌ NEVER: Default change detection
@Component({
  changeDetection: ChangeDetectionStrategy.Default, // NO!
})
```

**Why?** OnPush skips unnecessary checks. Signals trigger precise updates without zone.js or markForCheck.

## Router

```typescript
// ✅ Functional guards
export const authGuard: CanActivateFn = (route, state) => {
  const auth = inject(AuthService);
  return auth.isAuthenticated() ? true : inject(Router).createUrlTree(["/login"]);
};

// ✅ Functional resolvers
export const userResolver: ResolveFn<User> = (route) => {
  return inject(UserService).getUser(route.paramMap.get("id")!);
};

// ✅ Route config with input bindings
const routes: Routes = [
  {
    path: "users/:id",
    component: UserComponent,
    canActivate: [authGuard],
    resolve: { user: userResolver },
  },
];

// ✅ Route params as signal inputs (withComponentInputBinding)
// In UserComponent:
id = input.required<string>(); // bound from :id route param

// ❌ NEVER: class-based guards
@Injectable()
export class AuthGuard implements CanActivate { ... }
```

**Why?** Functional guards/resolvers are simpler, tree-shakable, and use `inject()` naturally. Route input bindings eliminate ActivatedRoute subscriptions.

## Keywords

angular, angular 21, signals, signal, computed, effect, linkedSignal, resource, httpResource, standalone, control flow, @if, @for, @switch, @defer, input, output, model, viewChild, inject, OnPush, zoneless, functional guards
