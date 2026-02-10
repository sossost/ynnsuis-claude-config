---
name: tdd-workflow
description: Use this skill when writing new features, fixing bugs, or refactoring code. Enforces test-driven development with 80%+ coverage including unit, integration, and E2E tests.
---

# Test-Driven Development Workflow

Ensures all code development follows TDD principles with comprehensive test coverage.

## When to Activate

- Writing new features or functionality
- Fixing bugs or issues
- Refactoring existing code
- Adding API endpoints
- Creating new components

## TDD Workflow Steps

### Step 1: Write User Journeys

```
As a [role], I want to [action], so that [benefit]

Example:
As a user, I want to search for products by keyword,
so that I can quickly find what I'm looking for.
```

### Step 2: Generate Test Cases

```typescript
describe('ProductSearch', () => {
  it('returns relevant products for a query', async () => {
    // Test implementation
  })

  it('handles empty query gracefully', async () => {
    // Test edge case
  })

  it('returns empty array when no products match', async () => {
    // Test no-results case
  })

  it('sorts results by relevance score', async () => {
    // Test sorting logic
  })
})
```

### Step 3: Run Tests (They Should Fail)

```bash
npm test
# Tests should fail - we haven't implemented yet
```

### Step 4: Implement Code

Write minimal code to make tests pass.

### Step 5: Run Tests Again

```bash
npm test
# Tests should now pass
```

### Step 6: Refactor

Improve code quality while keeping tests green:
- Remove duplication
- Improve naming
- Optimize performance
- Enhance readability

### Step 7: Verify Coverage

```bash
npm test -- --coverage
# Verify 80%+ coverage achieved
```

## Testing Patterns

### Unit Test Pattern (Jest/Vitest)

```typescript
import { render, screen, fireEvent } from '@testing-library/react'
import { Button } from './Button'

describe('Button Component', () => {
  it('renders with correct text', () => {
    render(<Button>Click me</Button>)
    expect(screen.getByText('Click me')).toBeInTheDocument()
  })

  it('calls onClick when clicked', () => {
    const handleClick = vi.fn()
    render(<Button onClick={handleClick}>Click</Button>)

    fireEvent.click(screen.getByRole('button'))

    expect(handleClick).toHaveBeenCalledTimes(1)
  })

  it('is disabled when disabled prop is true', () => {
    render(<Button disabled>Click</Button>)
    expect(screen.getByRole('button')).toBeDisabled()
  })
})
```

### API Integration Test Pattern

```typescript
import { NextRequest } from 'next/server'
import { GET } from './route'

describe('GET /api/items', () => {
  it('returns items successfully', async () => {
    const request = new NextRequest('http://localhost/api/items')
    const response = await GET(request)
    const data = await response.json()

    expect(response.status).toBe(200)
    expect(data.success).toBe(true)
    expect(Array.isArray(data.data)).toBe(true)
  })

  it('validates query parameters', async () => {
    const request = new NextRequest('http://localhost/api/items?limit=invalid')
    const response = await GET(request)

    expect(response.status).toBe(400)
  })

  it('handles database errors gracefully', async () => {
    // Mock database failure and verify error handling
  })
})
```

### E2E Test Pattern (Playwright)

```typescript
import { test, expect } from '@playwright/test'

test('user can search and view results', async ({ page }) => {
  await page.goto('/')

  // Search for items
  await page.getByPlaceholder('Search...').fill('test query')

  // Wait for results
  await page.waitForResponse(r => r.url().includes('/api/search'))

  // Verify results displayed
  const results = page.getByTestId('result-item')
  await expect(results.first()).toBeVisible()
})
```

## Mocking Strategies

### API Client Mock

```typescript
vi.mock('@/lib/api-client', () => ({
  apiClient: {
    get: vi.fn(() => Promise.resolve({
      data: [{ id: '1', name: 'Test Item' }],
      error: null
    }))
  }
}))
```

### Database Mock

```typescript
vi.mock('@/lib/db', () => ({
  db: {
    query: vi.fn(() => Promise.resolve({
      rows: [{ id: '1', name: 'Test' }]
    }))
  }
}))
```

### External Service Mock

```typescript
vi.mock('@/lib/external-service', () => ({
  externalService: {
    process: vi.fn(() => Promise.resolve({ status: 'success' })),
    healthCheck: vi.fn(() => Promise.resolve({ connected: true }))
  }
}))
```

## Test File Organization

```
src/
├── features/
│   └── search/
│       ├── components/
│       │   ├── SearchBar.tsx
│       │   └── SearchBar.test.tsx       # Unit tests
│       ├── hooks/
│       │   ├── useSearch.ts
│       │   └── useSearch.test.ts
│       └── api/
│           ├── route.ts
│           └── route.test.ts            # Integration tests
└── tests/
    └── e2e/
        └── search.spec.ts              # E2E tests
```

## Coverage Thresholds

```json
{
  "coverageThreshold": {
    "global": {
      "branches": 80,
      "functions": 80,
      "lines": 80,
      "statements": 80
    }
  }
}
```

## Common Mistakes to Avoid

### Testing Implementation Details

```typescript
// WRONG: Testing internal state
expect(component.state.count).toBe(5)

// CORRECT: Test user-visible behavior
expect(screen.getByText('Count: 5')).toBeInTheDocument()
```

### Brittle Selectors

```typescript
// WRONG: Breaks on styling changes
await page.click('.css-class-xyz')

// CORRECT: Semantic selectors
await page.getByRole('button', { name: 'Submit' }).click()
```

### No Test Isolation

```typescript
// WRONG: Tests depend on each other
test('creates item', () => { /* ... */ })
test('updates same item', () => { /* depends on previous test */ })

// CORRECT: Each test has own setup
test('creates item', () => {
  const item = createTestItem()
  // ...
})

test('updates item', () => {
  const item = createTestItem()
  // ...
})
```

## Best Practices

1. **Write Tests First** - Always TDD
2. **One Assert Per Test** - Focus on single behavior
3. **Descriptive Test Names** - Explain what's tested
4. **Arrange-Act-Assert** - Clear test structure
5. **Mock External Dependencies** - Isolate unit tests
6. **Test Edge Cases** - Null, undefined, empty, boundary values
7. **Test Error Paths** - Not just happy paths
8. **Keep Tests Fast** - Unit tests < 50ms each
9. **Clean Up After Tests** - No side effects
10. **Review Coverage Reports** - Identify gaps
