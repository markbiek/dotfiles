# Plan: Resolve site-plan.ts Conflict

## Summary
Resolve conflict in `client/dashboard/utils/site-plan.ts`.

## Context
**Trunk's changes:**
- PR #107828: Open links to onboarding URLs in the same tab

**Our changes:**
- Updated the plan upgrade URLs to use our redirect params approach

## Resolution Strategy
Keep our redirect params approach while accepting any other trunk changes.

## Steps

### 1. Check if this file is in conflict:
```bash
git status
```

### 2. Examine the conflict

### 3. Resolution approach:
The file likely has functions that generate URLs to `/setup/plan-upgrade` or similar flows.

Our approach should use:
```typescript
import { buildDashboardRedirectUrl, createDashboardRedirectParams } from './link';

// When creating upgrade URLs:
const redirectParams = createDashboardRedirectParams( currentPath );
addQueryArgs( wpcomLink( '/setup/plan-upgrade' ), {
    siteSlug,
    ...redirectParams,
} );
```

### 4. Stage and continue:
```bash
git add client/dashboard/utils/site-plan.ts
git rebase --continue
```

### 5. Update PROGRESS.md

## Next Plan
Proceed to `redirect-poc-07-resolve-stepper-domain-flow.md`

---

After completing this plan, update `~/.claude/plans/PROGRESS.md` with the status.

You can then run /clear and "/execute-plan redirect-poc-07-resolve-stepper-domain-flow.md"
