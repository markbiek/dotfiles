# Plan: Resolve Remaining Stepper Files

## Summary
Resolve conflicts in the remaining Stepper flow files:
- `client/landing/stepper/declarative-flow/flows/woo-hosted-plans/woo-hosted-plans.ts`
- `client/landing/stepper/declarative-flow/internals/steps-repository/use-my-domain/index.tsx`

## Context

### woo-hosted-plans.ts
**Trunk's changes:**
- PR #107857: Update cancel and back links to new dashboard route

**Our changes:**
- Use `dashboard` param to track origin and enable proper redirects back to ciab dashboard

### use-my-domain/index.tsx
**Trunk's changes:**
- PR #107764: Fix the back button on the UseMyDomain screen

**Our changes:**
- Pass through `dashboard` param for redirect handling

## Resolution Strategy
Keep our `dashboard` param approach while accepting trunk's navigation fixes.

## Steps

### 1. Check which files are in conflict:
```bash
git status
```

### 2. For woo-hosted-plans.ts:

This file is critical for the ciab (WooCommerce) dashboard flow. Our changes ensure users coming from `/ciab` get redirected back there.

Key pattern:
```typescript
const query = useQuery();
const dashboard = query.get( 'dashboard' ) ?? undefined;
const redirectTo = query.get( 'redirect_to' ) ?? undefined;

// When building redirect URLs:
const destination = buildDashboardRedirectUrl( { dashboard, redirect_to: redirectTo } );

// When passing to checkout cancel_to:
cancel_to: addQueryArgs( '/setup/woo-hosted-plans', {
    siteSlug,
    dashboard,
    redirect_to: redirectTo,
} ),
```

### 3. For use-my-domain/index.tsx:

Accept trunk's back button fix while ensuring `dashboard` param is passed through.

Our change was minimal - just ensuring the param flows through the navigation.

### 4. Stage all resolved files:
```bash
git add client/landing/stepper/declarative-flow/flows/woo-hosted-plans/woo-hosted-plans.ts
git add client/landing/stepper/declarative-flow/internals/steps-repository/use-my-domain/index.tsx
git rebase --continue
```

### 5. Update PROGRESS.md

## Next Plan
Proceed to `redirect-poc-09-verify-and-test.md`

---

After completing this plan, update `~/.claude/plans/PROGRESS.md` with the status.

You can then run /clear and "/execute-plan redirect-poc-09-verify-and-test.md"
