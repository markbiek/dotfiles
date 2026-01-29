---
name: wpcom-deploy-safety
description: Check PHP changesets for mid-deploy fatal risks on WordPress.com. Use BEFORE committing or creating PRs when working in the wpcom codebase (public_html with lib/ and wp-content/ directories). Automatically invoke when preparing commits or PRs that include PHP file changes in a wpcom environment.
---

# WordPress.com Deploy Safety Check

WordPress.com deploys files one at a time (not atomically). The server may run a mix of old and new code mid-deploy, causing fatal errors even when the final state is valid.

## When to Run

Invoke before committing or creating PRs when:
- Working in wpcom codebase (public_html with lib/ and wp-content/)
- Changes include PHP files
- Changes involve deletions, renames, or signature changes

## Analysis Process

1. Get the changeset (`git diff --cached` or `git diff`)
2. Check each risk pattern below
3. Report findings with mitigations

## Risk Patterns

### Deleted Files
Search for `require`, `require_once`, `include`, `include_once`, `use` statements referencing deleted files.

**Risk**: Old code loads a file that no longer exists.

### Removed/Renamed Functions, Methods, Classes
Search for call sites, type hints, `instanceof`, `extends`, `implements` referencing removed items.

**Risk**: Old code references something that doesn't exist.

### Changed Signatures
Find call sites for functions with added required params or removed params.

**Risk**: Argument count mismatch between old caller and new definition.

### New Dependencies in Same Changeset
Check if new `require`/`use` targets a file also being added. Check if calls to new functions are in files also being modified.

**Risk**: New code loads/calls something that hasn't deployed yet.

## Output Format

```markdown
## Safe Changes
[Changes without mid-deploy risks]

## Potential Risks
- **File:line** - Pattern detected
- **Affected files**: [list]
- **Mitigation**: [suggestion]

## Recommendations
[How to split changeset or sequence deployment]
```

## Mitigations

- **Two-phase deploy**: Add new code first, remove old in follow-up PR
- **Backwards compatibility**: Keep old function as alias temporarily
- **Feature flags**: Gate new code paths until fully deployed

Link: https://fieldguide.automattic.com/atomicity-in-the-wordpress-com-deploy-system/
