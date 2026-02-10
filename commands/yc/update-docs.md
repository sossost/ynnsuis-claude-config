---
description: "Sync documentation with current codebase. Generate codemaps from code structure, update READMEs, verify all file references and links."
---

# Update Docs Command

Generate and update documentation from the actual codebase.

## What This Command Does

1. **Scan Codebase** - Analyze file structure, exports, and dependencies
2. **Generate Codemaps** - Create architectural maps from code (not from memory)
3. **Update README** - Sync setup instructions, scripts, and directory descriptions
4. **Verify Links** - Ensure all file paths and references are valid
5. **Add Timestamps** - Mark when documentation was last updated

## When to Use

Use `/yc:update-docs` when:
- New features or modules have been added
- API endpoints have changed
- Dependencies have been added or removed
- Architecture has been modified
- Before onboarding new contributors
- Documentation is stale or references deleted files

## How It Works

### Step 1: Analyze Repository

Discover the current codebase structure:
- File tree and directory organization
- Module exports and their relationships
- Package.json scripts and dependencies
- Environment variables from .env.example

### Step 2: Generate Codemaps

Output to `docs/CODEMAPS/`:

```markdown
# [Area] Architecture

**Last Updated:** YYYY-MM-DD
**Entry Point:** src/app/layout.tsx

## Structure

src/features/auth/
├── components/     # Login form, signup form
├── hooks/          # useAuth, useSession
├── services/       # auth-api.ts, token.ts
└── types.ts        # AuthState, User, Session

## Key Modules

| Module | Purpose | Exports |
|--------|---------|---------|
| useAuth | Auth state management | useAuth hook |
| auth-api | Login/signup API calls | login, signup, logout |

## Data Flow

User -> LoginForm -> useAuth -> auth-api -> /api/auth -> database -> session
```

### Step 3: Update README

Sync with current state:
- Setup instructions (from package.json scripts)
- Environment variables (from .env.example)
- Key directories (from actual file tree)
- Available commands (from scripts)

### Step 4: Verify Everything

- [ ] All file paths in docs exist in codebase
- [ ] All links resolve (internal and external)
- [ ] Code examples compile and are current
- [ ] Timestamps are updated
- [ ] No references to deleted files or deprecated APIs

## Documentation Rules

1. **Single source of truth** - Generate from code, never write from memory
2. **Freshness timestamps** - Always include "Last Updated" date
3. **Verify everything** - All file paths must exist, all links must resolve
4. **Keep it concise** - Under 500 lines per codemap
5. **Code examples must work** - Test snippets before including

## When to Update vs Skip

**Update:** New feature, API change, dependency change, architecture change
**Skip:** Minor bug fix, cosmetic change, refactoring without API changes

## Integration with Other Commands

- After `/yc:plan` and implementation to document new features
- After `/yc:refactor-clean` to remove references to deleted code
- Before `/yc:code-review` to ensure docs are current

## Related Agent

This command invokes the `doc-updater` agent.
