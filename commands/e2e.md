---
description: "Generate and run end-to-end tests with Playwright. Create test journeys for critical user flows, capture artifacts on failure, detect flaky tests."
---

# E2E Command

Generate and run Playwright end-to-end tests for critical user flows.

## What This Command Does

1. **Identify Critical Flows** - Map the user journeys that matter most
2. **Generate Tests** - Create Playwright tests with Page Object Model
3. **Run Across Browsers** - Chromium, Firefox, WebKit
4. **Capture Artifacts** - Screenshots, videos, traces on failure
5. **Detect Flaky Tests** - Identify unreliable tests and quarantine them

## When to Use

Use `/e2e` when:
- Implementing critical user flows (auth, checkout, onboarding)
- After significant UI changes
- Before major releases
- When integration tests aren't sufficient
- To verify cross-browser compatibility

## How It Works

### Step 1: Identify Test Journeys

Map the critical user paths:

```markdown
## Critical Journeys

1. **Authentication Flow**
   - Register -> Verify Email -> Login -> Dashboard

2. **Core Feature Flow**
   - Browse -> Select -> Configure -> Submit -> Confirm

3. **Settings Flow**
   - Profile -> Edit -> Save -> Verify Changes
```

### Step 2: Generate Tests with Page Objects

**Page Object:**
```typescript
import { Page, Locator } from '@playwright/test'

export class DashboardPage {
  readonly page: Page
  readonly heading: Locator
  readonly createButton: Locator
  readonly itemList: Locator

  constructor(page: Page) {
    this.page = page
    this.heading = page.getByRole('heading', { name: 'Dashboard' })
    this.createButton = page.getByRole('button', { name: 'Create' })
    this.itemList = page.getByTestId('item-list')
  }

  async goto() {
    await this.page.goto('/dashboard')
    await this.heading.waitFor()
  }

  async getItemCount(): Promise<number> {
    return this.itemList.locator('[data-testid="item"]').count()
  }
}
```

**Test:**
```typescript
import { test, expect } from '@playwright/test'
import { DashboardPage } from '../pages/dashboard-page'

test.describe('Dashboard', () => {
  let dashboard: DashboardPage

  test.beforeEach(async ({ page }) => {
    dashboard = new DashboardPage(page)
    await dashboard.goto()
  })

  test('user sees dashboard after login', async () => {
    await expect(dashboard.heading).toBeVisible()
  })

  test('user can create a new item', async ({ page }) => {
    await dashboard.createButton.click()
    await page.getByLabel('Name').fill('Test Item')
    await page.getByRole('button', { name: 'Submit' }).click()
    await expect(page.getByText('Created successfully')).toBeVisible()
  })
})
```

### Step 3: Locator Priority (Accessibility First)

Use locators in this order:
1. `getByRole('button', { name: 'Submit' })` - Best: semantic role
2. `getByLabel('Email')` - Form elements
3. `getByPlaceholder('Search...')` - Input hints
4. `getByText('Welcome')` - Visible text
5. `getByTestId('card')` - Last resort: test IDs

### Step 4: Run and Analyze

```bash
npx playwright test                          # Run all
npx playwright test --project=chromium       # Single browser
npx playwright test tests/auth               # Specific folder
npx playwright test --headed                 # Watch execution
npx playwright test --trace on               # Capture trace
npx playwright show-report                   # View HTML report
```

### Step 5: Handle Flaky Tests

```typescript
// Quarantine flaky tests
test('unreliable feature', async ({ page }) => {
  test.fixme(true, 'Flaky - tracked in issue #123')
})
```

**Verify stability:**
```bash
npx playwright test --repeat-each=5 tests/suspect.spec.ts
```

## Test Structure

```
tests/
├── e2e/
│   ├── auth/
│   │   ├── login.spec.ts
│   │   └── register.spec.ts
│   ├── dashboard/
│   │   └── dashboard.spec.ts
│   └── settings/
│       └── profile.spec.ts
├── pages/
│   ├── base-page.ts
│   ├── login-page.ts
│   └── dashboard-page.ts
└── fixtures/
    └── test-data.ts
```

## Success Metrics

| Metric | Target |
|--------|--------|
| Critical journeys passing | 100% |
| Overall pass rate | > 95% |
| Flaky test rate | < 5% |
| Total suite duration | < 10 minutes |
| Artifacts captured on failure | 100% |

## Integration with Other Commands

- `/spec` to define the user flows to test
- `/tdd` for unit/integration tests
- `/test-coverage` to verify overall coverage
- `/code-review` after tests are written

## Related Agent

This command invokes the `e2e-runner` agent.
