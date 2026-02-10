# Performance & Efficiency

Measure first, optimize second. Never optimize based on assumptions.
The fastest code is the code that doesn't run.

---

## 1. Model Selection Strategy

Choose the right Claude model for each task:

| Model | Best For | Cost | Speed |
|-------|----------|------|-------|
| **Haiku** | Simple edits, routine cleanup, worker agents | Low | Fast |
| **Sonnet** | Main development, multi-agent orchestration, complex coding | Medium | Medium |
| **Opus** | Architecture decisions, deep reasoning, security analysis | High | Slow |

**Default**: Sonnet for most work.
**Upgrade to Opus**: When reasoning depth matters (architecture, security, complex planning).
**Downgrade to Haiku**: For high-frequency, low-complexity tasks (formatting, simple refactors).

---

## 2. Context Window Management

The last 20% of context window is unreliable. Plan accordingly.

**Start with fresh context for:**
- Large-scale refactoring (> 5 files)
- Multi-file feature implementation
- Complex debugging sessions
- Architecture design discussions

**Safe in limited context:**
- Single-file edits
- Writing tests for one function
- Documentation updates
- Simple bug fixes

---

## 3. Frontend Performance

### Core Web Vitals

| Metric | Target | What It Measures |
|--------|--------|------------------|
| **LCP** | < 2.5s | Largest Contentful Paint — main content visible |
| **INP** | < 200ms | Interaction to Next Paint — responsiveness |
| **CLS** | < 0.1 | Cumulative Layout Shift — visual stability |

### Rendering Optimization

```typescript
// WRONG: Premature memoization everywhere
const MemoizedComponent = React.memo(SimpleComponent)  // Unnecessary
const value = useMemo(() => a + b, [a, b])             // Trivial calculation
const handler = useCallback(() => onClick(), [onClick]) // No proven benefit

// CORRECT: Memoize only when profiling shows a problem
// Step 1: Profile with React DevTools Profiler
// Step 2: Identify the slow re-render
// Step 3: Memoize that specific case

// Valid memoization: expensive computation with proven performance issue
const sortedItems = useMemo(
  () => items.toSorted((a, b) => complexSort(a, b)),
  [items]
)
```

### Bundle Size

- Lazy-load routes and heavy components:
  ```typescript
  const AdminPanel = lazy(() => import('./features/admin/admin-panel'))
  ```
- Analyze bundle: `npx next build && npx @next/bundle-analyzer`
- Tree-shake: prefer named imports over namespace imports
  ```typescript
  // WRONG: Imports entire library
  import _ from 'lodash'

  // CORRECT: Imports only what's used
  import { debounce } from 'es-toolkit'
  ```
- Use `next/image` for automatic optimization (WebP, lazy loading, sizing)
- Set explicit `width`/`height` on images to prevent CLS

### Loading States

Every async operation needs three states:

```typescript
// Declarative approach
<ErrorBoundary fallback={<ErrorMessage />}>
  <Suspense fallback={<Skeleton />}>
    <DataComponent />
  </Suspense>
</ErrorBoundary>

// Or explicit states when Suspense isn't applicable
type AsyncState<T> =
  | { status: 'idle' }
  | { status: 'loading' }
  | { status: 'success'; data: T }
  | { status: 'error'; error: Error }
```

---

## 4. Backend Performance

### Database

```typescript
// WRONG: N+1 query — fetches users, then fetches posts one by one
const users = await db.user.findMany()
for (const user of users) {
  user.posts = await db.post.findMany({ where: { authorId: user.id } })
}

// CORRECT: Single query with join/include
const users = await db.user.findMany({
  include: { posts: true },
})
```

- Add indexes on frequently queried columns (`WHERE`, `JOIN`, `ORDER BY`)
- Use pagination — never return unbounded results:
  ```typescript
  const users = await db.user.findMany({
    take: limit,
    skip: (page - 1) * limit,
    orderBy: { createdAt: 'desc' },
  })
  ```
- Use connection pooling (PgBouncer, Prisma connection pool)
- Use transactions for multi-step operations

### Caching

```typescript
// Cache expensive or frequently accessed data
// Layer 1: In-memory (same request)
// Layer 2: Redis (cross-request, shared across instances)
// Layer 3: CDN/HTTP cache (static assets, public API responses)

// Example: Redis caching with TTL
async function getUser(id: string): Promise<User> {
  const cacheKey = `user:${id}`
  const cached = await redis.get(cacheKey)
  if (cached != null) {
    return JSON.parse(cached)
  }

  const user = await db.user.findUnique({ where: { id } })
  if (user != null) {
    await redis.set(cacheKey, JSON.stringify(user), 'EX', 300) // 5 min TTL
  }
  return user
}
```

### API Design

- Use HTTP caching headers (`Cache-Control`, `ETag`, `Last-Modified`)
- Compress responses (gzip/brotli — usually handled by the framework)
- Return only needed fields — avoid over-fetching
- Use `select` in database queries to fetch only needed columns

---

## 5. Build Troubleshooting

When build fails:
1. Use the **build-error-resolver** agent
2. Read the actual error message — fix the root cause, not symptoms
3. Fix ONE error at a time, verify after each fix
4. **Minimal diffs only** — do not refactor while fixing build errors
5. If stuck: clear caches (`rm -rf .next node_modules/.cache`) and retry
