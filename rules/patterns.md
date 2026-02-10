# Patterns & Templates

Reusable code patterns and document templates for consistent, high-quality output.

---

## Code Patterns

### API Response Format

Every API endpoint returns this shape. No exceptions.

```typescript
interface ApiResponse<T> {
  success: boolean
  data?: T
  error?: {
    code: string
    message: string
    details?: unknown
  }
  meta?: {
    total: number
    page: number
    limit: number
    hasNextPage: boolean
  }
}

// Usage
return res.json({
  success: true,
  data: users,
  meta: { total: 100, page: 1, limit: 20, hasNextPage: true },
})

return res.status(404).json({
  success: false,
  error: { code: 'NOT_FOUND', message: 'User not found' },
})
```

### Repository Pattern

```typescript
interface Repository<T, CreateInput, UpdateInput> {
  findAll(filters?: Partial<T>, pagination?: Pagination): Promise<PaginatedResult<T>>
  findById(id: string): Promise<T | null>
  create(data: CreateInput): Promise<T>
  update(id: string, data: UpdateInput): Promise<T>
  delete(id: string): Promise<void>
}
```

### Custom Hook Pattern

```typescript
// Encapsulate one concern. Return a clean interface.
export function useDebounce<T>(value: T, delay: number): T {
  const [debouncedValue, setDebouncedValue] = useState<T>(value)

  useEffect(() => {
    const timer = setTimeout(() => setDebouncedValue(value), delay)
    return () => clearTimeout(timer)
  }, [value, delay])

  return debouncedValue
}

// Compose hooks for complex behavior
export function useSearch(query: string) {
  const debouncedQuery = useDebounce(query, 300)

  return useQuery({
    queryKey: ['search', debouncedQuery],
    queryFn: () => searchApi(debouncedQuery),
    enabled: debouncedQuery.length >= 2,
  })
}
```

### Compound Component Pattern

```typescript
// Parent provides context, children consume it
const TabsContext = createContext<TabsContextValue | null>(null)

function Tabs({ defaultValue, children }: TabsProps) {
  const [activeTab, setActiveTab] = useState(defaultValue)

  return (
    <TabsContext.Provider value={{ activeTab, setActiveTab }}>
      <div role="tablist">{children}</div>
    </TabsContext.Provider>
  )
}

function TabTrigger({ value, children }: TabTriggerProps) {
  const { activeTab, setActiveTab } = useTabsContext()
  const isActive = activeTab === value

  return (
    <button
      role="tab"
      aria-selected={isActive}
      onClick={() => setActiveTab(value)}
    >
      {children}
    </button>
  )
}

function TabContent({ value, children }: TabContentProps) {
  const { activeTab } = useTabsContext()
  if (activeTab !== value) return null
  return <div role="tabpanel">{children}</div>
}

Tabs.Trigger = TabTrigger
Tabs.Content = TabContent

// Usage — declarative and readable
<Tabs defaultValue="profile">
  <Tabs.Trigger value="profile">Profile</Tabs.Trigger>
  <Tabs.Trigger value="settings">Settings</Tabs.Trigger>
  <Tabs.Content value="profile"><ProfileForm /></Tabs.Content>
  <Tabs.Content value="settings"><SettingsForm /></Tabs.Content>
</Tabs>
```

### Error Hierarchy Pattern

```typescript
// Base error with structured data
class AppError extends Error {
  constructor(
    message: string,
    public readonly code: string,
    public readonly statusCode: number = 500,
    public readonly details?: unknown,
  ) {
    super(message)
    this.name = this.constructor.name
  }
}

// Specific error types
class NotFoundError extends AppError {
  constructor(resource: string, id: string) {
    super(`${resource} not found: ${id}`, 'NOT_FOUND', 404)
  }
}

class ValidationError extends AppError {
  constructor(message: string, details?: unknown) {
    super(message, 'VALIDATION_ERROR', 400, details)
  }
}

class UnauthorizedError extends AppError {
  constructor(message: string = 'Authentication required') {
    super(message, 'UNAUTHORIZED', 401)
  }
}

class ForbiddenError extends AppError {
  constructor(message: string = 'Insufficient permissions') {
    super(message, 'FORBIDDEN', 403)
  }
}
```

---

## Document Templates

### Decision Record

Use when a non-trivial choice is made during ideation or implementation.

```markdown
# Decision: [Title]

**Date:** YYYY-MM-DD
**Status:** proposed | accepted | rejected | superseded by [DR-XXX]
**Participants:** [who was involved in the decision]

## Context
What problem or question prompted this decision?
What constraints exist?

## Options Considered

### Option A: [Name]
- **Pros:** ...
- **Cons:** ...
- **Effort:** S / M / L
- **Risk:** Low / Medium / High

### Option B: [Name]
- **Pros:** ...
- **Cons:** ...
- **Effort:** S / M / L
- **Risk:** Low / Medium / High

## Decision
Which option was chosen and WHY.
What was the key factor that tipped the decision?

## Consequences
- What changes as a result
- What trade-offs are accepted
- What follow-up work is needed
```

### Feature Spec

Use before implementing any non-trivial feature.

```markdown
# Spec: [Feature Name]

## Purpose
What problem does this solve? Who benefits? Why now?

## Requirements
### Functional
- [ ] Requirement 1
- [ ] Requirement 2

### Non-Functional
- [ ] Performance: page loads in < 2s
- [ ] Accessibility: keyboard navigable, screen reader compatible
- [ ] Security: input validated, authorized

## Scope
**In scope:** what this feature DOES cover
**Out of scope:** what this feature does NOT cover (important to prevent creep)

## Design

### Data Model
- Schema changes or new tables/collections

### API
| Method | Path | Description | Auth |
|--------|------|-------------|------|
| POST | /api/orders | Create order | Required |
| GET | /api/orders/:id | Get order detail | Required |

### UI
- Component breakdown or wireframe reference
- User flow: step 1 → step 2 → step 3

### Error Handling
| Scenario | Behavior |
|----------|----------|
| Invalid input | Show inline validation errors |
| Network failure | Show retry button with error message |
| Unauthorized | Redirect to login |

## Acceptance Criteria
- [ ] User can [action] and sees [result]
- [ ] Error state shows [message] when [condition]
- [ ] Works on mobile viewport (375px+)

## Open Questions
- [ ] Question that needs answering before implementation
```

### Task Breakdown

Use after spec is approved, before implementation begins.

```markdown
# Tasks: [Feature Name]

Estimated total: [X tasks, Y hours]

## Phase 1: Foundation
- [ ] Task 1 — set up data model and migrations
  - AC: migration runs, schema matches spec
- [ ] Task 2 — create API endpoint stubs with validation
  - AC: endpoints return 501, input validated

## Phase 2: Core Logic
- [ ] Task 3 — implement order creation service
  - AC: unit tests pass, handles edge cases
  - Depends on: Task 1
- [ ] Task 4 — implement order detail query
  - AC: returns correct data with pagination
  - Depends on: Task 1

## Phase 3: UI
- [ ] Task 5 — build order form component
  - AC: form validates, submits, shows loading/error states
  - Depends on: Task 2
- [ ] Task 6 — build order detail page
  - AC: displays all fields, handles loading/error
  - Depends on: Task 4

## Phase 4: Polish & Integration
- [ ] Task 7 — E2E test for complete order flow
  - Depends on: Tasks 5, 6
- [ ] Task 8 — accessibility audit and fixes
- [ ] Task 9 — performance check (LCP < 2.5s)

## Dependencies
Task 3, 4 → Task 1 (data model)
Task 5 → Task 2 (API stubs)
Task 7 → Tasks 5, 6 (UI complete)
```

---

## Skeleton Project Evaluation

When starting a new project or major feature:

1. **Search** for battle-tested starter templates / boilerplates
2. **Evaluate** by: security posture, update frequency, community size, tech stack match
3. **Clone** the best match as foundation
4. **Adapt** to project needs — don't fight the skeleton's conventions
5. **Remove** everything you don't need — dead code from day one is tech debt from day one
