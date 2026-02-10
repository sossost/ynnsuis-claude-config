---
name: coding-standards
description: Universal coding standards and best practices for TypeScript, React, and Node.js development. Quick reference for code quality principles.
---

# Coding Standards Quick Reference

Universal standards applicable across all projects. For detailed patterns, see `rules/coding-style.md`.

## Core Principles

1. **Explicit Intent** - Code should say what it means
2. **Declarative First** - Tell WHAT, not HOW
3. **Early Return** - Guard clauses at the top
4. **Single Responsibility** - One function, one job
5. **Composition** - Small composable pieces over large monoliths
6. **DRY with Discipline** - Duplicate twice, abstract on third
7. **Immutability** - Never mutate, always create new
8. **Type Safety** - Types are documentation that compiles

## Explicit Null Checks (CRITICAL)

```typescript
// WRONG: Implicit falsy check
if (!value) { ... }  // catches 0, '', false too

// CORRECT: Explicit null check
if (value == null) { ... }  // null or undefined only
```

## Named Constants (No Magic Numbers)

```typescript
// WRONG
if (retryCount > 3) { ... }
setTimeout(fn, 500)

// CORRECT
const MAX_RETRIES = 3
const DEBOUNCE_DELAY_MS = 500
if (retryCount > MAX_RETRIES) { ... }
setTimeout(fn, DEBOUNCE_DELAY_MS)
```

## Discriminated Unions (No Boolean Flags)

```typescript
// WRONG
interface Modal { isOpen: boolean; isLoading: boolean; data?: Data; error?: Error }

// CORRECT
type ModalState =
  | { status: 'closed' }
  | { status: 'loading' }
  | { status: 'success'; data: Data }
  | { status: 'error'; error: Error }
```

## Early Return

```typescript
// WRONG: Deep nesting
function process(user, item) {
  if (user) {
    if (user.isActive) {
      if (item) {
        return doWork(user, item)
      }
    }
  }
  return null
}

// CORRECT: Guard clauses
function process(user, item) {
  if (user == null) return null
  if (!user.isActive) return null
  if (item == null) return null
  return doWork(user, item)
}
```

## Immutability

```typescript
// WRONG: Mutation
function updateUser(user, name) {
  user.name = name
  return user
}

// CORRECT: New object
function updateUser(user, name) {
  return { ...user, name }
}

// Arrays
const added = [...items, newItem]
const removed = items.filter(i => i.id !== targetId)
const updated = items.map(i => i.id === targetId ? { ...i, name } : i)
```

## Function Size & File Size

| Metric | Limit |
|--------|-------|
| Function body | < 50 lines |
| File length | < 800 lines |
| Nesting depth | < 4 levels |
| Function parameters | < 4 (use options object) |

## Naming Conventions

```typescript
// Booleans: is/has/should/can prefix
const isLoading = true
const hasPermission = false
const shouldRefetch = true

// Functions: verb-noun
function fetchUserData() { ... }
function calculateTotal() { ... }
function validateEmail() { ... }

// Components: PascalCase
function UserProfile() { ... }

// Constants: UPPER_SNAKE_CASE
const MAX_RETRIES = 3
const API_BASE_URL = '/api'
```

## Error Handling

```typescript
// ALWAYS handle errors at boundaries
try {
  const result = await riskyOperation()
  return result
} catch (error) {
  if (error instanceof ValidationError) {
    return { success: false, error: error.message }
  }
  console.error('Unexpected error:', error)
  throw new AppError('Operation failed')
}
```

## Async Patterns

```typescript
// Parallel when independent
const [users, items] = await Promise.all([
  fetchUsers(),
  fetchItems()
])

// Sequential when dependent
const user = await fetchUser(id)
const orders = await fetchOrders(user.accountId)
```

## Component Patterns

```typescript
// Props interface always defined
interface ButtonProps {
  children: React.ReactNode
  onClick: () => void
  variant?: 'primary' | 'secondary'
  disabled?: boolean
}

// Destructure with defaults
export function Button({
  children,
  onClick,
  variant = 'primary',
  disabled = false
}: ButtonProps) {
  return (
    <button
      onClick={onClick}
      disabled={disabled}
      className={`btn btn-${variant}`}
    >
      {children}
    </button>
  )
}
```

## Quality Checklist

Before marking work complete:

- [ ] Code is readable and well-named
- [ ] Functions < 50 lines, files < 800 lines
- [ ] No deep nesting (> 4 levels)
- [ ] Proper error handling at boundaries
- [ ] No console.log statements
- [ ] No hardcoded values (use named constants)
- [ ] No mutation (immutable patterns)
- [ ] Explicit null checks (no `!value`)
- [ ] Types used throughout (no `any`)
- [ ] Tests written and passing
