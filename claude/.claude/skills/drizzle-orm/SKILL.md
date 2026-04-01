---
name: drizzle-orm
description: >
  Drizzle ORM patterns and best practices for schema definition, queries, relations,
  migrations, and adapters. Trigger: When using Drizzle ORM — schema files, queries,
  drizzle.config.ts, migrations, drizzle-kit commands.
license: Apache-2.0
metadata:
  author: gentleman-programming
  version: "1.0"
---

## When to Use

- Writing or editing schema files (`schema.ts`, `*.schema.ts`)
- Setting up a new Drizzle ORM connection/adapter
- Writing queries (select, insert, update, delete, joins)
- Defining or modifying relations
- Configuring migrations with drizzle-kit
- Replacing or migrating from Prisma

---

## Critical Patterns

### 1. One schema file exports EVERYTHING

Keep tables and their relations in the same file or co-located by domain. The `drizzle()` instance must receive the full schema to enable relational queries.

```typescript
// src/db/schema.ts — tables + relations in one place
export * from './users.schema';
export * from './posts.schema';
```

```typescript
// src/db/index.ts — import full schema
import * as schema from './schema';
export const db = drizzle(client, { schema });
```

### 2. Type inference from schema — ALWAYS use `$inferSelect` / `$inferInsert`

NEVER manually write types that mirror the schema.

```typescript
export type User = typeof users.$inferSelect;
export type NewUser = typeof users.$inferInsert;
```

### 3. Relations are NOT foreign keys

`relations()` is Drizzle's relational query layer. It does NOT create FK constraints. FK constraints go in the column definition itself.

```typescript
// FK constraint (enforced by DB)
authorId: integer('author_id').references(() => users.id)

// Relational query config (for db.query.*)
export const postsRelations = relations(posts, ({ one }) => ({
  author: one(users, { fields: [posts.authorId], references: [users.id] }),
}));
```

### 4. Prefer `db.query.*` for relational reads, SQL-like API for writes

- **Reads with joins** → `db.query.users.findMany({ with: { posts: true } })`
- **Writes** → `db.insert()`, `db.update()`, `db.delete()`
- **Raw control** → `db.select().from(...).where(...).join(...)`

---

## Setup & Configuration

### drizzle.config.ts

```typescript
import 'dotenv/config';
import { defineConfig } from 'drizzle-kit';

export default defineConfig({
  dialect: 'postgresql', // 'postgresql' | 'mysql' | 'sqlite' | 'turso'
  schema: './src/db/schema.ts',
  out: './drizzle',      // migration files output
  dbCredentials: {
    url: process.env.DATABASE_URL!,
  },
});
```

### Adapter setup by dialect

**PostgreSQL — node-postgres (`pg`)**
```typescript
import { drizzle } from 'drizzle-orm/node-postgres';
import { Pool } from 'pg';
import * as schema from './schema';

const pool = new Pool({ connectionString: process.env.DATABASE_URL });
export const db = drizzle(pool, { schema });
```

**PostgreSQL — Neon serverless**
```typescript
import { drizzle } from 'drizzle-orm/neon-http';
import { neon } from '@neondatabase/serverless';
import * as schema from './schema';

const sql = neon(process.env.DATABASE_URL!);
export const db = drizzle(sql, { schema });
```

**MySQL — mysql2**
```typescript
import { drizzle } from 'drizzle-orm/mysql2';
import mysql from 'mysql2/promise';
import * as schema from './schema';

const connection = await mysql.createConnection({ uri: process.env.DATABASE_URL });
export const db = drizzle(connection, { schema, mode: 'default' });
```

**SQLite — better-sqlite3**
```typescript
import { drizzle } from 'drizzle-orm/better-sqlite3';
import Database from 'better-sqlite3';
import * as schema from './schema';

const sqlite = new Database('./local.db');
export const db = drizzle(sqlite, { schema });
```

**SQLite — Turso / libSQL**
```typescript
import { drizzle } from 'drizzle-orm/libsql';
import { createClient } from '@libsql/client';
import * as schema from './schema';

const client = createClient({
  url: process.env.TURSO_DATABASE_URL!,
  authToken: process.env.TURSO_AUTH_TOKEN!,
});
export const db = drizzle(client, { schema });
```

---

## Schema Definition

### PostgreSQL (`pg-core`)

```typescript
import {
  pgTable, serial, integer, text, varchar, boolean,
  timestamp, uuid, jsonb, pgEnum, uniqueConstraint, index
} from 'drizzle-orm/pg-core';

export const roleEnum = pgEnum('role', ['admin', 'editor', 'viewer']);

export const users = pgTable('users', {
  id: serial('id').primaryKey(),
  uuid: uuid('uuid').defaultRandom().notNull(),
  name: text('name').notNull(),
  email: varchar('email', { length: 256 }).notNull().unique(),
  role: roleEnum('role').default('viewer').notNull(),
  metadata: jsonb('metadata'),
  verified: boolean('verified').default(false).notNull(),
  createdAt: timestamp('created_at', { withTimezone: true }).defaultNow().notNull(),
  updatedAt: timestamp('updated_at', { withTimezone: true }).defaultNow().notNull(),
}, (table) => [
  uniqueConstraint('users_email_unique', [table.email]),
  index('users_name_idx').on(table.name),
]);
```

### MySQL (`mysql-core`)

```typescript
import {
  mysqlTable, int, varchar, text, boolean,
  timestamp, mysqlEnum, serial
} from 'drizzle-orm/mysql-core';

export const users = mysqlTable('users', {
  id: serial('id').primaryKey(),
  name: varchar('name', { length: 255 }).notNull(),
  email: varchar('email', { length: 256 }).notNull().unique(),
  role: mysqlEnum('role', ['admin', 'editor', 'viewer']).default('viewer'),
  verified: boolean('verified').default(false),
  createdAt: timestamp('created_at').defaultNow().notNull(),
});
```

### SQLite (`sqlite-core`)

```typescript
import {
  sqliteTable, integer, text, real, blob
} from 'drizzle-orm/sqlite-core';

export const users = sqliteTable('users', {
  id: integer('id').primaryKey({ autoIncrement: true }),
  name: text('name').notNull(),
  email: text('email').notNull().unique(),
  age: integer('age'),
  score: real('score'),
  verified: integer('verified', { mode: 'boolean' }).default(false),
  createdAt: integer('created_at', { mode: 'timestamp' }).$defaultFn(() => new Date()),
});
```

---

## Relations

```typescript
import { relations } from 'drizzle-orm';

// One-to-many
export const usersRelations = relations(users, ({ many }) => ({
  posts: many(posts),
}));

export const postsRelations = relations(posts, ({ one, many }) => ({
  author: one(users, { fields: [posts.authorId], references: [users.id] }),
  comments: many(comments),
}));

// Many-to-many (via junction table)
export const usersToGroups = pgTable('users_to_groups', {
  userId: integer('user_id').notNull().references(() => users.id),
  groupId: integer('group_id').notNull().references(() => groups.id),
}, (t) => [
  primaryKey({ columns: [t.userId, t.groupId] }),
]);

export const usersToGroupsRelations = relations(usersToGroups, ({ one }) => ({
  user: one(users, { fields: [usersToGroups.userId], references: [users.id] }),
  group: one(groups, { fields: [usersToGroups.groupId], references: [groups.id] }),
}));

// Self-referential
export const employees = pgTable('employees', {
  id: serial('id').primaryKey(),
  managerId: integer('manager_id').references((): AnyPgColumn => employees.id),
});
```

---

## Queries

### Select

```typescript
import { eq, and, or, like, gt, lt, gte, lte, ne, inArray, isNull, isNotNull, sql, desc, asc } from 'drizzle-orm';

// Basic select
const allUsers = await db.select().from(users);

// Select specific columns
const names = await db.select({ id: users.id, name: users.name }).from(users);

// Where conditions
const user = await db.select().from(users)
  .where(eq(users.email, 'john@example.com'))
  .limit(1);

// Multiple conditions
const results = await db.select().from(users)
  .where(and(
    eq(users.verified, true),
    gt(users.age, 18),
    like(users.name, '%John%'),
  ));

// Joins
const postsWithAuthors = await db.select({
  postTitle: posts.title,
  authorName: users.name,
}).from(posts)
  .leftJoin(users, eq(posts.authorId, users.id));

// Order and paginate
const page = await db.select().from(users)
  .orderBy(desc(users.createdAt), asc(users.name))
  .limit(20)
  .offset(40);

// Aggregations
const counts = await db.select({
  count: sql<number>`count(*)`.mapWith(Number),
  userId: posts.authorId,
}).from(posts).groupBy(posts.authorId);
```

### Relational queries (`db.query.*`)

Requires schema passed to `drizzle(client, { schema })`.

```typescript
// Find many with relations
const usersWithPosts = await db.query.users.findMany({
  with: {
    posts: {
      with: { comments: true },
      where: (post, { eq }) => eq(post.published, true),
      orderBy: (post, { desc }) => [desc(post.createdAt)],
      limit: 10,
    },
  },
  where: (user, { eq }) => eq(user.verified, true),
});

// Find first
const user = await db.query.users.findFirst({
  where: (u, { eq }) => eq(u.id, userId),
  with: { posts: true },
});

// Select specific columns in relational query
const result = await db.query.users.findMany({
  columns: { id: true, name: true },
  with: { posts: { columns: { title: true } } },
});
```

### Insert

```typescript
// Single insert
await db.insert(users).values({
  name: 'John',
  email: 'john@example.com',
});

// Insert returning
const [newUser] = await db.insert(users).values({
  name: 'John',
  email: 'john@example.com',
}).returning();

// Bulk insert
await db.insert(users).values([
  { name: 'Alice', email: 'alice@example.com' },
  { name: 'Bob', email: 'bob@example.com' },
]);

// Upsert (on conflict)
await db.insert(users).values({ id: 1, name: 'John', email: 'john@example.com' })
  .onConflictDoUpdate({
    target: users.email,
    set: { name: 'John Updated' },
  });
```

### Update

```typescript
// Update with where
await db.update(users)
  .set({ name: 'Jane', updatedAt: new Date() })
  .where(eq(users.id, 1));

// Update returning (PostgreSQL)
const [updated] = await db.update(users)
  .set({ verified: true })
  .where(eq(users.id, 1))
  .returning();
```

### Delete

```typescript
// Delete with where
await db.delete(users).where(eq(users.id, 1));

// Delete returning (PostgreSQL)
const [deleted] = await db.delete(users)
  .where(eq(users.id, 1))
  .returning();
```

### Transactions

```typescript
const result = await db.transaction(async (tx) => {
  const [newUser] = await tx.insert(users).values({
    name: 'Alice', email: 'alice@example.com',
  }).returning();

  await tx.insert(posts).values({
    title: 'First Post',
    authorId: newUser.id,
  });

  return newUser;
});

// Rollback manually
await db.transaction(async (tx) => {
  try {
    await tx.insert(users).values({ name: 'Bob', email: 'bob@example.com' });
  } catch {
    tx.rollback();
  }
});
```

---

## Migrations (drizzle-kit)

```bash
# Generate migration SQL files from schema changes
npx drizzle-kit generate

# Apply pending migrations to the database
npx drizzle-kit migrate

# Push schema directly to DB — no migration files (dev only)
npx drizzle-kit push

# Pull schema from existing database
npx drizzle-kit pull

# Open Drizzle Studio (web DB GUI)
npx drizzle-kit studio

# Generate a custom (empty) migration
npx drizzle-kit generate --name=seed-initial-data --custom
```

**Development vs Production:**
- `push` → fast iteration in dev, bypasses migration files
- `generate` + `migrate` → production-safe, versioned, auditable

---

## Common Patterns

### Database singleton (Node.js)

```typescript
// src/db/index.ts
import { drizzle } from 'drizzle-orm/node-postgres';
import { Pool } from 'pg';
import * as schema from './schema';

let db: ReturnType<typeof drizzle>;

export function getDb() {
  if (!db) {
    const pool = new Pool({ connectionString: process.env.DATABASE_URL });
    db = drizzle(pool, { schema });
  }
  return db;
}

export { schema };
```

### Paginated query helper

```typescript
export async function paginate<T>(
  query: any,
  page: number,
  pageSize: number
): Promise<{ data: T[]; total: number }> {
  const offset = (page - 1) * pageSize;
  const [data, [{ count }]] = await Promise.all([
    query.limit(pageSize).offset(offset),
    db.select({ count: sql<number>`count(*)`.mapWith(Number) }).from(query.as('q')),
  ]);
  return { data, total: count };
}
```

### Soft deletes

```typescript
export const posts = pgTable('posts', {
  id: serial('id').primaryKey(),
  title: text('title').notNull(),
  deletedAt: timestamp('deleted_at'),
});

// Soft delete
await db.update(posts).set({ deletedAt: new Date() }).where(eq(posts.id, id));

// Query only active records
await db.select().from(posts).where(isNull(posts.deletedAt));
```

---

## Commands

```bash
# Install (PostgreSQL example)
npm install drizzle-orm pg
npm install -D drizzle-kit @types/pg

# Install (MySQL example)
npm install drizzle-orm mysql2
npm install -D drizzle-kit

# Install (SQLite / Turso example)
npm install drizzle-orm @libsql/client
npm install -D drizzle-kit

# Install (Neon serverless)
npm install drizzle-orm @neondatabase/serverless
npm install -D drizzle-kit

# Run migrations
npx drizzle-kit generate
npx drizzle-kit migrate

# Dev: push schema
npx drizzle-kit push

# Open Studio
npx drizzle-kit studio
```

---

## Resources

- Official docs: https://orm.drizzle.team
- Drizzle Kit: https://orm.drizzle.team/kit-docs/overview
- Column types reference: https://orm.drizzle.team/docs/column-types/pg
- Relational queries: https://orm.drizzle.team/docs/rqb
