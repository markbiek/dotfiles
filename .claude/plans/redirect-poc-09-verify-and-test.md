# Plan: Verify Rebase and Run Tests

## Summary
After all conflicts are resolved, verify the rebase completed successfully and run tests to ensure nothing is broken.

## Steps

### 1. Verify rebase is complete:
```bash
git status
```

Should show clean working tree, not in rebase state.

### 2. Check commit history:
```bash
git log --oneline -5
```

Should show our 2 commits on top of trunk.

### 3. Verify our key files exist and look correct:

Check `utils/link.ts` has our additions:
```bash
grep -n "DashboardType\|buildDashboardRedirectUrl\|useDashboardRedirectParams" client/dashboard/utils/link.ts
```

### 4. Check for any TypeScript errors:
```bash
yarn tsc --noEmit -p client/dashboard/tsconfig.json 2>&1 | head -50
```

### 5. Run ESLint on modified files:
```bash
yarn eslint client/dashboard/utils/link.ts
yarn eslint client/dashboard/sites/domains/index.tsx
yarn eslint client/dashboard/sites/settings-site-visibility/privacy-form.tsx
```

### 6. If there are issues, fix them

### 7. Verify the Woo logo commit is still intact:
```bash
git show --stat HEAD
```

### 8. Update PROGRESS.md with final status

## Success Criteria
- Rebase complete (not in rebase state)
- No TypeScript errors in dashboard
- No ESLint errors in modified files
- Both commits preserved

## If Rebase Failed
If the rebase is still in progress or failed:
```bash
git rebase --abort
```
Then re-evaluate the approach.

## Next Steps
After successful verification:
1. Push the rebased branch (may need `--force-with-lease`)
2. Update any open PR

---

After completing this plan, update `~/.claude/plans/PROGRESS.md` with the final status.

Rebase is complete! You can run /clear.
