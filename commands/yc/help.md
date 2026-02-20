---
description: "Quick reference for all yc: commands and the Idea→Ship workflow."
---

# YC Commands — Quick Reference

## Workflow

```
/yc:brainstorm ────────┐
                       ├──→ /yc:plan → /yc:impl → /yc:code-review
/yc:design-to-spec ────┘
```

## Commands

### Core Workflow
| Command | Purpose | Output |
|---------|---------|--------|
| `/yc:brainstorm` | 아이디어 탐색 → 스펙 + 결정 | `01-spec.md` + `02-decisions.md` |
| `/yc:design-to-spec` | Figma 디자인 → 스펙 + 결정 | `01-spec.md` + `02-decisions.md` |
| `/yc:plan` | 코드베이스 분석 → 아키텍처 + 구현계획 | `03-plan.md` + `02-decisions.md` 보강 |
| `/yc:impl` | plan 따라 phase별 구현 | 코드 |
| `/yc:tdd` | 테스트 먼저 구현 (로직 위주) | 코드 + 테스트 |
| `/yc:code-review` | 코드 품질 + 보안 리뷰 | 리뷰 리포트 |

### Revision
| Command | Purpose |
|---------|---------|
| `/yc:spec` | 기존 스펙 수정/보완 |

### Quality & Testing
| Command | Purpose |
|---------|---------|
| `/yc:test-coverage` | 커버리지 분석 + 갭 식별 |
| `/yc:e2e` | Playwright E2E 테스트 생성 |
| `/yc:build-fix` | 빌드/타입 에러 수정 |

### Maintenance
| Command | Purpose |
|---------|---------|
| `/yc:refactor-clean` | 데드코드 정리 |
| `/yc:update-docs` | 문서 동기화 |
| `/yc:help` | 이 도움말 |

## Document Structure

```
docs/features/[feature-name]/
├── 01-spec.md          ← /yc:brainstorm
├── 02-decisions.md     ← /yc:brainstorm + /yc:plan
└── 03-plan.md          ← /yc:plan
```

## Naming Conventions

| 대상 | 규칙 | 예시 |
|------|------|------|
| 컴포넌트 파일 | `PascalCase.tsx` | `ThemeToggle.tsx` |
| 유틸리티 파일 | `camelCase.ts` | `formatCurrency.ts` |
| 훅 파일 | `useCamelCase.ts` | `useTheme.ts` |
| 컴포넌트 이름 | `PascalCase` | `ThemeToggle` |
| 타입 이름 | `PascalCase` | `ThemeMode` |
| 상수 | `UPPER_SNAKE_CASE` | `MAX_RETRIES` |
