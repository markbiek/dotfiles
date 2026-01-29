---
description: Check the current changeset for mid-deploy fatal risks.
allowed-tools: Bash(git diff:*), Bash(git diff), Bash(git status:*), Bash(git status), Task
---

Check the current changeset for mid-deploy fatal risks.

## Context

During WordPress.com deploys, files update one at a time (not atomically as a group). This means the server may run a mix of old and new code during deployment. Changes that work fine once fully deployed can cause fatal errors mid-deploy.

## What to Analyze

- Current git status: !`git status --short`
- Staged changes summary: !`git diff --cached --stat`
- Unstaged changes summary: !`git diff --stat`

Analyze the staged changes (`git diff --cached`), or if nothing is staged, the unstaged changes (`git diff`). If a specific path or commit range is provided as an argument, analyze that instead.

## Your Task

1. **Get the diff** using the appropriate git command based on arguments or staged/unstaged state
2. **Parse the diff** to extract:
   - Deleted files
   - Removed functions/methods (lines starting with `-` containing `function `)
   - Removed/renamed classes
   - Changed function signatures
   - Changed interface/abstract methods
   - New `require`/`require_once`/`include`/`use` statements
   - New functions/methods being added
3. **Spawn parallel subagents** for each risk category that has items to check (see below)
4. **Aggregate results** and provide the final report

## Parallel Risk Checks

For each category with items to check, spawn a subagent using the Task tool with `subagent_type: "general-purpose"`. Run all applicable agents in parallel in a single message.

### Agent 1: Deleted Files
```
Check for mid-deploy risks from deleted files.

Deleted files from diff:
[LIST DELETED FILES HERE]

For each deleted file, search the codebase for:
- require, require_once, include, include_once referencing that path
- use statements or autoload references to classes defined in that file

Report any references found outside the current changeset.
Risk: Old code tries to load a file that no longer exists.
```

### Agent 2: Removed Functions/Methods
```
Check for mid-deploy risks from removed functions/methods.

Removed functions from diff:
[LIST REMOVED FUNCTIONS HERE]

For each removed function/method, search for call sites throughout the codebase.
Report any call sites found outside the current changeset.
Risk: Old code calls a function that doesn't exist anymore.
```

### Agent 3: Removed/Renamed Classes
```
Check for mid-deploy risks from removed/renamed classes.

Removed/renamed classes from diff:
[LIST CLASSES HERE]

For each class, search for:
- new ClassName
- ClassName::
- extends ClassName
- implements ClassName
- Type hints and instanceof checks

Report any references found outside the current changeset.
Risk: Old code references a class that doesn't exist.
```

### Agent 4: Changed Function Signatures
```
Check for mid-deploy risks from changed function signatures.

Changed signatures from diff:
[LIST CHANGED SIGNATURES HERE]

For each function where parameters were added (without defaults) or removed:
- Find all call sites
- Check if they're updated in the same changeset

Report any call sites not updated in this changeset.
Risk: Argument count mismatch between old caller and new definition.
```

### Agent 5: Changed Interface/Abstract Methods
```
Check for mid-deploy risks from changed interface/abstract methods.

Changed interfaces/abstracts from diff:
[LIST CHANGES HERE]

For each modified method signature in interfaces or abstract classes:
- Find all implementing classes
- Check if implementations are updated in the same changeset

Report any implementations not updated.
Risk: Implementation doesn't match interface during transition.
```

### Agent 6: New Dependencies
```
Check for mid-deploy risks from new dependencies.

New require/include/use statements from diff:
[LIST NEW DEPENDENCIES HERE]

Files being added in this changeset:
[LIST NEW FILES HERE]

For each new dependency:
- Check if target file exists
- If target is also being added in this changeset, flag as risk

Risk: New code tries to load a file that hasn't been deployed yet.
```

### Agent 7: New Functions Called Prematurely
```
Check for mid-deploy risks from new functions being called too early.

New functions/methods from diff:
[LIST NEW FUNCTIONS HERE]

Files being modified in this changeset:
[LIST MODIFIED FILES HERE]

Check if any existing files (not new in this changeset) are already calling these new functions.
Risk: New code tries to call a function in a file that hasn't been deployed yet.
```

## Output Format

After all agents complete, aggregate their findings into:

**Safe changes**: Brief note of changes that don't pose mid-deploy risks

**Potential risks**: For each risk found:
- File and line number
- What pattern was detected
- Which other files are affected
- Suggested mitigation

**Recommendations**: If risks are found, suggest how to split the changeset or sequence the deployment safely.

## Mitigations to Suggest

- **Two-phase deploy**: Add new code first, remove old code in a follow-up PR
- **Backwards compatibility**: Keep old function as alias/wrapper temporarily
- **Feature flags**: Gate new code paths until fully deployed

## Additional User Context

$ARGUMENTS
