---
description: "Analyze test coverage, identify gaps, and generate missing tests. Target 80%+ overall coverage with higher thresholds for critical code."
---

# Test Coverage Command

Analyze coverage gaps and generate tests to reach target thresholds.

## What This Command Does

1. **Run Coverage Analysis** - Collect coverage data from test suite
2. **Identify Gaps** - Find files and branches below threshold
3. **Prioritize** - Focus on critical code paths first
4. **Generate Tests** - Create tests for uncovered code
5. **Verify** - Re-run coverage to confirm improvement

## When to Use

Use `/test-coverage` when:
- Before creating a pull request
- After implementing a new feature
- Coverage CI check is failing
- You want to understand what's tested and what's not
- Reviewing code that lacks tests

## How It Works

### Step 1: Run Coverage

```bash
npm test -- --coverage
```

### Step 2: Analyze Report

Identify files below threshold:

| File | Statements | Branches | Functions | Lines | Status |
|------|-----------|----------|-----------|-------|--------|
| auth.ts | 95% | 90% | 100% | 95% | PASS |
| utils.ts | 72% | 65% | 80% | 70% | FAIL |
| api.ts | 45% | 30% | 50% | 40% | FAIL |

### Step 3: Prioritize by Risk

1. **Critical paths** (auth, payments, data integrity) - Target 95%+
2. **Business logic** (core features, calculations) - Target 80%+
3. **API endpoints** (request handling, validation) - Target 70%+
4. **UI components** (rendering, interactions) - Target 60%+

### Step 4: Generate Missing Tests

For each uncovered branch/function:
- Identify what scenario triggers it
- Write a test for that scenario
- Include edge cases (null, empty, boundary values)
- Run test to verify it covers the gap

### Step 5: Verify Improvement

```bash
npm test -- --coverage

# Compare before/after
# Before: 72% statements
# After:  85% statements
```

## Coverage Thresholds

| Code Type | Minimum | Target |
|-----------|---------|--------|
| Business logic | 80% | 95% |
| Critical paths (auth, payments) | 95% | 100% |
| Utility functions | 80% | 100% |
| API endpoints | 70% | 90% |
| UI components | 60% | 80% |
| Generated/config code | Skip | Skip |

## Focus Areas

When generating tests, prioritize:

1. **Happy paths** - Core functionality works as expected
2. **Error handling** - Errors are caught and handled correctly
3. **Edge cases** - Empty arrays, null values, boundary conditions
4. **Branch coverage** - Every if/else and switch case exercised
5. **Async behavior** - Loading states, race conditions, timeouts

## What NOT to Test

- Framework internals (React rendering, Express routing)
- Third-party library behavior
- Trivial getters/setters
- Static configuration
- CSS/styling

## Report Format

```markdown
# Coverage Report

**Overall:** 82% (+10% from baseline)
**Files Below Threshold:** 3 -> 0

## Improvements
| File | Before | After | Tests Added |
|------|--------|-------|-------------|
| utils.ts | 72% | 92% | 5 |
| api.ts | 45% | 85% | 8 |

## Remaining Gaps
- None above threshold

## Tests Generated
- utils.test.ts: 5 new test cases
- api.test.ts: 8 new test cases
```

## Integration with Other Commands

- `/tdd` for implementing new code with tests from the start
- `/e2e` for end-to-end coverage of user flows
- `/code-review` to verify changes before commit
