---
description: "Implement features following the plan. Reads 03-plan.md and executes phase by phase. Commits incrementally. Use /yc:tdd instead for test-first approach."
---

# Impl Command

Implement features by following the plan, phase by phase.

## What This Command Does

1. **Load Plan** - Read 01-spec.md, 02-decisions.md, 03-plan.md
2. **Execute Phase by Phase** - Implement each phase in order
3. **Verify After Each Phase** - Run the phase's verification criteria
4. **Commit Incrementally** - One commit per phase
5. **Run Tests** - Write tests alongside implementation

## When to Use

Use `/yc:impl` when:
- Plan is confirmed and ready to implement
- UI components, pages, layouts, styling
- Features where build-and-see is more natural than test-first
- Prototyping and rapid iteration
- General implementation work

**Use `/yc:tdd` instead when:**
- Complex business logic or data transformations
- Utility functions and pure logic
- Bug fixes (reproduce with test first)
- Critical paths (auth, payments, data integrity)

## How It Works

### Step 1: Load Context

Read the feature documents:
```
docs/features/[feature-name]/
├── 01-spec.md          ← What to build
├── 02-decisions.md     ← Architecture + decisions
└── 03-plan.md          ← Phase-by-phase plan
```

Summarize what's about to be built:
- "We're implementing [feature] in [N] phases"
- "Phase 1 is [description], should I start?"

### Step 2: Execute Phase by Phase

For each phase in the plan:

#### a. Announce
```
Starting Phase 1: Foundation
- Create types/interfaces
- Set up test infrastructure
```

#### b. Implement
- Follow the architecture in 02-decisions.md
- Match existing codebase patterns
- Write clean, readable code following project standards
- **Do NOT write tests** — focus on implementation only
- Follow naming conventions:
  - Component files: `PascalCase.tsx` (e.g., `ThemeToggle.tsx`, `ListItem.tsx`)
  - Utility/helper files: `camelCase.ts` (e.g., `formatCurrency.ts`, `parseDate.ts`)
  - Hook files: `useCamelCase.ts` (e.g., `useTheme.ts`)
  - Type/interface files: `camelCase.ts` (e.g., `types.ts`, `themeTypes.ts`)
  - Component names: `PascalCase` (e.g., `ThemeToggle`, `ListItem`)
  - Hook names: `useCamelCase` (e.g., `useTheme`)
  - Type names: `PascalCase` (e.g., `ThemeMode`, `ToggleProps`)

#### c. Verify
Run type check after every phase. **Fix all errors before moving on.**

```
→ Running tsc...
  ✓ No errors — proceed to commit

  ✗ Found 3 errors — fix immediately, do NOT move to next phase
    → Fix each error
    → Re-run tsc
    → Repeat until clean
```

Also run the phase's verification criteria from the plan if specified.

#### d. Commit
```
feat(theme): add theme types and test infrastructure (Phase 1/4)
```

#### e. Check In
Ask before moving to the next phase:
- "Phase 1 complete. Ready for Phase 2?"
- If issues arose: "Found [issue] during Phase 1. Should we adjust the plan?"

### Step 3: Post-Implementation

After all phases complete:
- Run full test suite
- Check coverage (target 80%+)
- Summarize what was built
- Suggest next steps

## Testing Approach

**This command focuses on implementation. Do NOT write tests unless explicitly asked.**

Tests belong in a separate step:
- After impl is done → `/yc:code-review` for quality check
- If coverage is needed → `/yc:test-coverage` to identify gaps
- For critical logic → `/yc:tdd` to add tests with test-first approach

**Exception:** If the plan explicitly includes test tasks in a phase, follow the plan.

## Incremental Commits

Commit after each phase with a clear message:

```
feat(theme): add theme types and provider (Phase 1/4)
feat(theme): implement toggle logic and persistence (Phase 2/4)
feat(theme): connect UI components (Phase 3/4)
feat(theme): add accessibility and transitions (Phase 4/4)
```

## When Things Go Wrong

- **Build error** → Fix immediately, or use `/yc:build-fix`
- **Test failure** → Fix before moving to next phase
- **Plan doesn't match reality** → Pause, discuss with user, adjust plan
- **Scope creep** → Check against 01-spec.md, defer anything not in scope

## Critical Boundaries

**Implement ONLY what's in the plan.**

- Follow the plan phases in order
- Don't skip phases without user approval
- Don't add features not in the spec
- Don't refactor unrelated code
- Commit after each phase, not at the end

## Integration with Other Commands

```
/yc:brainstorm → /yc:plan → /yc:impl → (auto code-review) → PR?
                                  ↑
                          You are here
```

## Handoff: Automatic Code Review

**After all phases are complete, ALWAYS do the following:**

1. Show implementation summary:
```
✅ 구현 완료 ([N]/[N] phases)

🔍 코드 리뷰를 자동으로 시작합니다...
```

2. **Automatically run code review** — do NOT ask the user. Immediately invoke the `code-reviewer` agent to review all changes made during implementation. Follow the same review process as `/yc:code-review`.

3. If review finds CRITICAL or HIGH issues:
   - Fix them immediately
   - Re-run the review until APPROVED

4. After review is APPROVED, ask the user:
```
✅ 코드 리뷰 통과

👉 PR을 생성할까요?
   필요시:
   - /yc:test-coverage — 테스트 커버리지 확인
   - /yc:e2e — E2E 테스트 추가
```

**CRITICAL: Do NOT ask about PR creation before code review is complete and APPROVED.**
