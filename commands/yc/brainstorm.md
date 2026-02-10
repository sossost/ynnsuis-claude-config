---
description: "Interactive discovery through Socratic dialogue. Explores ideas, makes decisions, and produces a feature spec + decisions document. One command, full output."
---

# Brainstorm Command

Transform a vague idea into a complete feature spec through structured dialogue.

## What This Command Does

1. **Explore the Idea** - Socratic Q&A to understand the problem
2. **Clarify Scope** - Define what's in, what's out
3. **Make Decisions** - Surface decision points and resolve them with the user
4. **Produce Documents** - Generate spec + decisions documents

## Output

One conversation, two documents:

```
docs/features/[feature-name]/
├── 01-spec.md          ← What to build + how it behaves
└── 02-decisions.md     ← Why we chose what we chose (with pros/cons)
```

## How It Works

### Phase 1: Explore (Understand the Problem)

Ask targeted questions to understand:
- **Who** is the user? What are their goals?
- **What** problem does this solve? Why now?
- **Where** does this fit in the existing system?
- **How** should it behave from the user's perspective?
- **What if** it fails? What are the edge cases?

Do NOT accept the first answer. Dig deeper:
```
User: "I want to add notifications"
You: "What triggers a notification? Who receives it?
      Is it real-time or batched? What channels — in-app, email, push?
      What if the user has 1000 unread notifications?"
```

Keep asking until you have a clear picture of:
- The core user need
- Key behaviors and interactions
- Scope boundaries (must-have vs nice-to-have)

### Phase 2: Decide (Resolve Technical Choices)

Once the problem is clear, surface decision points.

**ALWAYS mark a recommended option.** Use context (project scale, existing stack, common patterns) to pick the best default. The user can override.

```
User: "Theme should persist"
You: "Where should theme preference be stored?

      A: localStorage (Recommended) — simple, client-only, no account sync
      B: Database — syncs across devices, needs auth
      C: Cookie — works with SSR, limited size

      → A를 추천합니다. 클라이언트 전용 프로젝트에서 가장 단순하고 충분합니다.
        다른 옵션을 원하시면 말씀해주세요."
```

For each decision:
- Present 2-3 options with brief pros/cons
- **Always include a recommended option with (Recommended) label**
- Explain why the recommendation fits this project
- Let the user decide — recommendation is a starting point, not a mandate
- Record the decision with reasoning

**Decision scope for this phase (user-level choices):**
- Feature behavior (what modes, what triggers, what channels)
- Storage strategy (where to save, how to persist)
- UI approach (where to place, how to interact)
- Technology approach (CSS variables, Tailwind, CSS-in-JS)
- Accessibility level (basic, full, minimal)
- Scope boundaries (what's in v1, what's deferred)

**NOT in scope for this phase (belongs in /plan):**
- Code-level implementation details (inline scripts, data attributes, DOM manipulation)
- Architecture patterns (compound components, provider pattern)
- Folder structure and file organization
- Pseudo-code or code flow
- Migration strategies for existing code
- Design Rationale sections explaining implementation

### Phase 3: Confirm (Review Before Output)

Before generating documents, present a summary:

```markdown
## Summary

**Feature:** [name]
**Core:** [1-sentence description]
**Key Behaviors:** [bullet list]
**Key Decisions:** [bullet list]
**Scope:** [in] / [out]

Does this capture your intent? Anything to add or change?
```

Wait for user confirmation. Adjust if needed.

### Phase 4: Output (Generate Documents)

After confirmation, generate BOTH documents:

#### 01-spec.md

```markdown
# Feature Spec: [Feature Name]

**Status:** Draft | Confirmed
**Created:** YYYY-MM-DD
**Author:** (brainstorm session)

---

## Overview
[1-2 sentence summary of what this feature does and why]

## User Goals
- As a [user type], I want to [action] so that [benefit]

## Behavior

### Happy Path
[Step-by-step flow from user's perspective]

### Error Cases
- **[error condition]**: [what user sees/experiences]

### Edge Cases
| Situation | Expected Behavior |
|-----------|-------------------|
| [scenario] | [what happens] |

## Interface Design

### API (if applicable)
[Endpoints, request/response shapes, error codes]

### Components (if applicable)
[Props interfaces, key interactions]

### Data Model (if applicable)
[Entity shapes, relationships]

## Acceptance Criteria
- [ ] [Testable criterion in user-facing terms]

## Scope
**In Scope:** [what's included]
**Out of Scope:** [what's explicitly excluded]

## Open Questions
- [ ] [Unresolved items, if any]
```

#### 02-decisions.md

This document is created here and **extended by `/yc:plan`** with architecture details.

Each decision includes options with pros/cons for traceability.

```markdown
# Decisions: [Feature Name]

**Created:** YYYY-MM-DD

## Technical Decisions

### 1. [Decision Topic]

| Option | Pros | Cons |
|--------|------|------|
| A: [option] | [advantages] | [disadvantages] |
| B: [option] | [advantages] | [disadvantages] |
| C: [option] | [advantages] | [disadvantages] |

**Chosen:** [option]
**Reason:** [why this option fits best]

---

### 2. [Decision Topic]

| Option | Pros | Cons |
|--------|------|------|
| A: [option] | [advantages] | [disadvantages] |
| B: [option] | [advantages] | [disadvantages] |

**Chosen:** [option]
**Reason:** [why]

---

(repeat for each decision)

<!-- Architecture section will be added by /plan after codebase analysis -->
```

## Document Output

**ALWAYS save both documents after user confirms.**

Path: `docs/features/[feature-name]/`

- Derive `[feature-name]` from the topic in kebab-case (e.g., "dark mode theme" → `theme-system`)
- Create the directory if it doesn't exist
- Save AFTER user confirms the summary is correct

## Dialogue Guidelines

- Start broad, then narrow down
- Challenge assumptions — "Why?" is the most powerful question
- Explore failure modes early — "What happens when X goes wrong?"
- Separate must-haves from nice-to-haves
- Present options with trade-offs at every decision point
- Keep it conversational — this is a dialogue, not an interview

## Critical Boundaries

**STOP AFTER GENERATING DOCUMENTS.**

This command produces spec + decisions documents. It does NOT:
- Write implementation code
- Create file structures or scaffolding
- Run tests or builds
- Create an implementation plan
- Include Design Rationale or implementation explanation sections
- Include architecture patterns, pseudo-code, or folder structure

**Next Steps:**
- `/yc:plan` - Create implementation plan (architecture + pseudo-code + phases)
- `/yc:impl` - Implement following the plan (default, after /yc:plan)
- `/yc:tdd` - Implement with strict test-first (logic-heavy code only)
- `/yc:spec` - Revise spec if requirements change
- `/yc:brainstorm` again - Start fresh if direction changed
