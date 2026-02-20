---
description: "Extract a feature spec from an existing Figma design. Analyzes components, tokens, and states, then produces spec + decisions documents compatible with the Idea→Ship workflow."
---

# Design to Spec Command

Transform a Figma design into a complete feature spec through design analysis and structured dialogue.

## What This Command Does

1. **Analyze Design** — Extract components, tokens, and structure from Figma
2. **Present & Clarify** — Surface what the design shows and ask about what it doesn't
3. **Decide** — Resolve technical choices (state management, data fetching, etc.)
4. **Confirm** — Review summary before output
5. **Produce Documents** — Generate spec + decisions documents

## Output

One conversation, two documents (same as `/yc:brainstorm`):

```
docs/features/[feature-name]/
├── 01-spec.md          ← What to build + design reference + component breakdown
└── 02-decisions.md     ← Why we chose what we chose (with pros/cons)
```

## How It Works

### Phase 1: Analyze Design (Automated)

**Requires:** User provides a Figma URL.

Parse the URL to extract `fileKey` and `nodeId`:
- URL format: `https://figma.com/design/:fileKey/:fileName?node-id=:int1-:int2`
- Extract `fileKey` from the path
- Extract `nodeId` by converting `int1-int2` to `int1:int2`

**Step 1 — Parallel initial calls:**
```
get_screenshot(fileKey, nodeId)    // Visual reference
get_metadata(fileKey, nodeId)      // Structure overview (XML)
```

**Step 2 — Based on metadata, identify key sections and call:**
```
get_design_context(fileKey, nodeId)   // Component details + code
get_variable_defs(fileKey, nodeId)    // Design tokens (colors, spacing, etc.)
```

**Step 3 — Optional (if Code Connect is configured):**
```
get_code_connect_map(fileKey, nodeId) // Existing component mappings
```

**Extract and organize:**
- Component tree (hierarchy, names, types)
- Design tokens (colors, typography, spacing, border radius, shadows)
- Reusable components (from Code Connect or component instances)
- Layout structure (flex/grid, responsive hints)
- States visible in the design (hover, active, disabled, selected)

### Phase 2: Present & Clarify (Dialogue)

**CRITICAL: Ask 2-3 questions at a time, not all at once.**

Present the analysis summary first:

```markdown
## 디자인 분석 결과

**컴포넌트:** [N]개 감지 (예: Header, ProductCard, FilterBar, ...)
**디자인 토큰:** 색상 [N]개, 타이포 [N]개, 간격 [N]개
**재사용 가능:** [list of existing components from Code Connect or matching patterns]

[Screenshot or visual reference description]
```

Then ask about what the design doesn't show (2-3 per turn):

**Turn 1 — Core intent & data:**
- 이 화면의 핵심 사용자 목표는 무엇인가요?
- 데이터는 어디서 오나요? (API, 로컬 상태, URL 파라미터 등)

**Turn 2 — States & errors:**
- 로딩 상태는 어떻게 보여야 하나요? (스켈레톤, 스피너, 프로그레스 바)
- 에러 발생 시 사용자에게 어떻게 알려주나요?
- 데이터가 없을 때(빈 상태) 디자인이 있나요?

**Turn 3 — Interactions & edge cases:**
- [디자인에서 감지된 인터랙티브 요소]의 동작을 설명해주세요
- 반응형 동작이 필요한가요? (모바일/태블릿 브레이크포인트)
- 접근성 요구사항이 있나요? (키보드 네비게이션, 스크린 리더)

**Use AskUserQuestion for questions with clear options:**
```
AskUserQuestion({
  questions: [
    {
      question: "로딩 상태를 어떻게 표시할까요?",
      header: "로딩 상태",
      options: [
        { label: "스켈레톤 (추천)", description: "레이아웃 유지. CLS 최소화. 가장 자연스러운 UX." },
        { label: "스피너", description: "단순 구현. 레이아웃 시프트 가능." },
        { label: "프로그레스 바", description: "진행률 표시 가능. 정확한 진행률 필요." }
      ],
      multiSelect: false
    }
  ]
})
```

**Use plain text for open-ended questions:**
- "이 리스트에서 항목을 클릭하면 어떤 일이 일어나나요?"
- "필터 조건이 변경될 때 URL도 업데이트되어야 하나요?"

### Phase 3: Decide (Technical Choices)

**Scope is narrower than brainstorm** — the design already decided UI layout, colors, typography, and visual hierarchy. Focus only on what the design doesn't answer.

**Decision topics for this phase:**
- State management (로컬 상태, URL 상태, 서버 상태)
- Data fetching strategy (React Query, SWR, fetch)
- Animation/transition approach (CSS transitions, Framer Motion)
- Component reuse (기존 컴포넌트 활용 vs 신규 생성)
- Accessibility level (기본, 전체, 최소)
- Scope boundaries (v1에 포함/제외할 것)

**NOT in scope for this phase (belongs in /yc:plan):**
- Architecture patterns (compound components, provider pattern)
- Folder structure and file organization
- Code-level implementation details
- Migration strategies for existing code

**ALWAYS use AskUserQuestion for decision points:**
```
AskUserQuestion({
  questions: [{
    question: "서버 데이터는 어떻게 관리할까요?",
    header: "데이터 페칭",
    options: [
      {
        label: "React Query (추천)",
        description: "장점: 캐싱, 리페치, 옵티미스틱 업데이트 내장. 단점: 추가 의존성."
      },
      {
        label: "SWR",
        description: "장점: 가볍고 단순. 단점: 뮤테이션 지원 약함."
      },
      {
        label: "Native fetch + useState",
        description: "장점: 의존성 없음. 단점: 캐싱/에러/로딩 직접 관리."
      }
    ],
    multiSelect: false
  }]
})
```

### Phase 4: Confirm (Review Before Output)

Present a summary before generating documents:

```markdown
## Summary

**Feature:** [name]
**Figma:** [URL]
**Core:** [1-sentence description]
**Components:** [N]개 ([list])
**Key Behaviors:** [bullet list]
**Key Decisions:** [bullet list]
**Scope:** [in] / [out]

Does this capture your intent? Anything to add or change?
```

Wait for user confirmation. Adjust if needed.

### Phase 5: Output (Generate Documents)

After confirmation, generate BOTH documents:

#### 01-spec.md

```markdown
# Feature Spec: [Feature Name]

**Status:** Draft | Confirmed
**Created:** YYYY-MM-DD
**Author:** (design-to-spec session)

---

## Overview
[1-2 sentence summary of what this feature does and why]

## Visual Reference
**Figma:** [URL]
[Brief description of what the design shows]

## User Goals
- As a [user type], I want to [action] so that [benefit]

## Component Breakdown

| Component | Type | Description | Reuse |
|-----------|------|-------------|-------|
| [name] | Layout / Interactive / Display | [what it does] | New / Existing `ComponentName` |

## Design Tokens

### Colors
| Token | Value | Usage |
|-------|-------|-------|
| [name] | [hex/rgb] | [where used] |

### Typography
| Token | Value | Usage |
|-------|-------|-------|
| [name] | [font/size/weight] | [where used] |

### Spacing
| Token | Value | Usage |
|-------|-------|-------|
| [name] | [px/rem] | [where used] |

## Behavior

### Happy Path
[Step-by-step flow from user's perspective]

### States
| State | Trigger | Visual Change | Affected Components |
|-------|---------|---------------|---------------------|
| Loading | 초기 진입 | [skeleton/spinner] | [components] |
| Error | API 실패 | [error message] | [components] |
| Empty | 데이터 없음 | [empty state] | [components] |
| [custom] | [trigger] | [change] | [components] |

### Interactions
| Element | Action | Result |
|---------|--------|--------|
| [component] | Click / Hover / Focus | [what happens] |

### Error Cases
- **[error condition]**: [what user sees/experiences]

### Edge Cases
| Situation | Expected Behavior |
|-----------|-------------------|
| [scenario] | [what happens] |

## Interface Design

### API (if applicable)
[Endpoints, request/response shapes, error codes]

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

Same structure as brainstorm output:

```markdown
# Decisions: [Feature Name]

**Created:** YYYY-MM-DD

## Technical Decisions

### 1. [Decision Topic]

| Option | Pros | Cons |
|--------|------|------|
| A: [option] | [advantages] | [disadvantages] |
| B: [option] | [advantages] | [disadvantages] |

**Chosen:** [option]
**Reason:** [why this option fits best]

---

(repeat for each decision)

<!-- Architecture section will be added by /plan after codebase analysis -->
```

## Document Output

**ALWAYS save both documents after user confirms.**

Path: `docs/features/[feature-name]/`

- Derive `[feature-name]` from the topic in kebab-case (e.g., "product list page" → `product-list`)
- Create the directory if it doesn't exist
- Save AFTER user confirms the summary is correct

## Dialogue Guidelines

- Lead with what the design tells us, then ask about what it doesn't
- Don't ask about things already visible in the design (colors, layout, typography)
- Focus questions on behavior, data flow, states, and edge cases
- Keep it efficient — the design has already done half the work
- Challenge assumptions — "The design shows X, but what happens when Y?"

## Critical Boundaries

**STOP AFTER GENERATING DOCUMENTS.**

This command produces spec + decisions documents. It does NOT:
- Write implementation code
- Create file structures or scaffolding
- Run tests or builds
- Create an implementation plan
- Include Design Rationale or implementation explanation sections
- Include architecture patterns, pseudo-code, or folder structure

## Handoff Message

**After documents are saved, ALWAYS show this message:**

```
✅ 문서 생성 완료

docs/features/[feature-name]/
├── 01-spec.md
└── 02-decisions.md

👉 다음 단계: /yc:plan 을 입력하여 구현 계획을 생성하세요.
   (코드베이스 분석 → 아키텍처 설계 → 단계별 구현 계획)
```

**Other available commands:**
- `/yc:spec` - 스펙 수정이 필요할 때
- `/yc:brainstorm` - 아이디어부터 시작하고 싶을 때
- `/yc:design-to-spec` - 다른 Figma 디자인으로 스펙을 만들 때
