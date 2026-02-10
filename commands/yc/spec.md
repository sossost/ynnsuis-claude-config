---
description: "Review and revise an existing feature spec. Use when requirements change, scope shifts, or the spec needs updating after initial brainstorm."
---

# Spec Command

Review, revise, or extend an existing feature specification.

## What This Command Does

1. **Read Existing Spec** - Load the current 01-spec.md and 02-decisions.md
2. **Identify Changes** - Compare current spec against new requirements or feedback
3. **Update Spec** - Revise behavior, acceptance criteria, or scope
4. **Update Decisions** - Add or modify technical decisions
5. **Save Updates** - Overwrite existing documents with updated versions

## When to Use

Use `/yc:spec` when:
- Requirements changed after initial brainstorm
- User feedback requires spec updates
- Scope needs to expand or contract
- A decision needs to be revisited
- Adding detail to an underspecified area

**For new features, use `/yc:brainstorm` instead.** This command is for revisions.

## How It Works

### Step 1: Load Current State

Read the existing documents:
```
docs/features/[feature-name]/
├── 01-spec.md
└── 02-decisions.md
```

Summarize the current spec to the user:
- Core feature description
- Key behaviors
- Current decisions
- Scope boundaries

### Step 2: Identify What Changed

Ask the user what needs updating:
- "What changed since we wrote this spec?"
- "Which parts need revision?"
- "Any new requirements or constraints?"

### Step 3: Revise

For each change:
- Show what the spec currently says
- Propose the updated version
- Get user confirmation before applying

If a decision needs revisiting:
- Show the original decision and reasoning
- Present new options if the landscape changed
- Record the updated decision with new reasoning

### Step 4: Save

Update both documents in place. Add a revision note:

```markdown
**Status:** Revised
**Created:** [original date]
**Revised:** YYYY-MM-DD
**Changes:** [brief summary of what changed]
```

## Document Path

Same path as the original:
```
docs/features/[feature-name]/
├── 01-spec.md          ← Updated
└── 02-decisions.md     ← Updated (new rows added)
```

## Critical Boundaries

**STOP AFTER SPEC REVISION.**

This command updates spec documents only. It does NOT:
- Write implementation code
- Modify existing implementation to match new spec
- Create an implementation plan

**Next Steps:**
- `/yc:plan` - Re-plan implementation if spec changed significantly
- `/yc:tdd` - Implement the updated spec
- `/yc:brainstorm` - Start fresh if the feature direction changed fundamentally
