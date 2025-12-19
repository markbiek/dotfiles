Check the current changeset for mid-deploy fatal risks.

## Context

During WordPress.com deploys, files update one at a time (not atomically as a group). This means the server may run a mix of old and new code during deployment. Changes that work fine once fully deployed can cause fatal errors mid-deploy.

## What to Analyze

Analyze the staged changes (`git diff --cached`), or if nothing is staged, the unstaged changes (`git diff`). If a specific path or commit range is provided as an argument, analyze that instead.

## Risk Patterns to Check

### 1. Deleted Files
For each deleted file:
- Search the entire codebase for `require`, `require_once`, `include`, `include_once` referencing that path
- Search for `use` statements or autoload references to classes defined in that file
- **Risk**: Old code tries to load a file that no longer exists

### 2. Removed Functions/Methods
For each function or method that was removed or renamed:
- Search for call sites throughout the codebase
- Check if all call sites are updated in the same changeset
- **Risk**: Old code calls a function that doesn't exist yet/anymore

### 3. Removed/Renamed Classes
For each class that was removed or renamed:
- Search for `new ClassName`, `ClassName::`, `extends ClassName`, `implements ClassName`
- Search for type hints and `instanceof` checks
- Check if all references are updated in the same changeset
- **Risk**: Old code references a class that doesn't exist

### 4. Changed Function/Method Signatures
For each function where parameters were added (without defaults) or removed:
- Find all call sites
- Verify they're updated in the same changeset
- **Risk**: Argument count mismatch between old caller and new definition

### 5. Changed Interface/Abstract Methods
For interfaces or abstract classes with modified method signatures:
- Find all implementing classes
- Verify implementations are updated in the same changeset
- **Risk**: Implementation doesn't match interface during transition

### 6. New Dependencies
For each new `require`/`require_once`/`use` statement added:
- Verify the target file exists AND is not also being added in this changeset
- If added in same changeset, this is a risk (new code may load before new file arrives)
- **Risk**: New code tries to load a file that hasn't been deployed yet

### 7. New Functions
For each new function or method:
- Verify that any files using the function or method is not also being added in this changeset
- If added in same changeset, this is a risk (new code may load before new file arrives)
- **Risk**: New code tries to call a function/method in a file that hasn't been deployed yet

## Output Format

Provide a summary with:

**Safe changes**: Brief note of changes that don't pose mid-deploy risks

**Potential risks**: For each risk found:
- File and line number
- What pattern was detected
- Which other files are affected
- Suggested mitigation (e.g., "deploy in two phases: first add the new function, then update callers")

**Recommendations**: If risks are found, suggest how to split the changeset or sequence the deployment safely.

## Mitigations to Suggest

- **Two-phase deploy**: Add new code first, remove old code in a follow-up PR
- **Backwards compatibility**: Keep old function as alias/wrapper temporarily
- **Feature flags**: Gate new code paths until fully deployed
