# Plan: Resolve Billing/Purchase Files Conflicts

## Summary
Resolve conflicts in the billing/purchase related files:
- `client/dashboard/me/billing-purchases/cancel-purchase/cancel-purchase-form/step-components/upsell-step.tsx`
- `client/dashboard/me/billing-purchases/purchase-settings/index.tsx`
- `client/dashboard/utils/purchase.ts`

## Context

### upsell-step.tsx
**Trunk's changes:**
- PR #107951: Fix cancellation flow page title
- PR #107815: Update cancellation notice design

**Our changes:**
- Updated to use `useDashboardRedirectParams()` for checkout redirects

### purchase-settings/index.tsx
**Trunk's changes:**
- PR #107815: Update cancellation notice design
- PR #107813: Remove "Plan features" section
- PR #107811: Remove "downgrade" language

**Our changes:**
- Updated checkout links to use our redirect params

### purchase.ts
**Trunk's changes:**
- PR #107912: Simplify CancelPurchaseForm

**Our changes:**
- Minor updates to use our redirect approach

## Resolution Strategy
For each file:
1. Accept trunk's UI/design changes
2. Keep our redirect param approach for any checkout/external links

## Steps

### 1. Check which files are in conflict:
```bash
git status
```

### 2. For upsell-step.tsx:
- Accept trunk's design updates
- Ensure checkout links use `useDashboardRedirectParams()` and pass `dashboard` + `redirect_to` params
- Import from `../../utils/link` not `../../utils/purchase` for redirect utilities

### 3. For purchase-settings/index.tsx:
- Accept trunk's removal of "Plan features" section
- Accept trunk's removal of "downgrade" language
- Keep our approach for any checkout redirect URLs

### 4. For purchase.ts:
- Accept trunk's simplifications
- Ensure any redirect-related utilities align with our approach

### 5. Stage all resolved files:
```bash
git add client/dashboard/me/billing-purchases/cancel-purchase/cancel-purchase-form/step-components/upsell-step.tsx
git add client/dashboard/me/billing-purchases/purchase-settings/index.tsx
git add client/dashboard/utils/purchase.ts
git rebase --continue
```

### 6. Update PROGRESS.md

## Key Pattern for Checkout Links
Any link to `/checkout` should include:
```typescript
const redirectParams = useDashboardRedirectParams();
// Then in the URL:
addQueryArgs( '/checkout/...', {
    redirect_to: buildDashboardRedirectUrl( redirectParams ),
    cancel_to: buildDashboardRedirectUrl( redirectParams ),
    // OR pass params through:
    ...redirectParams,
} );
```

## Next Plan
Proceed to `redirect-poc-06-resolve-site-plan.md`

---

After completing this plan, update `~/.claude/plans/PROGRESS.md` with the status.

You can then run /clear and "/execute-plan redirect-poc-06-resolve-site-plan.md"
