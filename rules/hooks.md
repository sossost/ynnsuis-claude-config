# Hooks System

Hooks automate quality checks by running shell commands before/after Claude Code tool use.

## Hook Types

| Type | When | Purpose |
|------|------|---------|
| **PreToolUse** | Before a tool runs | Validate, block, or warn |
| **PostToolUse** | After a tool runs | Format, check, or log |
| **Stop** | Session ends | Final verification |

## Recommended Hooks

### PreToolUse

**Dev server tmux enforcement** — Block dev servers not running in tmux:
- Trigger: `npm run dev`, `pnpm dev`, `yarn dev`
- Action: Block and suggest tmux command

**Git push review** — Pause before pushing to verify changes:
- Trigger: `git push`
- Action: Prompt for confirmation

**Doc blocker** — Prevent unnecessary documentation files:
- Trigger: Creating `.md` or `.txt` files
- Exception: `README.md`, `CLAUDE.md`, spec and decision documents

### PostToolUse

**Auto-format** — Run Prettier on JS/TS files after edits:
- Trigger: Edit on `.ts`, `.tsx`, `.js`, `.jsx`
- Action: `prettier --write`

**Type check** — Run TypeScript compiler after TS edits:
- Trigger: Edit on `.ts`, `.tsx`
- Action: `npx tsc --noEmit` (show errors for edited file only)

**Console.log warning** — Flag debug statements in edited files:
- Trigger: Edit on `.ts`, `.tsx`, `.js`, `.jsx`
- Action: Warn if `console.log` found

### Stop

**Console.log audit** — Final check across all modified files:
- Trigger: Session end
- Action: Scan git-modified JS/TS files for `console.log`

## Auto-Accept Permissions

Configure carefully:
- Enable for well-defined plans with trusted patterns
- Disable for exploratory or experimental work
- Never use `dangerously-skip-permissions`
- Prefer `allowedTools` in project config for granular control

## Custom Hook Development

Hooks receive JSON via stdin with tool name and inputs/outputs.
Exit codes: `0` = allow, `1` = block.

```bash
#!/bin/bash
input=$(cat)
file_path=$(echo "$input" | jq -r '.tool_input.file_path // ""')
# Your validation logic here
echo "$input"  # Pass through on success
```
