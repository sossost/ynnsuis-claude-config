---
description: "Create step-by-step implementation plan from requirements or spec. Assess risks, identify dependencies, break into phases. WAIT for user confirmation before any code."
---

# Plan Command

Create a comprehensive implementation plan before writing any code.

## What This Command Does

1. **Restate Requirements** - Clarify what needs to be built
2. **Analyze Codebase** - Understand existing architecture and patterns
3. **Identify Risks** - Surface potential issues, blockers, and dependencies
4. **Break Into Phases** - Create ordered, incremental implementation steps
5. **Wait for Confirmation** - MUST receive user approval before proceeding

## When to Use

Use `/plan` when:
- Starting a new feature implementation
- Making significant architectural changes
- Working on complex refactoring
- Multiple files or components will be affected
- Requirements are defined but implementation path is unclear

## How It Works

### Step 1: Requirements Restatement

Restate the requirements in your own words. This catches misunderstandings early.

```markdown
## Requirements Restatement

**Goal:** [What we're building and why]
**Users:** [Who benefits]
**Success Criteria:** [How we know it's done]
```

### Step 2: Codebase Analysis

Explore the existing code to understand:
- Current architecture and patterns
- Files that will be modified
- Dependencies and shared code
- Test coverage of affected areas

### Step 3: Risk Assessment

Identify risks by category:

| Risk | Level | Mitigation |
|------|-------|------------|
| Breaking existing [feature] | HIGH | Write regression tests first |
| Performance impact on [operation] | MEDIUM | Add benchmark before/after |
| Missing test coverage in [area] | MEDIUM | Add tests before modifying |
| Dependency on unreleased [feature] | LOW | Use feature flag |

### Step 4: Implementation Plan

Break into ordered phases. Each phase should be independently testable.

```markdown
## Implementation Plan

### Phase 1: Foundation [Estimated: S/M/L]
- [ ] Create types/interfaces
- [ ] Set up test infrastructure
- [ ] Add database migration (if needed)
**Verify:** Types compile, tests scaffold runs

### Phase 2: Core Logic [Estimated: S/M/L]
- [ ] Implement core business logic (TDD)
- [ ] Add unit tests for happy path + edge cases
- [ ] Verify 80%+ coverage
**Verify:** All unit tests pass

### Phase 3: Integration [Estimated: S/M/L]
- [ ] Wire up API endpoints
- [ ] Connect frontend components
- [ ] Add integration tests
**Verify:** Integration tests pass, API responds correctly

### Phase 4: Polish [Estimated: S/M/L]
- [ ] Add loading states and error handling
- [ ] Implement accessibility (keyboard, screen reader)
- [ ] Add E2E tests for critical paths
**Verify:** E2E tests pass, a11y audit clean

## Dependencies
- Phase 2 depends on Phase 1
- Phase 3 depends on Phase 2
- Phase 4 can partially overlap with Phase 3

## Estimated Complexity: S / M / L / XL
```

### Step 5: Wait for Confirmation

**CRITICAL: Do NOT write any code until the user confirms.**

Present the plan and ask:
- "Does this plan look correct?"
- "Any phases you want to reorder or skip?"
- "Ready to proceed?"

If user wants changes:
- "modify: [specific change]" - Adjust the plan
- "different approach: [alternative]" - Rethink strategy
- "start from phase N" - Skip earlier phases

## Document Output

**ALWAYS save the plan to a file.**

Path: `docs/features/[feature-name]/03-plan.md`

Use the same `[feature-name]` directory as previous documents.
If starting fresh, derive the name from the feature topic in kebab-case.

```markdown
# Implementation Plan: [Feature Name]

**Status:** Draft | Approved
**Created:** YYYY-MM-DD
**Spec:** [link to 01-spec.md]

---
[plan content]
```

After saving, the feature folder should look like:
```
docs/features/[feature-name]/
├── 01-spec.md            ← /brainstorm
├── 02-decisions.md       ← /brainstorm
└── 03-plan.md            ← /plan
```

## Critical Boundaries

**STOP AFTER PLANNING.**

This command produces an IMPLEMENTATION PLAN ONLY.

**Will NOT:**
- Write implementation code
- Create files or modify the codebase (except the plan document)
- Skip user confirmation
- Proceed without explicit approval

**Next Steps:**
- `/tdd` - Implement using test-driven development
- `/build-fix` - Fix build errors during implementation
- `/code-review` - Review completed implementation

## Plan Quality Checklist

- [ ] Requirements restated and confirmed
- [ ] Existing codebase analyzed (not guessing)
- [ ] Risks identified with mitigation strategies
- [ ] Phases are incremental and independently testable
- [ ] Dependencies between phases are explicit
- [ ] Each phase has verification criteria
- [ ] No ambiguous steps ("improve performance" vs "add Redis cache for /api/items")
