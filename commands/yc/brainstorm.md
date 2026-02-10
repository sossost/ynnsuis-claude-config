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

**CRITICAL: Ask 2-3 questions at a time, not all at once.**

This is a dialogue, not a survey. Ask a small batch → get answers → dig deeper based on responses → repeat.

Questions to cover (spread across multiple turns):
- **Who** is the user? What are their goals?
- **What** problem does this solve? Why now?
- **Where** does this fit in the existing system?
- **How** should it behave from the user's perspective?
- **What if** it fails? What are the edge cases?

**Use AskUserQuestion for questions with clear options:**
```
AskUserQuestion({
  questions: [
    {
      question: "토글 버튼을 어디에 배치할까요?",
      header: "토글 위치",
      options: [
        { label: "헤더 (추천)", description: "항상 접근 가능. 가장 일반적인 패턴." },
        { label: "설정 페이지", description: "깔끔하지만 접근성 떨어짐." },
        { label: "플로팅 버튼", description: "눈에 띄지만 콘텐츠 가릴 수 있음." }
      ],
      multiSelect: false
    },
    {
      question: "지원할 테마 모드는?",
      header: "테마 모드",
      options: [
        { label: "Light / Dark (추천)", description: "단순하고 빠른 구현. 대부분의 프로젝트에 충분." },
        { label: "Light / Dark / System", description: "OS 설정 연동. 구현 약간 복잡." }
      ],
      multiSelect: false
    }
  ]
})
```

**Use plain text for open-ended questions:**
- "테마 전환 시 애니메이션이 필요한가요? 필요하다면 어떤 느낌을 원하시나요?"
- "색상만 바꾸나요, 아니면 폰트/간격 등도 포함하나요?"

**Flow:**
1. First turn: 2-3 core questions (AskUserQuestion or text)
2. Based on answers: 2-3 follow-up questions
3. Dig deeper until the picture is clear
4. Then move to Phase 2 (Decide)

### Phase 2: Decide (Resolve Technical Choices)

Once the problem is clear, surface decision points.

**ALWAYS use the AskUserQuestion tool for decision points.** Present options as interactive selectable choices, not inline text.

Format rules:
- **First option = recommended**, with "(추천)" appended to the label
- Each option's description includes pros and cons
- Use the question field for context about what's being decided
- header should be a short topic label (max 12 chars)

Example:
```
AskUserQuestion({
  questions: [{
    question: "테마 설정을 어디에 저장할까요?",
    header: "저장 방식",
    options: [
      {
        label: "localStorage (추천)",
        description: "장점: 단순 구현, 빠른 접근. 단점: 디바이스 간 동기화 불가."
      },
      {
        label: "Database",
        description: "장점: 디바이스 간 동기화. 단점: 인증 필요, 구현 복잡."
      },
      {
        label: "Cookie",
        description: "장점: SSR 호환. 단점: 4KB 용량 제한."
      }
    ],
    multiSelect: false
  }]
})
```

For each decision:
- **Always use AskUserQuestion tool** — not inline text options
- First option is the recommended choice with "(추천)" label
- Description format: "장점: [pros]. 단점: [cons]."
- Let the user select — recommendation is a starting point, not a mandate
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
