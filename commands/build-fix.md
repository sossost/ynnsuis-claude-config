---
description: "Incrementally fix TypeScript and build errors. One error at a time, minimal diffs only. Stop if fix introduces new errors."
---

# Build Fix Command

Fix build and type errors incrementally with minimal changes.

## What This Command Does

1. **Run Build** - Collect all errors from TypeScript and build tools
2. **Categorize** - Group by file, sort by severity
3. **Fix One at a Time** - Apply minimal fix, verify, repeat
4. **Guard Rails** - Stop if fix introduces new errors or same error persists
5. **Report** - Summary of errors fixed, remaining, and introduced

## When to Use

Use `/build-fix` when:
- `npm run build` or `tsc` fails
- TypeScript type errors appear after changes
- Lint errors block the build
- Import/export issues after refactoring
- Dependency updates cause type breakage

## How It Works

### Step 1: Collect Errors

```bash
npx tsc --noEmit --pretty    # Type errors
npm run build                  # Build errors
npx eslint . --ext .ts,.tsx    # Lint errors
```

### Step 2: Categorize

- **Blocking** - Build completely broken (fix first)
- **Type errors** - Fix in dependency order (interfaces before implementations)
- **Warnings** - Fix if time permits

### Step 3: Fix Loop

For each error:
1. Read the error message carefully
2. Show error context (surrounding code)
3. Find the minimal fix (1-3 lines ideally)
4. Apply the fix
5. Re-run type check to verify
6. Confirm no new errors introduced

### Step 4: Safety Stops

**Stop immediately if:**
- A fix introduces MORE errors than it solves
- Same error persists after 3 attempts
- User requests pause
- Fix requires architectural changes (escalate to `/plan`)

### Step 5: Report

```markdown
# Build Fix Report

**Initial Errors:** X
**Errors Fixed:** Y
**Errors Remaining:** Z
**New Errors Introduced:** 0

## Fixes Applied
1. `src/file.ts:45` - Added type annotation (1 line)
2. `src/other.ts:12` - Fixed import path (1 line)

## Verification
- [x] tsc --noEmit passes
- [x] npm run build succeeds
- [x] No new errors introduced
```

## Minimal Diff Rules

**DO:**
- Add type annotations
- Add null checks / optional chaining
- Fix import/export paths
- Install missing type packages
- Update type definitions

**DO NOT:**
- Refactor unrelated code
- Change architecture
- Rename variables (unless causing the error)
- Add features
- Optimize performance
- Improve code style

**Fix the error. Verify the build. Move on.**

## Integration with Other Commands

- `/code-review` after build is green
- `/tdd` if errors reveal missing test coverage
- `/plan` if fix requires significant changes

## Related Agent

This command invokes the `build-error-resolver` agent.
