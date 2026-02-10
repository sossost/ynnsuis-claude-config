---
description: "Review uncommitted changes for security vulnerabilities, code quality issues, and adherence to coding standards. Block commit if CRITICAL or HIGH issues found."
---

# Code Review Command

Comprehensive security and quality review of uncommitted changes.

## What This Command Does

1. **Collect Changes** - Identify all modified and new files
2. **Security Scan** - Check for vulnerabilities (CRITICAL priority)
3. **Quality Review** - Check code against coding standards
4. **Best Practices** - Verify patterns, a11y, and test coverage
5. **Generate Report** - Severity-rated findings with fix suggestions
6. **Gate Commit** - Block if CRITICAL or HIGH issues exist

## When to Use

Use `/yc:code-review` when:
- Before committing changes
- After completing a feature or bug fix
- Before creating a pull request
- After refactoring code
- Whenever you want a quality check

## Review Checklist

### Security Issues (CRITICAL)

- [ ] No hardcoded credentials, API keys, or tokens
- [ ] No SQL injection vulnerabilities (queries parameterized)
- [ ] No XSS vulnerabilities (user input sanitized/escaped)
- [ ] All user input validated at system boundaries
- [ ] No sensitive data in logs or error messages
- [ ] Authentication/authorization verified on protected routes
- [ ] No path traversal or SSRF risks
- [ ] Dependencies free of known CVEs

### Explicit Intent (HIGH)

- [ ] No implicit falsy checks (`!value`) — use explicit null checks (`value == null`)
- [ ] No magic numbers — named constants with semantic meaning
- [ ] Boolean parameters replaced with options objects or descriptive names
- [ ] Discriminated unions used instead of boolean flags for state
- [ ] Function and variable names describe intent clearly

### Code Quality (HIGH)

- [ ] Functions under 50 lines
- [ ] Files under 800 lines
- [ ] Nesting depth 4 levels or fewer
- [ ] Every error is caught and handled meaningfully
- [ ] No `console.log` statements (use proper logging)
- [ ] No `any` types (use proper typing or `unknown`)
- [ ] Early returns used — happy path at indent level 0

### Architecture (MEDIUM)

- [ ] Single responsibility — one function does one thing
- [ ] No mutation — immutable patterns used (spread, map, Immer)
- [ ] DRY respected — no premature abstraction, but no copy-paste either
- [ ] Composition over inheritance — custom hooks, compound components
- [ ] Exhaustive switch statements for discriminated unions

### Best Practices (MEDIUM)

- [ ] New code has corresponding tests
- [ ] Accessibility: keyboard navigation, focus states, ARIA labels
- [ ] Loading and error states handled
- [ ] Responsive design considered
- [ ] No TODO/FIXME without a linked issue

## Report Format

```markdown
# Code Review Report

**Files Reviewed:** N
**Issues Found:** N (X Critical, Y High, Z Medium)

## CRITICAL
### [Title]
**File:** `src/file.ts:42`
**Issue:** [description]
**Fix:** [suggested solution]

## HIGH
### [Title]
**File:** `src/file.ts:87`
**Issue:** [description]
**Fix:** [suggested solution]

## MEDIUM
### [Title]
**File:** `src/file.ts:120`
**Issue:** [description]
**Fix:** [suggested solution]

## Verdict
- APPROVE: 0 critical, 0 high
- REQUEST CHANGES: any critical or high issues
- COMMENT: medium issues only
```

## Approval Criteria

| Verdict | Condition |
|---------|-----------|
| **APPROVE** | 0 critical + 0 high issues |
| **REQUEST CHANGES** | Any critical or high issue found |
| **COMMENT** | Medium issues only (non-blocking) |

## Integration with Other Commands

- `/yc:tdd` to fix quality issues with tests
- `/yc:build-fix` if review changes break the build
- `/yc:test-coverage` to verify test coverage

## Handoff Message

**After review is complete, ALWAYS show this message:**

If APPROVED:
```
✅ 코드 리뷰 통과

👉 커밋하고 PR을 생성할 수 있습니다.
   필요시: /yc:e2e — E2E 테스트 추가
```

If REQUEST CHANGES:
```
⚠️ 코드 리뷰: 수정 필요 ([N]건)

수정 후 다시 /yc:code-review 를 입력하여 재검토 받으세요.
```

## Related Agent

This command invokes the `code-reviewer` agent.
