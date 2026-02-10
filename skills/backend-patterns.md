---
name: backend-patterns
description: Backend architecture patterns, API design, database optimization, and server-side best practices for Node.js and Next.js API routes.
---

# Backend Development Patterns

Backend architecture patterns for scalable server-side applications.

## API Design

### RESTful API Structure

```typescript
GET    /api/items              # List resources
GET    /api/items/:id          # Get single resource
POST   /api/items              # Create resource
PUT    /api/items/:id          # Replace resource
PATCH  /api/items/:id          # Update resource
DELETE /api/items/:id          # Delete resource

// Query parameters for filtering, sorting, pagination
GET /api/items?status=active&sort=createdAt&limit=20&offset=0
```

### Response Format

```typescript
interface ApiResponse<T> {
  success: boolean
  data?: T
  error?: string
  meta?: {
    total: number
    page: number
    limit: number
  }
}
```

### Repository Pattern

```typescript
interface Repository<T> {
  findAll(filters?: Filters): Promise<T[]>
  findById(id: string): Promise<T | null>
  create(data: CreateDto): Promise<T>
  update(id: string, data: UpdateDto): Promise<T>
  delete(id: string): Promise<void>
}

// Implementation swappable: Prisma, Drizzle, raw SQL, etc.
class PrismaItemRepository implements Repository<Item> {
  async findAll(filters?: ItemFilters): Promise<Item[]> {
    return prisma.item.findMany({
      where: filters,
      orderBy: { createdAt: 'desc' }
    })
  }

  async findById(id: string): Promise<Item | null> {
    return prisma.item.findUnique({ where: { id } })
  }

  // ...
}
```

### Service Layer

```typescript
class ItemService {
  constructor(private repo: Repository<Item>) {}

  async search(query: string, limit: number = 10): Promise<Item[]> {
    // Business logic lives here, not in the route handler
    const results = await this.repo.findAll({
      name: { contains: query },
      status: 'active'
    })
    return results.slice(0, limit)
  }
}
```

### Middleware Pattern

```typescript
export function withAuth(handler: (req: Request, user: User) => Promise<Response>) {
  return async (req: Request) => {
    const token = req.headers.get('authorization')?.replace('Bearer ', '')

    if (token == null) {
      return Response.json({ error: 'Unauthorized' }, { status: 401 })
    }

    try {
      const user = await verifyToken(token)
      return handler(req, user)
    } catch {
      return Response.json({ error: 'Invalid token' }, { status: 401 })
    }
  }
}

// Usage
export const GET = withAuth(async (req, user) => {
  const data = await getDataForUser(user.id)
  return Response.json({ success: true, data })
})
```

## Database Patterns

### Query Optimization

```typescript
// GOOD: Select only needed columns
const items = await db.query(
  'SELECT id, name, status FROM items WHERE status = $1 LIMIT $2',
  ['active', 10]
)

// BAD: Select everything
const items = await db.query('SELECT * FROM items')
```

### N+1 Query Prevention

```typescript
// BAD: N+1 queries
const items = await getItems()
for (const item of items) {
  item.author = await getUser(item.authorId)  // N queries!
}

// GOOD: Batch fetch
const items = await getItems()
const authorIds = [...new Set(items.map(i => i.authorId))]
const authors = await getUsersByIds(authorIds)  // 1 query
const authorMap = new Map(authors.map(a => [a.id, a]))

const itemsWithAuthors = items.map(item => ({
  ...item,
  author: authorMap.get(item.authorId) ?? null
}))
```

### Transaction Pattern

```typescript
async function transferFunds(fromId: string, toId: string, amount: number) {
  return db.transaction(async (tx) => {
    const sender = await tx.query(
      'SELECT balance FROM accounts WHERE id = $1 FOR UPDATE',
      [fromId]
    )

    if (sender.rows[0].balance < amount) {
      throw new Error('Insufficient balance')
    }

    await tx.query(
      'UPDATE accounts SET balance = balance - $1 WHERE id = $2',
      [amount, fromId]
    )
    await tx.query(
      'UPDATE accounts SET balance = balance + $1 WHERE id = $2',
      [amount, toId]
    )
  })
}
```

## Caching

### Cache-Aside Pattern

```typescript
class CachedRepository<T> implements Repository<T> {
  constructor(
    private baseRepo: Repository<T>,
    private cache: CacheClient
  ) {}

  async findById(id: string): Promise<T | null> {
    const cacheKey = `item:${id}`

    // Check cache
    const cached = await this.cache.get(cacheKey)
    if (cached != null) return JSON.parse(cached)

    // Cache miss
    const item = await this.baseRepo.findById(id)
    if (item != null) {
      await this.cache.set(cacheKey, JSON.stringify(item), { ex: 300 })  // 5 min TTL
    }
    return item
  }

  async invalidate(id: string): Promise<void> {
    await this.cache.del(`item:${id}`)
  }
}
```

## Error Handling

### Centralized Error Handler

```typescript
class AppError extends Error {
  constructor(
    public statusCode: number,
    message: string,
    public isOperational = true
  ) {
    super(message)
  }
}

class NotFoundError extends AppError {
  constructor(resource: string) {
    super(404, `${resource} not found`)
  }
}

class ValidationError extends AppError {
  constructor(message: string) {
    super(400, message)
  }
}

export function errorHandler(error: unknown): Response {
  if (error instanceof AppError) {
    return Response.json(
      { success: false, error: error.message },
      { status: error.statusCode }
    )
  }

  if (error instanceof z.ZodError) {
    return Response.json(
      { success: false, error: 'Validation failed', details: error.errors },
      { status: 400 }
    )
  }

  console.error('Unexpected error:', error)
  return Response.json(
    { success: false, error: 'Internal server error' },
    { status: 500 }
  )
}
```

### Retry with Backoff

```typescript
async function withRetry<T>(fn: () => Promise<T>, maxRetries = 3): Promise<T> {
  let lastError: Error

  for (let attempt = 0; attempt < maxRetries; attempt++) {
    try {
      return await fn()
    } catch (error) {
      lastError = error as Error
      if (attempt < maxRetries - 1) {
        const delay = Math.pow(2, attempt) * 1000  // 1s, 2s, 4s
        await new Promise(resolve => setTimeout(resolve, delay))
      }
    }
  }

  throw lastError!
}
```

## Authentication & Authorization

### RBAC

```typescript
type Permission = 'read' | 'write' | 'delete' | 'admin'

const ROLE_PERMISSIONS: Record<string, Permission[]> = {
  admin: ['read', 'write', 'delete', 'admin'],
  moderator: ['read', 'write', 'delete'],
  user: ['read', 'write']
}

function hasPermission(userRole: string, permission: Permission): boolean {
  const permissions = ROLE_PERMISSIONS[userRole]
  return permissions != null && permissions.includes(permission)
}

function requirePermission(permission: Permission) {
  return withAuth(async (req, user) => {
    if (!hasPermission(user.role, permission)) {
      return Response.json({ error: 'Forbidden' }, { status: 403 })
    }
    // Proceed with handler
  })
}
```

## Rate Limiting

```typescript
class RateLimiter {
  private requests = new Map<string, number[]>()

  isAllowed(identifier: string, maxRequests: number, windowMs: number): boolean {
    const now = Date.now()
    const timestamps = this.requests.get(identifier) ?? []
    const recent = timestamps.filter(t => now - t < windowMs)

    if (recent.length >= maxRequests) return false

    recent.push(now)
    this.requests.set(identifier, recent)
    return true
  }
}

const limiter = new RateLimiter()

export async function GET(req: Request) {
  const ip = req.headers.get('x-forwarded-for') ?? 'unknown'

  if (!limiter.isAllowed(ip, 100, 60_000)) {
    return Response.json({ error: 'Rate limit exceeded' }, { status: 429 })
  }

  // Continue
}
```

## Structured Logging

```typescript
interface LogContext {
  requestId?: string
  userId?: string
  [key: string]: unknown
}

class Logger {
  private log(level: string, message: string, context?: LogContext) {
    const entry = {
      timestamp: new Date().toISOString(),
      level,
      message,
      ...context
    }
    console.log(JSON.stringify(entry))
  }

  info(message: string, context?: LogContext) { this.log('info', message, context) }
  warn(message: string, context?: LogContext) { this.log('warn', message, context) }
  error(message: string, error: Error, context?: LogContext) {
    this.log('error', message, { ...context, error: error.message })
  }
}

export const logger = new Logger()
```
