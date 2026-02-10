---
description: "Analyze codebase, design architecture, and create implementation plan. Updates decisions with architecture/patterns/pseudo-code. WAIT for user confirmation before any code."
---

# Plan Command

Analyze the codebase, design the architecture, and create an implementation plan.

## What This Command Does

1. **Review Spec** - Load 01-spec.md and 02-decisions.md from /brainstorm
2. **Analyze Codebase** - Understand existing architecture, patterns, and structure
3. **Design Architecture** - Decide on structure, patterns, and pseudo-code
4. **Update Decisions** - Append architecture decisions to 02-decisions.md
5. **Create Plan** - Break into phased implementation steps
6. **Wait for Confirmation** - MUST receive user approval before proceeding

## When to Use

Use `/yc:plan` when:
- Spec is confirmed and ready for implementation
- Starting a new feature implementation
- Making significant architectural changes
- Multiple files or components will be affected

## How It Works

### Step 1: Review Spec

Load the existing documents:
```
docs/features/[feature-name]/
├── 01-spec.md
└── 02-decisions.md
```

Restate the requirements briefly to confirm understanding:

```markdown
## Spec Summary

**Goal:** [What we're building and why]
**Key Behaviors:** [Core interactions]
**Decisions So Far:** [High-level choices from brainstorm]
```

### Step 2: Codebase Analysis

Explore the existing code to understand:
- Current architecture and patterns in use
- Files and modules that will be affected
- Dependencies and shared code
- Existing patterns to follow or extend
- Test coverage of affected areas

**This step is critical.** Architecture decisions must be grounded in the actual codebase, not hypothetical.

### Step 3: Architecture Design

Based on codebase analysis, design the implementation structure:

#### Patterns & Structure
```markdown
## Architecture

### Pattern: [e.g., Compound Component]
Reason: [why this pattern fits, what existing code uses it]

### Structure
```
src/
├── components/
│   └── ThemeToggle/
│       ├── index.ts
│       ├── ThemeToggle.tsx
│       ├── ThemeToggle.test.tsx
│       └── useTheme.ts
├── providers/
│   └── ThemeProvider.tsx
└── styles/
    └── theme.css
```
```

#### Pseudo-code
```markdown
### Core Flow

// ThemeProvider wraps the app
ThemeProvider
  → reads initial theme (stored preference OR OS setting)
  → provides { theme, toggleTheme } via context

// useTheme hook
useTheme()
  → returns { theme, toggleTheme, isDark }
  → toggleTheme flips theme + persists to storage

// ThemeToggle component
ThemeToggle
  → uses useTheme()
  → renders toggle button
  → calls toggleTheme on click
```

### Step 4: Update Decisions

**Append architecture decisions to the existing 02-decisions.md.**

Add rows to the decisions table:

```markdown
| # | Decision | Options Considered | Chosen | Reason |
|---|----------|--------------------|--------|--------|
| ... | (existing rows from brainstorm) | ... | ... | ... |
| N | Component pattern | A: Single component, B: Compound, C: Render props | B | Matches existing Button/Modal patterns |
| N+1 | State management | A: useState local, B: Context, C: Zustand | B | Theme is app-wide, Context is simplest |
| N+2 | File structure | A: Flat, B: Feature-based | B | Project already uses feature folders |
```

Add an Architecture section below the table:

```markdown
## Architecture

### Structure
[folder/file structure]

### Core Flow (Pseudo-code)
[pseudo-code showing how pieces connect]

### Key Interfaces
[TypeScript interfaces/types for the core abstractions]
```

### Step 5: Implementation Plan

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
- [ ] Wire up API endpoints / connect components
- [ ] Add integration tests
**Verify:** Integration tests pass

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

### Step 6: Risk Assessment

| Risk | Level | Mitigation |
|------|-------|------------|
| Breaking existing [feature] | HIGH | Write regression tests first |
| Performance impact on [operation] | MEDIUM | Add benchmark before/after |
| Missing test coverage in [area] | MEDIUM | Add tests before modifying |

### Step 7: Wait for Confirmation

**CRITICAL: Do NOT write any code until the user confirms.**

Present the full plan (architecture + phases) and ask:
- "Does this architecture make sense?"
- "Any phases you want to reorder or skip?"
- "Ready to proceed?"

## Document Output

**ALWAYS save/update these files:**

1. **Update** `docs/features/[feature-name]/02-decisions.md` — Append architecture decisions + pseudo-code
2. **Create** `docs/features/[feature-name]/03-plan.md` — Implementation plan

```markdown
# Implementation Plan: [Feature Name]

**Status:** Draft | Approved
**Created:** YYYY-MM-DD
**Spec:** ./01-spec.md

---
[plan content]
```

After saving, the feature folder should look like:
```
docs/features/[feature-name]/
├── 01-spec.md            ← /brainstorm (what to build)
├── 02-decisions.md       ← /brainstorm + /plan (decisions + architecture)
└── 03-plan.md            ← /plan (implementation phases)
```

## Critical Boundaries

**STOP AFTER PLANNING.**

This command produces architecture design + implementation plan. It does NOT:
- Write implementation code
- Create source files or modify the codebase (except plan/decisions documents)
- Skip user confirmation
- Proceed without explicit approval

**Next Steps:**
- `/yc:impl` - Implement following the plan (default)
- `/yc:tdd` - Implement with strict test-first approach (for logic-heavy code)
- `/yc:build-fix` - Fix build errors during implementation
- `/yc:code-review` - Review completed implementation

## Plan Quality Checklist

- [ ] Spec reviewed and summarized
- [ ] Existing codebase analyzed (not guessing)
- [ ] Architecture designed with pseudo-code
- [ ] Architecture decisions appended to 02-decisions.md
- [ ] Risks identified with mitigation strategies
- [ ] Phases are incremental and independently testable
- [ ] Dependencies between phases are explicit
- [ ] Each phase has verification criteria
- [ ] No ambiguous steps ("improve performance" vs "add Redis cache for /api/items")
