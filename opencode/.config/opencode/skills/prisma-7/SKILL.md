---
name: prisma-7
description: >
  Prisma 7 ORM patterns and best practices.
  Trigger: When using Prisma for database access - schema, queries, relations, migrations.
license: Apache-2.0
metadata:
  author: prowler-cloud
  version: "1.0"
---

## Schema Design

```prisma
// ✅ ALWAYS: UUID IDs, @updatedAt, @map/@@map, enums
model User {
  id        String   @id @default(uuid()) @map("user_id")
  email     String   @unique
  name      String
  role      Role     @default(USER)
  posts     Post[]
  profile   Profile?
  createdAt DateTime @default(now()) @map("created_at")
  updatedAt DateTime @updatedAt @map("updated_at")
  @@map("users")
}

enum Role { ADMIN USER GUEST }

// Field types: Int, String, Boolean, DateTime, Float, Decimal, Json, Bytes, BigInt
model Product {
  id    String  @id @default(uuid())
  name  String
  price Decimal @db.Decimal(10, 2)
  meta  Json?
  @@map("products")
}

// ❌ NEVER: autoincrement IDs (enumerable), missing @updatedAt
```

**Why?** UUIDs prevent enumeration attacks. `@updatedAt` tracks changes. `@map`/`@@map` decouples Prisma from DB naming.

## Relations

```prisma
// ✅ One-to-one (note @unique on FK)
model Profile {
  id     String @id @default(uuid())
  user   User   @relation(fields: [userId], references: [id], onDelete: Cascade)
  userId String @unique @map("user_id")
}

// ✅ One-to-many
model Post {
  id       String @id @default(uuid())
  author   User   @relation(fields: [authorId], references: [id], onDelete: Cascade)
  authorId String @map("author_id")
  tags     Tag[]  // implicit many-to-many (Prisma manages join table)
}

// ✅ Explicit many-to-many (join table with extra fields)
model PostTag {
  post   Post   @relation(fields: [postId], references: [id], onDelete: Cascade)
  postId String @map("post_id")
  tag    Tag    @relation(fields: [tagId], references: [id], onDelete: Cascade)
  tagId  String @map("tag_id")
  @@id([postId, tagId])
}

// ✅ Self-relation
model Employee {
  id        String     @id @default(uuid())
  manager   Employee?  @relation("Mgmt", fields: [managerId], references: [id])
  managerId String?
  reports   Employee[] @relation("Mgmt")
}

// ❌ NEVER: Skip onDelete/onUpdate — causes orphaned rows
```

**Why?** Referential actions (`Cascade`, `SetNull`, `Restrict`, `NoAction`) prevent orphaned records.

## Indexes & Constraints

```prisma
model Post {
  id       String @id @default(uuid())
  title    String
  status   String
  authorId String @map("author_id")
  @@index([authorId])            // Single-field
  @@index([status, createdAt])   // Compound (most selective first)
  @@unique([authorId, title])    // Compound unique
}
// Compound PK: @@id([postId, tagId])
```

## CRUD Operations

```typescript
// ✅ Read
const user = await prisma.user.findUnique({ where: { id } });
const admin = await prisma.user.findFirst({ where: { role: "ADMIN" } });
const users = await prisma.user.findMany({ where: { active: true } });

// ✅ Create
const user = await prisma.user.create({ data: { email: "a@b.com", name: "Alice" } });
await prisma.user.createMany({ data: users, skipDuplicates: true });

// ✅ Update / Upsert
await prisma.user.update({ where: { id }, data: { name: "Updated" } });
await prisma.user.upsert({
  where: { email: "a@b.com" },
  update: { name: "Updated" },
  create: { email: "a@b.com", name: "New" },
});

// ✅ Delete
await prisma.user.delete({ where: { id } });
await prisma.user.deleteMany({ where: { active: false } });

// ✅ Select specific fields (prefer over include)
const user = await prisma.user.findUnique({
  where: { id },
  select: { id: true, name: true, email: true },
});

// ✅ Include relations with nested select
const user = await prisma.user.findUnique({
  where: { id },
  include: { posts: { select: { id: true, title: true } } },
});

// ❌ NEVER: Mix include and select at same level
// ❌ NEVER: Over-fetch with include when you only need specific fields
```

## Filtering & Sorting

```typescript
// ✅ Where conditions: equals, not, in, notIn, contains, startsWith, endsWith, gt/gte/lt/lte
const users = await prisma.user.findMany({
  where: {
    email: { contains: "@company.com" },
    role: { in: ["ADMIN", "USER"] },
    OR: [{ name: { startsWith: "A" } }, { role: "ADMIN" }],
    NOT: [{ name: "Blocked" }],
  },
});

// ✅ Relation filters: some, every, none
const authors = await prisma.user.findMany({
  where: { posts: { some: { published: true } } },
});

// ✅ Offset pagination
const page = await prisma.user.findMany({ orderBy: { createdAt: "desc" }, skip: 20, take: 10 });

// ✅ Cursor-based pagination (better for large datasets)
const next = await prisma.user.findMany({
  take: 10, skip: 1, cursor: { id: lastId }, orderBy: { id: "asc" },
});
```

## Transactions

```typescript
// ✅ Sequential (independent operations)
const [user, post] = await prisma.$transaction([
  prisma.user.create({ data: { email: "a@b.com", name: "Alice" } }),
  prisma.post.create({ data: { title: "Hello", authorId: knownId } }),
]);

// ✅ Interactive (dependent operations, single DB transaction)
const result = await prisma.$transaction(async (tx) => {
  const user = await tx.user.findUnique({ where: { id } });
  if (!user) throw new Error("Not found");
  await tx.user.update({ where: { id }, data: { balance: { decrement: amount } } });
  await tx.ledger.create({ data: { userId: id, amount, type: "DEBIT" } });
  return user;
});

// ❌ NEVER: Separate queries that should be atomic without $transaction
```

**Why?** If any operation in an interactive transaction throws, all changes are rolled back.

## Type Safety

```typescript
import { Prisma } from "@prisma/client";

// ✅ Use Prisma generated types
function createUser(data: Prisma.UserCreateInput) { return prisma.user.create({ data }); }
function findUsers(where: Prisma.UserWhereInput) { return prisma.user.findMany({ where }); }

// ✅ Infer return types with GetPayload
type UserWithPosts = Prisma.UserGetPayload<{ include: { posts: true } }>;

// ✅ Reusable definitions with validator
const userArgs = Prisma.validator<Prisma.UserDefaultArgs>()({
  include: { posts: { select: { id: true, title: true } } },
});
type UserPosts = Prisma.UserGetPayload<typeof userArgs>;

// ❌ NEVER: Manual interfaces that duplicate Prisma types
```

## Client Extensions (Prisma 7)

```typescript
// ✅ Model extensions — custom methods
const prisma = new PrismaClient().$extends({
  model: {
    user: {
      async findByEmail(email: string) {
        return prisma.user.findUnique({ where: { email } });
      },
    },
  },
});

// ✅ Result extensions — computed fields
const prisma = new PrismaClient().$extends({
  result: {
    user: {
      fullName: {
        needs: { firstName: true, lastName: true },
        compute: (user) => `${user.firstName} ${user.lastName}`,
      },
    },
  },
});
```

## Performance

```typescript
// ✅ Select only needed fields
const names = await prisma.user.findMany({ select: { id: true, name: true } });
// ✅ Batch operations
await prisma.user.createMany({ data: users, skipDuplicates: true });
await prisma.user.updateMany({ where: { lastLoginAt: { lt: cutoff } }, data: { active: false } });
// ✅ Raw queries for complex operations
const result = await prisma.$queryRaw<User[]>`
  SELECT u.*, COUNT(p.id) as cnt FROM users u
  LEFT JOIN posts p ON p.author_id = u.id GROUP BY u.id HAVING cnt > ${min}
`;
// ❌ NEVER: N+1 queries
const users = await prisma.user.findMany();
for (const u of users) { await prisma.post.findMany({ where: { authorId: u.id } }); }
// ✅ FIX: prisma.user.findMany({ include: { posts: true } })
```

## NestJS Integration

```typescript
// ✅ prisma.service.ts
@Injectable()
export class PrismaService extends PrismaClient implements OnModuleInit, OnModuleDestroy {
  async onModuleInit() { await this.$connect(); }
  async onModuleDestroy() { await this.$disconnect(); }
}

// ✅ prisma.module.ts — register globally
@Global()
@Module({ providers: [PrismaService], exports: [PrismaService] })
export class PrismaModule {}

// ✅ Inject in feature services
@Injectable()
export class UserService {
  constructor(private readonly prisma: PrismaService) {}
  findAll() { return this.prisma.user.findMany(); }
}
```

## Keywords

prisma, orm, database, schema, relations, queries, transactions, migrations, typescript, nestjs
