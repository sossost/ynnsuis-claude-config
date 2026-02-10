---
description: "Find and remove dead code, unused dependencies, and duplicate implementations. Safety-first with test verification after each batch."
---

# Refactor Clean Command

Remove dead code and consolidate duplicates safely.

## What This Command Does

1. **Detect** - Run analysis tools to find unused code and dependencies
2. **Classify Risk** - Categorize findings by safety level
3. **Verify** - Confirm each item is truly unused before removal
4. **Remove in Batches** - One category at a time with test verification
5. **Document** - Track all removals for audit trail

## When to Use

Use `/refactor-clean` when:
- Codebase has accumulated dead code over time
- Dependencies are bloated
- Multiple implementations of the same thing exist
- After a large refactoring or migration
- Bundle size is growing without justification

## How It Works

### Step 1: Detect

```bash
npx knip                                      # Unused files, exports, deps
npx depcheck                                  # Unused npm packages
npx ts-prune                                  # Unused TypeScript exports
npx eslint . --report-unused-disable-directives  # Dead lint rules
```

### Step 2: Classify Risk

| Risk | Description | Examples |
|------|-------------|---------|
| **SAFE** | No references anywhere | Unused private functions, unused deps |
| **CAREFUL** | Possibly used dynamically | String-based imports, config-loaded modules |
| **RISKY** | Part of public API or shared code | Exported utilities, shared components |

### Step 3: Verify Before Removing

For each item:
- Search for all references in the codebase
- Check for dynamic imports (`import()`, `require()`)
- Check for string references in configs
- Review git log for recent context
- When in doubt, do NOT remove — flag for manual review

### Step 4: Remove in Batches

One category at a time, in this order:
1. **Unused npm dependencies** - `npm uninstall [package]`
2. **Unused internal exports** - Delete export, keep function if internally used
3. **Unused files** - Delete entire file
4. **Duplicate code** - Consolidate to best version, update all imports

**After each batch:**
```bash
npm run build && npm test
```

If build or tests fail, revert the batch immediately.

### Step 5: Document

```markdown
## [YYYY-MM-DD] Cleanup Session

### Dependencies Removed
- [package]@[version] - [reason unused]

### Files Deleted
- src/old-component.tsx - replaced by src/shared/component.tsx

### Exports Removed
- src/utils.ts: deprecatedHelper() - zero references

### Impact
- Files: -N, Dependencies: -N, Lines: -N
```

## Duplicate Consolidation

When multiple implementations exist:
1. Identify the best version (most tested, most complete, best typed)
2. Update all imports to use the chosen version
3. Delete the duplicates
4. Run full test suite

## Safety Rules

- **Never remove** code you don't understand
- **Always** run full test suite after each batch
- **Create backup branch** before starting: `git checkout -b cleanup/[date]`
- **When in doubt**, don't remove — flag for manual review
- **Never clean** during active feature development
- **Never clean** without adequate test coverage

## Integration with Other Commands

- `/test-coverage` to ensure adequate coverage before cleanup
- `/build-fix` if cleanup breaks the build
- `/code-review` to review cleanup changes

## Related Agent

This command invokes the `refactor-cleaner` agent.
