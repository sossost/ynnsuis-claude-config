# claude-config

Claude Code `.claude` folder template — from idea to shipping code.

## What's Inside

```
├── CLAUDE.md              # Master instructions (Idea→Ship workflow)
├── settings.json          # Hooks (Prettier, TypeScript check, console.log warning)
├── agents/                # 9 specialized agents
│   ├── planner.md         # Implementation planning
│   ├── architect.md       # System design
│   ├── code-reviewer.md   # Code quality review
│   ├── tdd-guide.md       # Test-driven development
│   ├── security-reviewer.md
│   ├── build-error-resolver.md
│   ├── e2e-runner.md
│   ├── doc-updater.md
│   └── refactor-cleaner.md
├── commands/              # 10 workflow commands
│   ├── brainstorm.md      # Ideation → Requirements
│   ├── spec.md            # Requirements → Specification
│   ├── plan.md            # Specification → Implementation plan
│   ├── tdd.md             # Test-driven implementation
│   ├── code-review.md     # Code quality gate
│   ├── build-fix.md       # Build error resolution
│   ├── e2e.md             # E2E test generation
│   ├── test-coverage.md   # Coverage analysis
│   ├── refactor-clean.md  # Dead code removal
│   └── update-docs.md     # Documentation sync
├── rules/                 # 8 coding rules
│   ├── coding-style.md    # Toss-level code quality standard
│   ├── security.md        # OWASP, input validation, secrets
│   ├── testing.md         # TDD, coverage targets
│   ├── git-workflow.md    # Conventional commits, PR workflow
│   ├── performance.md     # Web vitals, rendering, caching
│   ├── patterns.md        # Code & document patterns
│   ├── hooks.md           # Automation hooks reference
│   └── agents.md          # Agent orchestration guide
├── skills/                # 5 contextual reference skills
│   ├── tdd-workflow/
│   ├── security-review/
│   ├── frontend-patterns.md
│   ├── backend-patterns.md
│   └── coding-standards.md
└── templates/
    └── project-claude.md  # Per-project CLAUDE.md template
```

## Install

```bash
git clone https://github.com/sossost/claude-config.git
cd claude-config
./install.sh
```

This will:
- Back up your existing `~/.claude/` automatically
- Copy all config files to `~/.claude/`
- Preserve your `settings.json` if one already exists

## Uninstall

```bash
./uninstall.sh
```

Restores from the most recent backup.

## Per-Project Setup

After installing, set up individual projects:

```bash
mkdir -p my-project/.claude
cp templates/project-claude.md my-project/.claude/CLAUDE.md
# Edit the file to match your project's stack
```

## Workflow

The template is designed around an **Idea → Ship** workflow:

```
/brainstorm  →  /spec  →  /plan  →  /tdd  →  /code-review
```

| Phase | Command | Output |
|-------|---------|--------|
| Ideation | `/brainstorm` | `docs/features/*/01-requirements.md` |
| Decisions | `/spec` | `docs/features/*/02-decisions.md` |
| Specification | `/spec` | `docs/features/*/03-spec.md` |
| Planning | `/plan` | `docs/features/*/04-plan.md` |
| Implementation | `/tdd` | Code + tests |
| Quality | `/code-review` | Review report |

## Code Quality

Coding standards are calibrated to senior-level frontend engineering (Toss-level):

- Explicit null checks (`value == null`, not `!value`)
- Named constants (no magic numbers)
- Discriminated unions over boolean flags
- Early return with guard clauses
- Immutability (spread, map, Immer)
- Composition over inheritance

See `rules/coding-style.md` for the full standard.

## Update

Pull latest and re-run install:

```bash
cd claude-config
git pull
./install.sh
```

## Restore Previous Config

If something goes wrong:

```bash
./uninstall.sh
# or manually:
rm -rf ~/.claude && mv ~/.claude-backup-YYYYMMDD-HHMMSS ~/.claude
```
