# Plan: Start Rebase and Assess Conflicts

## Summary
Start the rebase of the `update/dashboard-redirect-cleanup` branch onto `origin/trunk` and document the first conflict.

## Context
- Branch has 2 commits: `addd9a51687` (main redirect changes) and `39fba44df93` (WIP: Woo logo)
- Branch is ~204 commits behind trunk
- 10 files have been modified in both branches and will likely conflict

## Files Expected to Conflict
1. `client/dashboard/utils/domain.ts`
2. `client/dashboard/sites/domains/index.tsx`
3. `client/dashboard/sites/settings-site-visibility/privacy-form.tsx`
4. `client/dashboard/me/billing-purchases/cancel-purchase/cancel-purchase-form/step-components/upsell-step.tsx`
5. `client/dashboard/me/billing-purchases/purchase-settings/index.tsx`
6. `client/dashboard/utils/purchase.ts`
7. `client/dashboard/utils/site-plan.ts`
8. `client/landing/stepper/declarative-flow/flows/domain/domain.ts`
9. `client/landing/stepper/declarative-flow/flows/woo-hosted-plans/woo-hosted-plans.ts`
10. `client/landing/stepper/declarative-flow/internals/steps-repository/use-my-domain/index.tsx`

## Important Background
**Our approach is better than trunk's approach.** We're keeping our unified redirect system:
- `DashboardType` ('v2' | 'ciab') as explicit type
- `useDashboardRedirectParams()` / `createDashboardRedirectParams()` to create params
- `buildDashboardRedirectUrl()` to reconstruct URLs in Stepper/Checkout
- Eliminates trunk's `domainConnectionSetupUrl` template URL hack

Trunk created `utils/domain-url.ts` with `getDomainConnectionSetupTemplateUrl()` - we will NOT use this and instead use our approach.

## Steps

1. **Start the rebase:**
   ```bash
   git rebase origin/trunk
   ```

2. **Document which file(s) conflict first**

3. **Check rebase status:**
   ```bash
   git status
   ```

4. **List all conflicting files if multiple**

5. **Update PROGRESS.md with findings**

## Expected Outcome
The rebase will stop at the first conflict(s). Document what we find and which plan to run next.

## Next Plan
After documenting conflicts, proceed to `redirect-poc-02-resolve-domain-utils.md`

---

After completing this plan, update `~/.claude/plans/PROGRESS.md` with the status.

You can then run /clear and "/execute-plan redirect-poc-02-resolve-domain-utils.md"
