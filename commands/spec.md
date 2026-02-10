---
description: "Create a detailed feature specification from requirements. Defines behavior, acceptance criteria, API contracts, and edge cases. Does NOT implement."
---

# Spec Command

Turn requirements into a precise, implementation-ready specification.

## What This Command Does

1. **Review Requirements** - Understand what needs to be built
2. **Define Behavior** - Specify exactly how the feature works
3. **Write Acceptance Criteria** - Define what "done" means
4. **Design Interfaces** - API contracts, component props, data shapes
5. **Map Edge Cases** - Document every known edge case and how to handle it
6. **Produce Spec Document** - Generate a complete feature specification

## When to Use

Use `/spec` when:
- Requirements are defined (after `/brainstorm` or from a product brief)
- You need a clear contract before implementation
- Multiple people will work on the feature
- The feature touches multiple systems or components
- You want to catch design issues before writing code

## How It Works

### Step 1: Requirements Review

Read the requirements and restate them. Identify:
- Core user stories
- Success metrics
- Known constraints
- Dependencies on other systems

### Step 2: Behavior Specification

For each user story, define the exact behavior:

```markdown
### Feature: [Name]

#### Scenario: [Happy Path]
- **Given** [initial state]
- **When** [user action or system event]
- **Then** [expected outcome]

#### Scenario: [Error Case]
- **Given** [initial state]
- **When** [error condition]
- **Then** [error handling behavior]
```

### Step 3: Interface Design

Define the contracts between components:

```typescript
// API Contract
POST /api/[resource]
Request:  { field: string; count: number }
Response: { id: string; status: 'created' | 'pending' }
Errors:   400 (validation), 401 (auth), 409 (conflict)

// Component Interface
interface Props {
  items: Item[]
  onSelect: (id: string) => void
  isLoading?: boolean
}

// Data Shape
interface Entity {
  id: string
  name: string
  status: 'active' | 'inactive' | 'archived'
  createdAt: Date
  updatedAt: Date
}
```

### Step 4: Edge Cases & Error Handling

Document every edge case:

| Scenario | Expected Behavior |
|----------|------------------|
| Empty state (no data) | Show empty state UI with CTA |
| Network failure | Show error toast, retain user input |
| Concurrent edits | Last-write-wins with conflict notification |
| Max limit reached | Disable action, show limit message |
| Invalid input | Inline validation with specific error message |

### Step 5: Acceptance Criteria

Write testable acceptance criteria:

```markdown
## Acceptance Criteria

- [ ] User can [action] and see [result]
- [ ] Error message appears when [condition]
- [ ] Loading state shows during [async operation]
- [ ] Works on mobile viewport (375px+)
- [ ] Keyboard accessible (Tab, Enter, Escape)
- [ ] Screen reader announces [state changes]
- [ ] Performance: [operation] completes in < [N]ms
```

## Spec Document Template

```markdown
# Feature Spec: [Name]

**Status:** Draft | In Review | Approved
**Author:** [name]
**Date:** YYYY-MM-DD
**Requires:** [dependencies]

## Overview
[1-2 sentence summary of what this feature does and why]

## User Stories
- As a [user], I want to [action] so that [benefit]

## Behavior

### Happy Path
[Step-by-step flow]

### Error Cases
[Each error scenario and handling]

### Edge Cases
[Table of edge cases]

## Interface Design

### API
[Endpoints, request/response shapes, error codes]

### Components
[Props interfaces, state management]

### Data Model
[Entity shapes, relationships]

## Acceptance Criteria
[Testable checklist]

## Out of Scope
[Explicitly excluded items]

## Open Questions
[Unresolved decisions]

## Decision Log
| Decision | Chosen Option | Reason | Date |
|----------|--------------|--------|------|
```

## Critical Boundaries

**STOP AFTER SPECIFICATION.**

This command produces a SPEC DOCUMENT ONLY.

**Will NOT:**
- Write implementation code
- Create file structure or scaffolding
- Run tests or builds
- Make decisions the user hasn't approved

**Next Steps:**
- `/plan` - Create phased implementation plan from this spec
- `/tdd` - Implement with test-driven development
- `/spec` again - Revise if spec needs changes

## Quality Checklist

Before finalizing a spec:
- [ ] Every user story has acceptance criteria
- [ ] Every API endpoint has request/response shapes and error codes
- [ ] Every edge case is documented with expected behavior
- [ ] All decisions are logged with reasoning
- [ ] Out-of-scope is explicitly defined
- [ ] No ambiguous language ("should", "maybe", "probably")
