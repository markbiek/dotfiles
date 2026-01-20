# Plan: Fix Issues from Multi-Path Review

## Issues to Address

From code review feedback in `/tmp/out.md`:

### 1. Root path matching bug (FIX)
**File:** `src/matcher.ts:79-82`

The path containment check fails when watching `/`:
```typescript
if (!normalizedFilePath.startsWith(normalizedWatchedPath + '/') &&
    normalizedFilePath !== normalizedWatchedPath) {
```
When `watchedPath` is `/`, this becomes `startsWith('//')` which never matches.

**Fix:** Handle root path as special case, or use a path-aware containment check.

### 2. Shell injection with paths containing spaces (DOCUMENT)
**File:** `src/actions/shell.ts`

The `{path}` variable (like all variables) is interpolated without escaping. Paths with spaces like `/Volumes/My External Drive` will break commands unless quoted.

**Fix:** Document in README that users should quote variables in commands.

### 3. IndexOf fragility (FIX)
**File:** `src/pipeline.ts:135`

Using `indexOf(match)` on object reference works but is fragile:
```typescript
const remainingRules = matchingRules.length - matchingRules.indexOf(match) - 1;
```

**Fix:** Use a for-of loop with index instead.

### 4. forEach style inconsistency (FIX)
**File:** `bin/fw.ts:168-172`

Changed to `forEach` to fix TypeScript error, but for-of is more consistent with codebase.

**Fix:** Use for-of loop with explicit typing.

### 5. O(n×m) performance (SKIP)
Not urgent for typical configs. Note for future if needed.

## Files to Modify

| File | Change |
|------|--------|
| `src/matcher.ts` | Fix root path edge case |
| `src/pipeline.ts` | Use loop index instead of indexOf |
| `bin/fw.ts` | Use for-of loop instead of forEach |
| `README.md` | Document quoting variables in commands |

## Implementation Details

### matcher.ts fix
```typescript
function matchesPath(filepath: string, watchedPath: string, pattern: string): boolean {
  const normalizedFilePath = resolve(filepath);
  const normalizedWatchedPath = resolve(watchedPath);

  // Handle root path special case
  const isWithinPath = normalizedWatchedPath === '/'
    ? true  // Root contains everything
    : normalizedFilePath === normalizedWatchedPath ||
      normalizedFilePath.startsWith(normalizedWatchedPath + '/');

  if (!isWithinPath) {
    return false;
  }
  // ... rest unchanged
}
```

### pipeline.ts fix
Change to use index in the loop instead of indexOf.

### bin/fw.ts fix
```typescript
for (const [i, match] of matches.entries()) {
  console.log(`${i + 1}. ${chalk.cyan(match.rule.name)}`);
  // ...
}
```

### README.md addition
Add note about quoting variables in shell commands.
