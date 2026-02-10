# Git Workflow

Commits tell the story of a project. Write them for the person reading the history six months from now.

---

## 1. Commit Message Format

```
<type>: <concise description of what changed>

<optional body: explain WHY, not WHAT>

<optional footer: breaking changes, issue refs>
```

### Types

| Type | When to Use |
|------|-------------|
| `feat` | New feature or capability |
| `fix` | Bug fix |
| `refactor` | Code change that doesn't add features or fix bugs |
| `docs` | Documentation only |
| `test` | Adding or updating tests |
| `chore` | Build, CI, tooling, dependency updates |
| `perf` | Performance improvement |
| `ci` | CI/CD pipeline changes |

### Examples

```
feat: add email verification to signup flow

Users now receive a verification email after registration.
Unverified accounts are restricted to read-only access
until email is confirmed.

Closes #142
```

```
fix: prevent duplicate orders on rapid button clicks

Debounce the submit handler and disable the button
during API call to prevent race condition.
```

```
refactor: extract payment validation into dedicated service

Payment validation logic was duplicated across three
endpoints. Consolidated into PaymentValidator service.
```

### Bad Commit Messages

```
# TOO VAGUE — says nothing useful
fix: fix bug
feat: update
chore: stuff
refactor: refactor code

# TOO LONG — put details in the body
feat: add email verification flow that sends a verification email to the user after they register and restricts their account to read-only access until they verify
```

---

## 2. Branching Strategy

```
main (always deployable)
├── feature/user-email-verification
├── fix/duplicate-order-prevention
├── refactor/extract-payment-validator
└── chore/upgrade-next-15
```

### Rules

- Branch from `main` (or the team's agreed base branch)
- Prefix with type: `feature/`, `fix/`, `refactor/`, `chore/`
- Use kebab-case: `feature/add-cart-page` not `feature/addCartPage`
- Keep branches short-lived — merge within days, not weeks
- Delete branches after merge
- Never commit directly to `main`

---

## 3. Pull Request Workflow

### Before Opening a PR

1. Rebase on latest `main` — resolve conflicts locally
2. Run the full test suite — all tests must pass
3. Run linter and type checker — zero errors
4. Self-review the diff — read every changed line

### Writing the PR

```markdown
## Summary
- What changed and why (1-3 bullet points)

## Test Plan
- [ ] Unit tests added for new validation logic
- [ ] Integration test for the /api/verify endpoint
- [ ] Manual test: signup → verify email → confirm access

## Screenshots (if UI changed)
Before | After
```

### PR Checklist

- [ ] Title is clear and under 70 characters
- [ ] Description explains the WHY, not just the WHAT
- [ ] All CI checks pass
- [ ] Test coverage maintained or improved
- [ ] No unrelated changes included (keep PRs focused)
- [ ] Breaking changes documented
- [ ] Self-reviewed the entire diff

---

## 4. Code Review Culture

### As a Reviewer

- Review within 24 hours — don't block teammates
- Focus on: correctness, security, readability, test coverage
- Distinguish between blockers and suggestions
  - **Blocker**: "This has a SQL injection vulnerability" → must fix
  - **Suggestion**: "Consider renaming this variable" → nice to have
- Explain WHY, not just WHAT: "This could leak user data because..." not just "Fix this"

### As an Author

- Keep PRs small (< 400 lines changed) — easier to review, faster to merge
- Respond to all comments, even if just "Done" or "Won't change because..."
- Don't take feedback personally — the code is being reviewed, not you
- If a PR is getting too big, split it into stacked PRs

---

## 5. Feature Implementation Flow

Every feature follows this order:

```
1. Plan     → Use planner agent. Break down scope.
2. Spec     → Write spec document for non-trivial features.
3. Branch   → Create feature branch from main.
4. TDD      → Write tests first → implement → refactor.
5. Review   → Run code-reviewer agent. Fix CRITICAL/HIGH issues.
6. Commit   → Incremental commits. One logical change per commit.
7. PR       → Open PR with summary and test plan.
8. Address  → Respond to review feedback.
9. Merge    → Squash if history is noisy. Delete branch.
```

---

## 6. Commit Discipline

### DO

- Commit early, commit often — each commit is one logical unit
- Write the message before making the commit (clarifies thinking)
- Stage specific files: `git add src/auth/` not `git add .`

### DO NOT

- Commit `.env` files, secrets, `node_modules/`, build artifacts
- Use `--force` push on shared branches
- Amend commits that are already pushed
- Mix unrelated changes in one commit
- Leave `console.log`, `TODO`, or commented-out code in commits
