---
description: "Interactive requirements discovery through Socratic dialogue. Explores ideas, clarifies scope, and produces a requirements document. Does NOT design or implement."
---

# Brainstorm Command

Transform vague ideas into concrete requirements through structured dialogue.

## What This Command Does

1. **Explore the Idea** - Ask clarifying questions through Socratic dialogue
2. **Map the Problem Space** - Identify users, goals, constraints, and edge cases
3. **Validate Feasibility** - Assess technical and business viability
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
- **How** should it behave? What are the constraints?
- **What if** it fails? What are the edge cases?

Do NOT accept the first answer. Dig deeper:
```
User: "I want to add notifications"
You: "What triggers a notification? Who receives it?
      Is it real-time or batched? What channels — in-app, email, push?
      What if the user has 1000 unread notifications?"
```

### Phase 2: Analyze (Multi-Perspective)

Evaluate the idea from multiple angles:
- **User perspective** - Is this actually useful? Does it solve a real pain?
- **Technical perspective** - Is this feasible with current architecture?
- **Business perspective** - Does this align with product goals?
- **Security perspective** - Are there privacy or security implications?

### Phase 3: Specify (Concrete Requirements)

Convert dialogue into structured requirements:

```markdown
## Requirements: [Feature Name]

### User Goals
- As a [user type], I want to [action] so that [benefit]

### Functional Requirements
- FR-1: System must [do X] when [condition]
- FR-2: System must [do Y] within [constraint]

### Non-Functional Requirements
- NFR-1: Response time < 200ms for [operation]
- NFR-2: Support [N] concurrent users

### Constraints
- Must work with existing [system/API/database]
- Must not break [existing feature]

### Out of Scope
- [Things explicitly NOT included in this iteration]

### Open Questions
- [ ] How should [edge case] be handled?
- [ ] What is the priority relative to [other feature]?
```

### Phase 4: Handoff

Present the requirements document and ask:
- "Does this capture your intent?"
- "Anything missing or wrong?"
- "Ready to move to /spec or /plan?"

## Document Output

**ALWAYS save the final requirements document to a file.**

Path: `docs/features/[feature-name]/01-requirements.md`

- Derive `[feature-name]` from the topic in kebab-case (e.g., "dark mode theme system" → `theme-system`)
- Create the directory if it doesn't exist
- Save AFTER user confirms the requirements are correct
- Include metadata at the top:

```markdown
# Requirements: [Feature Name]

**Status:** Draft | Confirmed
**Created:** YYYY-MM-DD
**Author:** (brainstorm session)

---
[requirements content]
```

## Critical Boundaries

**STOP AFTER REQUIREMENTS DISCOVERY.**

This command produces a REQUIREMENTS DOCUMENT ONLY.

**Will NOT:**
- Design architecture or database schemas
- Write implementation code
- Make technical decisions without user input
- Skip the dialogue phase

**Next Steps:**
- `/spec` - Create a detailed feature specification
- `/plan` - Create an implementation plan
- `/brainstorm` again - Iterate if requirements need refinement

## Tips for Good Brainstorming

- Start broad, then narrow down
- Challenge assumptions — "Why?" is the most powerful question
- Explore failure modes early — "What happens when X goes wrong?"
- Separate must-haves from nice-to-haves
- Document decisions AND the reasoning behind them
