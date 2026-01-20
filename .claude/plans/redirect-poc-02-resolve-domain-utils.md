# Plan: Resolve domain.ts and domain-url.ts Conflicts

## Summary
Resolve conflicts in `client/dashboard/utils/domain.ts` and handle trunk's new `domain-url.ts` file.

## Context
Both branches modified `domain.ts`:
- **Trunk**: Removed `useDomainConnectionSetupTemplateUrl()`, added `isTldInMaintenance()` at end of file
- **Our branch**: Removed `useDomainConnectionSetupTemplateUrl()` only

Trunk also created a NEW file `domain-url.ts` that we'll inherit but may need to modify later.

## Resolution Strategy

### For `domain.ts`
Accept both changes:
1. Keep the removal of `useDomainConnectionSetupTemplateUrl()` (both agree)
2. Keep the removal of related imports (both agree)
3. **Accept trunk's addition** of `isTldInMaintenance()` at end of file

### For `domain-url.ts`
This new file from trunk uses the old `domainConnectionSetupUrl` pattern. We'll inherit it for now but it may be deprecated later as consumers switch to our approach.

## Steps

1. **Check current conflict state:**
   ```bash
   git status
   ```

2. **If `domain.ts` has conflicts, open and examine:**
   - Look for `<<<<<<<`, `=======`, `>>>>>>>` markers
   - The conflict should be minimal since both removed the same function

3. **Resolve `domain.ts`:**
   - Remove the `useDomainConnectionSetupTemplateUrl` function (both versions want this)
   - Remove the `useRouter` and `domainConnectionSetupRoute` imports
   - Keep `isTldInMaintenance()` function from trunk (at end of file)

4. **Stage the resolved file:**
   ```bash
   git add client/dashboard/utils/domain.ts
   ```

5. **Continue rebase to see next conflict:**
   ```bash
   git rebase --continue
   ```

6. **Update PROGRESS.md**

## Expected File State After Resolution

The file should have:
- NO `useDomainConnectionSetupTemplateUrl` function
- NO `useRouter` or `domainConnectionSetupRoute` imports
- YES `isTldInMaintenance()` function at end (from trunk)

## Next Plan
Proceed to `redirect-poc-03-resolve-domains-index.md`

---

After completing this plan, update `~/.claude/plans/PROGRESS.md` with the status.

You can then run /clear and "/execute-plan redirect-poc-03-resolve-domains-index.md"
