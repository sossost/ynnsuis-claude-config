---
description: "Interactive requirements discovery through Socratic dialogue. Explores ideas, clarifies scope, and produces a requirements document. Focuses on WHAT the user needs, not HOW to build it."
---

# Brainstorm Command

Transform vague ideas into concrete requirements through structured dialogue.

## What This Command Does

1. **Explore the Idea** - Ask clarifying questions through Socratic dialogue
2. **Map the Problem Space** - Identify users, goals, constraints, and edge cases
3. **Validate Feasibility** - Assess viability at a high level
4. **Produce Requirements** - Generate a structured requirements document
5. **Identify Open Questions** - Surface unknowns that need user decisions

## When to Use

Use `/brainstorm` when:
- You have an idea but haven't defined what to build
- Requirements are unclear or incomplete
- You want to explore multiple approaches before committing
- Starting a new feature or product from scratch
- You need to think through edge cases and constraints

## How It Works

### Phase 1: Explore (Socratic Dialogue)

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

### Phase 2: Analyze (User Perspective)

Evaluate from the user's point of view:
- **User perspective** - Is this actually useful? Does it solve a real pain?
- **Behavioral perspective** - What should the user experience be?
- **Scope perspective** - What's in, what's out for this iteration?

### Phase 3: Specify (Requirements Only)

Convert dialogue into structured requirements.

**CRITICAL: Requirements describe WHAT, not HOW.**

```
GOOD (WHAT):
- FR-1: User can toggle between light and dark theme
- FR-2: Theme preference persists across sessions
- FR-3: First visit respects the user's OS theme setting

BAD (HOW — belongs in /spec):
- FR-1: Toggle sets data-theme attribute on <html>     ← implementation detail
- FR-2: Theme is saved to localStorage                 ← technical decision
- FR-3: Uses prefers-color-scheme media query           ← implementation detail
```

### Phase 4: Handoff

Present the requirements document and ask:
- "Does this capture your intent?"
- "Anything missing or wrong?"
- "Ready to move to /spec?"

## Requirements Document Template

```markdown
# Requirements: [Feature Name]

**Status:** Draft | Confirmed
**Created:** YYYY-MM-DD
**Author:** (brainstorm session)

---

## User Goals
- As a [user type], I want to [action] so that [benefit]

## Functional Requirements
- FR-1: [User-facing behavior, not implementation]
- FR-2: [What the system does, not how]

## Non-Functional Requirements
- NFR-1: [Performance, accessibility, reliability targets]

## User-Facing Edge Cases
| Situation | Expected Behavior |
|-----------|-------------------|
| [scenario from user's perspective] | [what user sees/experiences] |

## Scope
**In Scope:** [what's included]
**Out of Scope:** [what's explicitly excluded]

## Open Questions
- [ ] [Unresolved items that need user decision]
```

## Document Output

**ALWAYS save the final requirements document to a file.**

Path: `docs/features/[feature-name]/01-requirements.md`

- Derive `[feature-name]` from the topic in kebab-case (e.g., "dark mode theme" → `theme-system`)
- Create the directory if it doesn't exist
- Save AFTER user confirms the requirements are correct

## Critical Boundaries

**STOP AFTER REQUIREMENTS DISCOVERY.**

This command focuses on **WHAT the user needs**, not **HOW to build it**.

**Will NOT:**
- Make technical decisions (storage method, CSS strategy, library choices)
- Include implementation details (specific APIs, data attributes, file structures)
- Design architecture or database schemas
- Write implementation code
- Include a "Decisions" table (that belongs in `/spec`)

**Will:**
- Describe behavior from the user's perspective
- Define success criteria in user-facing terms
- Identify edge cases as user experiences, not technical scenarios
- Set non-functional targets (performance, a11y) without prescribing solutions

**Next Steps:**
- `/spec` - Technical decisions + detailed specification
- `/plan` - Implementation plan (after spec)
- `/brainstorm` again - Iterate if requirements need refinement

## Tips for Good Brainstorming

- Start broad, then narrow down
- Challenge assumptions — "Why?" is the most powerful question
- Explore failure modes early — "What happens when X goes wrong?"
- Separate must-haves from nice-to-haves
- Keep it in the user's language, not the developer's language
