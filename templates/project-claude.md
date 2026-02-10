# [Project Name]

> [One-line description of what this project does]

## Tech Stack

- **Framework:** [e.g., Next.js 15 / Remix / Vite + React]
- **Language:** TypeScript
- **Styling:** [e.g., Tailwind CSS / CSS Modules / styled-components]
- **Database:** [e.g., PostgreSQL / MongoDB / none]
- **ORM:** [e.g., Prisma / Drizzle / none]
- **Auth:** [e.g., NextAuth / Clerk / custom JWT / none]
- **Testing:** [e.g., Vitest + Playwright / Jest + Cypress]
- **Package Manager:** [npm / pnpm / yarn / bun]

## Project Structure

```
src/
├── app/              # [Describe: pages, routing]
├── features/         # [Describe: feature modules]
├── shared/           # [Describe: reusable components, hooks, utils]
├── lib/              # [Describe: configs, clients, helpers]
└── types/            # [Describe: shared TypeScript types]
```

## Key Conventions

### Naming
- Components: `PascalCase.tsx`
- Hooks: `useCamelCase.ts`
- Utils: `camelCase.ts`
- Types: `camelCase.types.ts`
- Tests: `*.test.ts` / `*.spec.ts`

### State Management
[Describe: Context, Zustand, Redux, server state with TanStack Query, etc.]

### Data Fetching
[Describe: Server Components, API routes, tRPC, etc.]

### Environment Variables
```
# Required
DATABASE_URL=         # [Description]
API_KEY=              # [Description]

# Optional
NEXT_PUBLIC_APP_URL=  # [Description]
```

## Development

```bash
[package-manager] install        # Install dependencies
[package-manager] run dev        # Start dev server
[package-manager] run build      # Production build
[package-manager] test           # Run tests
[package-manager] run lint       # Lint + type check
```

## Project-Specific Rules

### [Rule 1: e.g., API Response Format]
[Describe any project-specific conventions not covered by global rules]

### [Rule 2: e.g., Feature Module Structure]
[Each feature module must have: components/, hooks/, api/, types.ts]

### [Rule 3: e.g., Deployment]
[Describe deployment process, branch strategy, environments]

## Active Decisions

| Decision | Choice | Reason | Date |
|----------|--------|--------|------|
| [e.g., State management] | [e.g., Zustand] | [e.g., Simpler than Redux for our scale] | YYYY-MM-DD |

## Current Focus

[What's being worked on right now — update as the project evolves]
