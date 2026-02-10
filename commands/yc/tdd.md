---
description: "Enforce test-driven development. Write tests FIRST (RED), implement minimal code (GREEN), refactor (IMPROVE). Target 80%+ coverage."
---

# TDD Command

Implement features using strict test-driven development methodology.

## What This Command Does

1. **Scaffold Interfaces** - Define types and contracts first
2. **Write Failing Tests** - Tests before implementation (RED)
3. **Implement Minimal Code** - Just enough to pass tests (GREEN)
4. **Refactor** - Improve code while keeping tests green (IMPROVE)
5. **Verify Coverage** - Ensure 80%+ test coverage

## When to Use

Use `/yc:tdd` when:
- Implementing new features or functions
- Adding new components with logic
- Fixing bugs (write test that reproduces bug first)
- Refactoring existing code (write characterization tests first)
- Building critical business logic

## TDD Cycle

```
RED --> GREEN --> REFACTOR --> REPEAT

RED:      Write a test that FAILS (because code doesn't exist)
GREEN:    Write the MINIMUM code to make it pass
REFACTOR: Improve code quality while tests stay green
REPEAT:   Next test case / scenario
```

## How It Works

### Step 1: Define Interface (SCAFFOLD)

```typescript
// Define the shape before writing any logic
export interface ProcessInput {
  value: string
  options?: ProcessOptions
}

export interface ProcessResult {
  status: 'success' | 'error'
  data: string | null
  metadata: { processedAt: Date; duration: number }
}

export function processItem(input: ProcessInput): ProcessResult {
  throw new Error('Not implemented')
}
```

### Step 2: Write Failing Test (RED)

```typescript
import { processItem } from './processor'

describe('processItem', () => {
  it('returns success for valid input', () => {
    const result = processItem({ value: 'test-data' })

    expect(result.status).toBe('success')
    expect(result.data).not.toBeNull()
  })

  it('returns error for empty input', () => {
    const result = processItem({ value: '' })

    expect(result.status).toBe('error')
    expect(result.data).toBeNull()
  })

  it('includes processing metadata', () => {
    const result = processItem({ value: 'test-data' })

    expect(result.metadata.processedAt).toBeInstanceOf(Date)
    expect(result.metadata.duration).toBeGreaterThanOrEqual(0)
  })
})
```

### Step 3: Run Tests - Verify FAIL

```bash
npm test -- processor.test.ts

FAIL processor.test.ts
  x returns success for valid input
    Error: Not implemented
```

Tests fail as expected. Ready to implement.

### Step 4: Implement Minimal Code (GREEN)

Write the minimum code to make all tests pass. No more, no less.

### Step 5: Run Tests - Verify PASS

```bash
npm test -- processor.test.ts

PASS processor.test.ts
  ✓ returns success for valid input
  ✓ returns error for empty input
  ✓ includes processing metadata
```

### Step 6: Refactor (IMPROVE)

Improve code while keeping tests green:
- Extract named constants
- Simplify complex expressions
- Improve naming
- Remove duplication

Run tests after every refactor step.

### Step 7: Check Coverage

```bash
npm test -- --coverage processor.test.ts

File           | % Stmts | % Branch | % Funcs | % Lines
---------------|---------|----------|---------|--------
processor.ts   |   95    |    90    |   100   |    95
```

If below 80%, add tests for uncovered branches.

## Test Categories

**Unit Tests** (per function):
- Happy path with valid input
- Edge cases (empty, null, boundary values)
- Error conditions
- Type variants (each union member)

**Integration Tests** (per feature):
- API request → response cycle
- Database read → write → verify
- Component render → interact → verify state

**E2E Tests** (use `/yc:e2e` command):
- Critical user flows end-to-end

## Coverage Requirements

| Code Type | Minimum | Target |
|-----------|---------|--------|
| Business logic | 80% | 95% |
| Utility functions | 80% | 100% |
| API endpoints | 70% | 90% |
| UI components | 60% | 80% |
| Critical paths (auth, payments) | 95% | 100% |

## Best Practices

**DO:**
- Write the test FIRST, before any implementation
- Run tests after every change
- Write minimal code to pass (resist over-engineering)
- Test behavior, not implementation details
- Use descriptive test names: "returns error when email is invalid"

**DON'T:**
- Write implementation before tests
- Skip the RED phase (verify tests actually fail)
- Write too much code at once
- Test private methods directly
- Mock everything (prefer real dependencies when feasible)
- Ignore failing tests

## Integration with Other Commands

- `/yc:brainstorm` or `/yc:spec` first to understand what to build
- `/yc:plan` to break work into phases
- `/yc:tdd` to implement each phase
- `/yc:build-fix` if build errors occur during implementation
- `/yc:code-review` to review completed implementation
- `/yc:test-coverage` to verify overall coverage

## Related Agent

This command invokes the `tdd-guide` agent.
