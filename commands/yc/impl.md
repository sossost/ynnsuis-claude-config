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
- Add tests for logic-heavy code (not mandatory test-first, but tests are required)

#### c. Verify
Run the phase's verification criteria from the plan:
```
Phase 1 Verify: Types compile, test scaffold runs
→ Running tsc... ✓
→ Running tests... ✓
```

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

Unlike `/yc:tdd`, this command does NOT enforce test-first. But tests are still required:

| Code Type | Testing Approach |
|-----------|-----------------|
| Business logic / utils | Write tests (can be after implementation) |
| API endpoints | Write integration tests |
| UI components | Write tests for behavior, not rendering |
| Styling / layout | Visual verification, no unit tests needed |
| Critical paths | Consider `/yc:tdd` instead |

**Minimum:** Every phase should have some test coverage.
**Target:** 80%+ overall coverage by the end.

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
/yc:brainstorm → /yc:plan → /yc:impl → /yc:code-review
                                  ↑
                          You are here
```

**Next Steps:**
- `/yc:code-review` - Review completed implementation
- `/yc:test-coverage` - Check coverage gaps
- `/yc:e2e` - Add E2E tests for critical flows
- `/yc:build-fix` - If build breaks during implementation
