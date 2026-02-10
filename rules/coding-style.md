# Coding Style

Write code that a senior engineer would approve in a code review at Toss.
Every line must express clear intent. Optimize for readability, maintainability, and correctness — in that order.

---

## 1. Explicit Intent (CRITICAL)

Code must be unambiguous. If a reader has to guess what a line does, rewrite it.

### Null/Undefined Checks

NEVER use implicit falsy coercion. ALWAYS use explicit checks.

```typescript
// WRONG: Ambiguous — catches 0, '', false as side effects
if (!data) { return null }
if (!count) { showEmpty() }
if (!name) { setDefault() }

// CORRECT: Explicit — intent is unmistakable
if (data == null) { return null }
if (count === 0) { showEmpty() }
if (name === '') { setDefault() }
```

### Boolean Naming

Booleans must read as yes/no questions:

```typescript
// WRONG: Ambiguous
const login = true
const data = false
const modal = true

// CORRECT: Self-documenting
const isLoggedIn = true
const hasData = false
const isModalOpen = true
const canSubmit = form.isValid && !form.isSubmitting
const shouldRedirect = isLoggedIn && returnUrl != null
```

### No Magic Numbers

Every number must explain itself:

```typescript
// WRONG: What is 5? What is 1000?
if (retries > 5) { throw new Error('failed') }
setTimeout(callback, 1000)
const width = 768

// CORRECT: Self-documenting
const MAX_RETRIES = 5
const DEBOUNCE_MS = 1_000
const TABLET_BREAKPOINT = 768

if (retries > MAX_RETRIES) { throw new Error('failed') }
setTimeout(callback, DEBOUNCE_MS)
```

### Discriminated Unions over Boolean Flags

```typescript
// WRONG: Boolean soup — what does isSpecial + isUrgent + isInternal mean?
interface Ticket {
  isSpecial: boolean
  isUrgent: boolean
  isInternal: boolean
}

// CORRECT: States are explicit, exhaustive, and self-documenting
type TicketPriority = 'low' | 'normal' | 'urgent' | 'critical'
type TicketSource = 'customer' | 'internal' | 'automated'

interface Ticket {
  priority: TicketPriority
  source: TicketSource
}
```

---

## 2. Declarative over Imperative

Tell WHAT should happen, not HOW. Hide the "how" behind well-named abstractions.

### Conditional Rendering (React)

```typescript
// WRONG: Imperative branching inside JSX
function UserProfile({ user }: { user: User | null }) {
  if (user === null) {
    return <div>loading...</div>
  }
  return (
    <div>
      {user.role === 'admin' ? <AdminBadge /> : null}
      {user.notifications.length > 0 ? (
        <NotificationList items={user.notifications} />
      ) : (
        <EmptyState message="No notifications" />
      )}
    </div>
  )
}

// CORRECT: Declarative — each concern is a named component or extracted
function UserProfile({ user }: { user: User | null }) {
  if (user == null) {
    return <UserProfileSkeleton />
  }

  return (
    <div>
      <RoleBadge role={user.role} />
      <NotificationSection notifications={user.notifications} />
    </div>
  )
}
```

### Data Transformation

```typescript
// WRONG: Imperative mutation loop
function getActiveUserEmails(users: User[]): string[] {
  const result: string[] = []
  for (let i = 0; i < users.length; i++) {
    if (users[i].isActive) {
      result.push(users[i].email)
    }
  }
  return result
}

// CORRECT: Declarative pipeline — reads like a sentence
function getActiveUserEmails(users: User[]): string[] {
  return users
    .filter(user => user.isActive)
    .map(user => user.email)
}
```

### Declarative Error Handling (React)

```typescript
// WRONG: Manual loading/error state management in every component
function UserPage() {
  const [user, setUser] = useState<User | null>(null)
  const [error, setError] = useState<Error | null>(null)
  const [isLoading, setIsLoading] = useState(true)

  useEffect(() => {
    fetchUser()
      .then(setUser)
      .catch(setError)
      .finally(() => setIsLoading(false))
  }, [])

  if (isLoading) return <Spinner />
  if (error != null) return <ErrorMessage error={error} />
  if (user == null) return null

  return <UserProfile user={user} />
}

// CORRECT: Declarative with Suspense + ErrorBoundary
function UserPage() {
  return (
    <ErrorBoundary fallback={ErrorMessage}>
      <Suspense fallback={<Spinner />}>
        <UserProfile />
      </Suspense>
    </ErrorBoundary>
  )
}
```

---

## 3. Early Return & Guard Clauses

Eliminate nesting. Handle edge cases first, then express the happy path at the top level.

```typescript
// WRONG: Deeply nested — hard to follow
function processOrder(order: Order | null) {
  if (order != null) {
    if (order.status === 'pending') {
      if (order.items.length > 0) {
        if (order.payment != null) {
          return submitOrder(order)
        } else {
          throw new Error('No payment method')
        }
      } else {
        throw new Error('Empty order')
      }
    } else {
      throw new Error('Order not pending')
    }
  } else {
    throw new Error('No order')
  }
}

// CORRECT: Guard clauses — flat, readable, linear
function processOrder(order: Order | null) {
  if (order == null) {
    throw new InvalidOrderError('No order provided')
  }
  if (order.status !== 'pending') {
    throw new InvalidOrderError('Order is not in pending status')
  }
  if (order.items.length === 0) {
    throw new InvalidOrderError('Order has no items')
  }
  if (order.payment == null) {
    throw new InvalidOrderError('No payment method attached')
  }

  return submitOrder(order)
}
```

---

## 4. Single Responsibility Principle (SRP)

Every function, hook, and component should do ONE thing.

```typescript
// WRONG: Component does fetching, transforming, and rendering
function UserDashboard() {
  const [users, setUsers] = useState<User[]>([])

  useEffect(() => {
    fetch('/api/users')
      .then(res => res.json())
      .then(data => setUsers(data.filter(u => u.isActive)))
  }, [])

  const sortedUsers = [...users].sort((a, b) => b.score - a.score)

  return <UserList users={sortedUsers} />
}

// CORRECT: Each concern is isolated
function useActiveUsers() {
  return useQuery({
    queryKey: ['users', 'active'],
    queryFn: () => fetchUsers({ isActive: true }),
    select: (users) => [...users].sort((a, b) => b.score - a.score),
  })
}

function UserDashboard() {
  const { data: users } = useActiveUsers()

  return <UserList users={users} />
}
```

---

## 5. DRY — But Never Premature Abstraction

**Rule of Three**: Duplicate first, abstract second.

```typescript
// First time: just write it
// Second time: note the duplication, but leave it
// Third time: NOW extract an abstraction

// WRONG: Premature abstraction for one use case
function createGenericEntityManager<T extends BaseEntity>(config: EntityConfig<T>) { ... }

// CORRECT: Extract only when the pattern is proven (3+ occurrences)
function formatCurrency(amount: number, currency: string = 'KRW'): string {
  return new Intl.NumberFormat('ko-KR', { style: 'currency', currency }).format(amount)
}
```

**Prefer duplication over the wrong abstraction.** A bad abstraction is worse than repeated code — it creates coupling that's hard to undo.

---

## 6. Composition & Custom Hooks

### Hook Composition

```typescript
// WRONG: God hook that does everything
function useUser() {
  const [user, setUser] = useState(null)
  const [isEditing, setIsEditing] = useState(false)
  const [formData, setFormData] = useState({})
  const [validationErrors, setValidationErrors] = useState({})
  // ... 100 lines of mixed concerns
}

// CORRECT: Composed from focused hooks
function useUser(userId: string) {
  return useQuery({ queryKey: ['user', userId], queryFn: () => fetchUser(userId) })
}

function useUserForm(user: User) {
  const [formData, setFormData] = useState(() => toFormData(user))
  const validationErrors = useFormValidation(formData, userSchema)

  return { formData, setFormData, validationErrors }
}
```

### Component Composition

```typescript
// WRONG: Prop drilling and conditional rendering soup
<Card
  title={title}
  showHeader={true}
  showFooter={hasActions}
  footerActions={actions}
  headerRight={<Badge />}
  variant="outlined"
/>

// CORRECT: Compound components — flexible and readable
<Card variant="outlined">
  <Card.Header>
    <Card.Title>{title}</Card.Title>
    <Badge />
  </Card.Header>
  <Card.Body>{children}</Card.Body>
  {hasActions && (
    <Card.Footer>
      <ActionButtons actions={actions} />
    </Card.Footer>
  )}
</Card>
```

---

## 7. Type Safety as Documentation

### Exhaustive Pattern Matching

```typescript
type Status = 'idle' | 'loading' | 'success' | 'error'

function getStatusMessage(status: Status): string {
  switch (status) {
    case 'idle': return 'Ready to start'
    case 'loading': return 'Loading...'
    case 'success': return 'Completed successfully'
    case 'error': return 'Something went wrong'
    default: {
      const _exhaustive: never = status
      throw new Error(`Unhandled status: ${_exhaustive}`)
    }
  }
}
```

### Branded Types for Domain Primitives

```typescript
// WRONG: Primitives are interchangeable — easy to mix up
function transferMoney(from: string, to: string, amount: number) { ... }
transferMoney(toAccountId, fromAccountId, amount) // BUG: swapped — no type error

// CORRECT: Branded types prevent misuse at compile time
type AccountId = string & { readonly __brand: 'AccountId' }
type Money = number & { readonly __brand: 'Money' }

function transferMoney(from: AccountId, to: AccountId, amount: Money) { ... }
```

### Utility Types for Clean APIs

```typescript
// Use built-in utility types to express intent
type UserUpdate = Partial<Pick<User, 'name' | 'email' | 'avatar'>>
type ReadonlyUser = Readonly<User>
type CreateUserInput = Omit<User, 'id' | 'createdAt' | 'updatedAt'>
```

---

## 8. Immutability (CRITICAL)

NEVER mutate. ALWAYS create new references.

```typescript
// Objects
const updated = { ...user, name: newName }

// Arrays
const added = [...items, newItem]
const removed = items.filter(item => item.id !== targetId)
const replaced = items.map(item =>
  item.id === targetId ? { ...item, status: 'done' } : item
)

// Nested objects
const updated = {
  ...state,
  user: {
    ...state.user,
    address: { ...state.user.address, city: newCity },
  },
}
```

For deeply nested updates, use Immer when spread becomes unreadable:

```typescript
import { produce } from 'immer'

const nextState = produce(state, draft => {
  draft.user.address.city = newCity
})
```

---

## 9. File Organization

### Structure

```
src/
├── features/           # Feature-based modules
│   ├── auth/
│   │   ├── components/ # UI components for this feature
│   │   ├── hooks/      # Custom hooks
│   │   ├── services/   # API calls, business logic
│   │   ├── types.ts    # Feature-specific types
│   │   └── index.ts    # Public API (barrel export)
│   └── payment/
├── shared/             # Cross-feature utilities
│   ├── components/     # Reusable UI components
│   ├── hooks/          # Shared hooks
│   ├── lib/            # Utilities, helpers
│   └── types/          # Global types
└── app/                # Routes / pages (Next.js app dir)
```

### Size Limits

| Unit | Target | Hard Limit |
|------|--------|------------|
| Function | < 20 lines | 50 lines |
| Component | < 100 lines | 200 lines |
| File | 200–400 lines | 800 lines |
| Nesting depth | 2 levels | 4 levels |

### Naming

- **Component files**: `PascalCase.tsx` (`ThemeToggle.tsx`, `UserProfile.tsx`)
- **Utility/helper files**: `camelCase.ts` (`formatCurrency.ts`, `parseDate.ts`)
- **Hook files**: `useCamelCase.ts` (`useTheme.ts`, `useAuth.ts`)
- **Type files**: `camelCase.ts` (`types.ts`, `themeTypes.ts`)
- **Component names**: `PascalCase` (`UserProfile`, `PaymentForm`)
- **Hook names**: `useCamelCase` (`useAuth`, `useDebounce`)
- **Utility names**: `camelCase` (`formatCurrency`, `parseDate`)
- **Constants**: `UPPER_SNAKE_CASE` (`MAX_RETRIES`, `API_BASE_URL`)
- **Types**: `PascalCase` (`User`, `ApiResponse<T>`)

---

## 10. Error Handling

Handle at boundaries. Let errors propagate through internal layers.

```typescript
// Domain layer: throw specific, typed errors
class AppError extends Error {
  constructor(
    message: string,
    public readonly code: string,
    public readonly statusCode: number = 500,
  ) {
    super(message)
    this.name = 'AppError'
  }
}

class NotFoundError extends AppError {
  constructor(resource: string, id: string) {
    super(`${resource} with id ${id} not found`, 'NOT_FOUND', 404)
  }
}

// Boundary: catch and format
async function handleRequest<T>(fn: () => Promise<T>): Promise<ApiResponse<T>> {
  try {
    const data = await fn()
    return { success: true, data }
  } catch (error) {
    if (error instanceof AppError) {
      return { success: false, error: error.message, code: error.code }
    }
    return { success: false, error: 'Internal server error', code: 'INTERNAL' }
  }
}
```

---

## Quality Checklist

Before marking work complete — every item must pass:

- [ ] Every conditional expresses explicit intent (no implicit falsy)
- [ ] Functions do ONE thing (SRP)
- [ ] No nesting deeper than 3 levels (use guard clauses)
- [ ] Declarative patterns used where possible
- [ ] Types express domain constraints (discriminated unions, branded types)
- [ ] Immutable data flow throughout
- [ ] No magic numbers — all values named
- [ ] No `console.log` in production code
- [ ] File < 800 lines, function < 50 lines
- [ ] A senior engineer at Toss would approve this in code review
