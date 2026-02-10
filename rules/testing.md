# Testing Requirements

Tests are not overhead — they are the specification. Untested code is unfinished code.

---

## 1. Coverage Targets

| Code Type | Minimum | Target |
|-----------|---------|--------|
| Business logic / utilities | 80% | 95% |
| API endpoints | 80% | 90% |
| UI components | 70% | 80% |
| Critical paths (auth, payments) | 95% | 100% |

Global minimum: **80%**. Anything below blocks the PR.

---

## 2. Test Types

All three are required for production code:

### Unit Tests
- Individual functions, utilities, custom hooks, pure components
- Fast (< 100ms per test), isolated, no network/DB
- Mock external dependencies

```typescript
describe('formatCurrency', () => {
  it('formats KRW with no decimal places', () => {
    expect(formatCurrency(10000, 'KRW')).toBe('₩10,000')
  })

  it('returns ₩0 for zero amount', () => {
    expect(formatCurrency(0, 'KRW')).toBe('₩0')
  })

  it('handles negative amounts', () => {
    expect(formatCurrency(-5000, 'KRW')).toBe('-₩5,000')
  })
})
```

### Integration Tests
- API endpoint request/response cycles
- Database operations with test database
- Service-to-service interactions
- Middleware chains

```typescript
describe('POST /api/orders', () => {
  it('creates an order with valid input', async () => {
    const response = await request(app)
      .post('/api/orders')
      .send({ productId: 'abc-123', quantity: 2 })
      .expect(201)

    expect(response.body.success).toBe(true)
    expect(response.body.data.quantity).toBe(2)
  })

  it('rejects invalid quantity with 400', async () => {
    const response = await request(app)
      .post('/api/orders')
      .send({ productId: 'abc-123', quantity: -1 })
      .expect(400)

    expect(response.body.success).toBe(false)
  })

  it('requires authentication', async () => {
    await request(app)
      .post('/api/orders')
      .send({ productId: 'abc-123', quantity: 1 })
      .expect(401)
  })
})
```

### E2E Tests (Playwright)
- Critical user journeys: signup → login → core action → result
- Cross-browser (Chromium, Firefox, WebKit)
- Visual regression for key pages

```typescript
test('user can complete checkout flow', async ({ page }) => {
  await page.goto('/products')
  await page.click('[data-testid="product-card"]')
  await page.click('[data-testid="add-to-cart"]')
  await page.click('[data-testid="checkout-button"]')

  await page.fill('[data-testid="email-input"]', 'test@example.com')
  await page.click('[data-testid="confirm-order"]')

  await expect(page.locator('[data-testid="order-success"]')).toBeVisible()
})
```

---

## 3. Test-Driven Development (TDD)

MANDATORY workflow for new features and bug fixes:

```
1. RED      → Write a failing test that defines expected behavior
2. GREEN    → Write the MINIMUM code to make it pass
3. REFACTOR → Improve code quality while tests stay green
4. VERIFY   → Check coverage meets threshold
```

**Never write implementation before the test.**

For bug fixes: write a test that reproduces the bug FIRST, then fix.

---

## 4. Test Quality Standards

### Name Tests by Behavior

```typescript
// WRONG: Describes the function, not the behavior
it('test getUserById')
it('should work correctly')
it('handles edge case')

// CORRECT: Describes what happens and when
it('returns null when user does not exist')
it('throws AuthError when token is expired')
it('retries up to 3 times on network failure')
it('formats negative currency with minus sign prefix')
```

### Arrange-Act-Assert (AAA)

```typescript
it('calculates discount for premium users', () => {
  // Arrange — set up the scenario
  const user = createUser({ tier: 'premium' })
  const cart = createCart({ total: 10000 })

  // Act — execute the behavior
  const discount = calculateDiscount(user, cart)

  // Assert — verify the outcome
  expect(discount).toBe(1000)
})
```

### One Concept per Test

```typescript
// WRONG: Testing multiple behaviors in one test
it('handles user operations', () => {
  const user = createUser({ name: 'Kim' })
  expect(user.name).toBe('Kim')

  const updated = updateUser(user, { name: 'Lee' })
  expect(updated.name).toBe('Lee')
  expect(user.name).toBe('Kim') // immutability check

  const deleted = deleteUser(updated)
  expect(deleted).toBeNull()
})

// CORRECT: Each test verifies one thing
it('creates user with given name', () => { ... })
it('updates user without mutating original', () => { ... })
it('returns null after deletion', () => { ... })
```

### Test the Interface, Not the Implementation

```typescript
// WRONG: Testing internal state and implementation details
it('sets internal loading flag', () => {
  const { result } = renderHook(() => useUsers())
  expect(result.current._internalState.loading).toBe(true)
})

// CORRECT: Testing the public interface
it('indicates loading state while fetching', () => {
  const { result } = renderHook(() => useUsers())
  expect(result.current.isLoading).toBe(true)
})
```

---

## 5. Component Testing (React Testing Library)

### Test User Behavior, Not DOM Structure

```typescript
// WRONG: Testing implementation details
expect(container.querySelector('.btn-primary')).toBeTruthy()
expect(wrapper.find('Button').prop('disabled')).toBe(true)

// CORRECT: Testing what the user sees and does
expect(screen.getByRole('button', { name: 'Submit' })).toBeDisabled()

await userEvent.click(screen.getByRole('button', { name: 'Submit' }))
expect(screen.getByText('Order confirmed')).toBeInTheDocument()
```

### Query Priority (in order of preference)

1. `getByRole` — accessible queries (best)
2. `getByLabelText` — form elements
3. `getByPlaceholderText` — inputs
4. `getByText` — non-interactive elements
5. `getByTestId` — last resort

---

## 6. What NOT to Test

- Third-party library internals (React, Next.js, Zod — trust them)
- CSS styling and visual layout (use visual regression tools instead)
- Implementation details (internal state, private methods)
- Trivial getters/setters with no logic
- Generated code (Prisma client, GraphQL codegen)

---

## 7. Troubleshooting Test Failures

1. Use the **tdd-guide** agent for guidance
2. Check test isolation — no shared mutable state between tests
3. Verify mocks match the real interface signature
4. Check async timing — use `waitFor`, `findBy`, not arbitrary timeouts
5. Fix the implementation, not the test (unless the test is wrong)
6. For flaky tests: check async race conditions, network mocks, test ordering

## Agent Support

- **tdd-guide** — Use proactively for new features. Enforces test-first workflow.
- **e2e-runner** — Playwright E2E testing. Use for critical user flows.
