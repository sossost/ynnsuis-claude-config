---
description: "Auto-detect project stack and generate a customized .claude/CLAUDE.md. Minimal questions, maximum automation."
---

# Init Command

Set up a project-specific `.claude/CLAUDE.md` by scanning the codebase and asking a few questions.

## What This Command Does

1. **Auto-Detect** - Scan project files to identify tech stack, structure, and conventions
2. **Clarify** - Ask 2 turns of questions to fill in what can't be detected
3. **Generate** - Write a customized `.claude/CLAUDE.md` using the project template

## Output

```
.claude/CLAUDE.md   ← Customized project instructions
```

## How It Works

### Phase 1: Auto-Detection (No User Input)

Scan the project root silently. Report findings at the end.

**CRITICAL: Never read `.env` files. Only `.env.example` or `.env.sample` are safe.**

#### 1a. Package Manager

Detect from lock files (first match wins):

| Lock File | Manager |
|-----------|---------|
| `bun.lockb` / `bun.lock` | bun |
| `pnpm-lock.yaml` | pnpm |
| `yarn.lock` | yarn |
| `package-lock.json` | npm |

If no lock file, default to `npm`.

#### 1b. package.json Analysis

Read `package.json` and extract:

**Framework:**
| Dependency | Framework |
|-----------|-----------|
| `next` | Next.js (check version) |
| `@remix-run/react` | Remix |
| `vite` + `react` | Vite + React |
| `@sveltejs/kit` | SvelteKit |
| `nuxt` | Nuxt |
| `astro` | Astro |
| `express` / `fastify` / `hono` | Node.js backend (specify which) |

**Styling:**
| Dependency | Styling |
|-----------|---------|
| `tailwindcss` | Tailwind CSS |
| `styled-components` | styled-components |
| `@emotion/react` | Emotion |
| `sass` / `node-sass` | Sass/SCSS |
| CSS Modules (check config) | CSS Modules |

**Database/ORM:**
| Dependency | DB/ORM |
|-----------|--------|
| `prisma` / `@prisma/client` | Prisma |
| `drizzle-orm` | Drizzle |
| `mongoose` | MongoDB (Mongoose) |
| `@supabase/supabase-js` | Supabase |
| `typeorm` | TypeORM |
| `knex` | Knex.js |

**Auth:**
| Dependency | Auth |
|-----------|------|
| `next-auth` / `@auth/core` | NextAuth (Auth.js) |
| `@clerk/nextjs` | Clerk |
| `passport` | Passport.js |
| `firebase` (with auth imports) | Firebase Auth |
| `lucia` | Lucia Auth |

**Testing:**
| Dependency | Testing |
|-----------|---------|
| `vitest` | Vitest |
| `jest` | Jest |
| `@playwright/test` | Playwright |
| `cypress` | Cypress |
| `@testing-library/react` | React Testing Library |

**State Management:**
| Dependency | State |
|-----------|-------|
| `zustand` | Zustand |
| `@reduxjs/toolkit` / `redux` | Redux |
| `jotai` | Jotai |
| `recoil` | Recoil |
| `@tanstack/react-query` | TanStack Query |
| `swr` | SWR |

**Other Notable Libraries:**
- `zod` → Schema validation
- `react-hook-form` → Form handling
- `framer-motion` → Animation
- `@tanstack/react-table` → Table
- `date-fns` / `dayjs` → Date utility
- `axios` → HTTP client
- `socket.io` → WebSocket
- `i18next` → Internationalization

#### 1c. Config Files

Check for existence and extract relevant info:
- `tsconfig.json` → TypeScript config (paths, strictness, target)
- `tailwind.config.*` → Tailwind setup
- `.eslintrc*` / `eslint.config.*` → ESLint config
- `.prettierrc*` → Prettier config
- `next.config.*` → Next.js config
- `vite.config.*` → Vite config
- `docker-compose.yml` / `Dockerfile` → Containerization
- `turbo.json` / `nx.json` → Monorepo tools

#### 1d. Environment Variables

Read `.env.example` or `.env.sample` (NEVER `.env`):
- Extract variable names and any comments
- Group into required vs optional based on comments or naming

#### 1e. Directory Structure

Scan top 2 levels of the project:
```bash
ls -d */ && ls -d */*/
```

Identify patterns:
- `src/app/` → Next.js App Router
- `src/pages/` → Pages Router or Vite
- `src/features/` → Feature-based architecture
- `src/components/` → Component-based architecture
- `app/` (root level) → Next.js App Router (no src)
- `server/` / `api/` → Backend separation
- `packages/` → Monorepo

#### 1f. Naming Pattern Detection

Sample a few files to detect conventions:
- Component files: `PascalCase.tsx` vs `kebab-case.tsx` vs `camelCase.tsx`
- Directories: `PascalCase/` vs `kebab-case/` vs `camelCase/`
- Test files: `*.test.ts` vs `*.spec.ts`
- Index exports: barrel files (`index.ts`) present?

Use Glob to sample:
```
**/*.tsx (first 10 files)
**/*.test.* or **/*.spec.* (first 5 files)
```

#### 1g. Non-Node Projects

If no `package.json` found, check for:
| File | Language/Stack |
|------|---------------|
| `requirements.txt` / `pyproject.toml` / `Pipfile` | Python |
| `go.mod` | Go |
| `Cargo.toml` | Rust |
| `build.gradle` / `pom.xml` | Java/Kotlin |
| `Gemfile` | Ruby |
| `composer.json` | PHP |

Adapt detection logic accordingly. For non-Node projects, skip package.json analysis and focus on config files, directory structure, and language-specific conventions.

### Phase 2: Interactive Clarification (2 Turns)

**CRITICAL: Only ask about what WASN'T detected. Skip questions where detection found clear answers.**

#### Turn 1: Present Findings + Core Questions

First, show what was detected:

```markdown
## 프로젝트 분석 결과

| 항목 | 감지됨 |
|------|--------|
| 프레임워크 | Next.js 15 |
| 스타일링 | Tailwind CSS |
| DB/ORM | Prisma + PostgreSQL |
| 인증 | NextAuth |
| 테스팅 | Vitest + Playwright |
| 상태관리 | Zustand + TanStack Query |
| 패키지 매니저 | pnpm |
| 구조 | Feature-based (src/features/) |

감지 못한 항목이 있으면 알려주세요.
```

Then ask (adapt based on what's missing):

**Always ask (open-ended text question):**
> 이 프로젝트를 한 문장으로 설명해주세요. (예: "소상공인을 위한 매출 관리 SaaS")

**Conditionally ask via AskUserQuestion (only if not detected):**
- Data fetching pattern (if unclear): Server Components / API Routes / tRPC / GraphQL
- State management (if not detected): what's used for client state
- Any major tool/library not in package.json

#### Turn 2: Project Rules + Focus

**Always ask (open-ended text question):**
> 이 프로젝트만의 특별한 규칙이 있나요? (예: "API 응답은 항상 { success, data, error } 형태", "컴포넌트는 반드시 Storybook 스토리 포함")
> 없으면 "없음"이라고 답해도 됩니다.

> 현재 집중하고 있는 작업이 있나요? (예: "결제 시스템 리팩토링 중", "v2 마이그레이션")
> 없으면 "없음"이라고 답해도 됩니다.

### Phase 3: Generate & Write

#### 3a. Check for Existing File

If `.claude/CLAUDE.md` already exists:

```
AskUserQuestion({
  questions: [{
    question: "이미 .claude/CLAUDE.md가 존재합니다. 어떻게 할까요?",
    header: "기존 파일",
    options: [
      { label: "덮어쓰기 (추천)", description: "기존 파일을 새로 생성된 파일로 교체합니다." },
      { label: "백업 후 생성", description: "기존 파일을 .claude/CLAUDE.md.backup으로 저장 후 새로 생성합니다." },
      { label: "취소", description: "기존 파일을 유지하고 명령을 종료합니다." }
    ],
    multiSelect: false
  }]
})
```

If "취소" selected, stop immediately.

#### 3b. Generate CLAUDE.md

Fill in the `templates/project-claude.md` structure with detected + user-provided information.

**Template mapping:**

| Template Section | Source |
|-----------------|--------|
| Project Name | Directory name (title-cased) or user input |
| One-line description | User input (Turn 1) |
| Tech Stack | Auto-detected (Phase 1) |
| Project Structure | Directory scan (Phase 1e) |
| Key Conventions > Naming | Naming detection (Phase 1f) |
| Key Conventions > State Management | Auto-detected or user input |
| Key Conventions > Data Fetching | Auto-detected or user input |
| Environment Variables | .env.example (Phase 1d) |
| Development commands | Package manager + detected scripts |
| Project-Specific Rules | User input (Turn 2) |
| Active Decisions | Empty table (to be filled as project evolves) |
| Current Focus | User input (Turn 2) |

**Rules for generation:**
- Use the exact template structure from `templates/project-claude.md`
- Fill in detected values — don't leave `[placeholder]` text
- For items not detected and not asked, use sensible defaults or omit
- Development commands should use the detected package manager
- If the project has custom scripts in package.json (e.g., `dev`, `build`, `test`, `lint`), use those exact script names

#### 3c. Write File

1. Create `.claude/` directory if it doesn't exist
2. If backup was requested, copy existing file to `.claude/CLAUDE.md.backup`
3. Write the generated content to `.claude/CLAUDE.md`

## Safety Rules

- **NEVER read `.env` files** — only `.env.example` or `.env.sample`
- **NEVER overwrite without asking** — always check for existing `.claude/CLAUDE.md`
- **Warn if not project root** — if no `package.json`, `go.mod`, `Cargo.toml`, or similar root marker exists, warn the user
- **Don't guess secrets** — environment variables section only includes names and descriptions, never values

## Handoff Message

**After CLAUDE.md is generated, ALWAYS show this message:**

```
✅ 프로젝트 설정 완료

.claude/CLAUDE.md 가 생성되었습니다.

감지된 스택:
- Framework: [detected]
- Styling: [detected]
- Testing: [detected]
- Package Manager: [detected]

👉 다음 단계:
   - /yc:brainstorm — 새 기능 아이디어 탐색
   - /yc:plan — 기존 스펙이 있으면 구현 계획 수립
   - /yc:help — 전체 커맨드 목록 보기
```

## Critical Boundaries

**This command ONLY generates `.claude/CLAUDE.md`.**

It does NOT:
- Install dependencies
- Modify project code
- Create other configuration files
- Set up CI/CD
- Generate feature specs or plans
