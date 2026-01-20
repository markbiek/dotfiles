# Plan: Resolve Stepper Domain Flow Conflict (Complex)

## Summary
Resolve the complex conflict in `client/landing/stepper/declarative-flow/flows/domain/domain.ts`.

This is the most complex conflict because both branches made significant changes to redirect handling.

## Context
**Trunk's changes:**
- PR #107676: Added domain transfer handling - redirects single domain transfers to `/domains/$domain/domain-transfer-setup`
- Still uses `domainConnectionSetupUrl` query param with `%s` template replacement

**Our changes:**
- Replaced `domainConnectionSetupUrl` pattern entirely with `dashboard` + `redirect_to` params
- Uses `buildDashboardRedirectUrl()` to reconstruct URLs
- Reads `dashboard` param from query string
- Passes `dashboard` param through to checkout's `cancel_to`

## Resolution Strategy
**Use our approach** but **incorporate trunk's domain transfer logic**.

We need to:
1. Keep our `buildDashboardRedirectUrl()` approach
2. Add trunk's domain transfer detection and redirect logic

## Steps

### 1. Check if this file is in conflict:
```bash
git status
```

### 2. Key imports to keep:
```typescript
import { isDomainMapping, isDomainTransfer } from '@automattic/calypso-products';  // Add isDomainTransfer from trunk
import { buildDashboardRedirectUrl, dashboardLink } from 'calypso/dashboard/utils/link';  // Our approach
```

### 3. Key variables in useStepNavigation:
```typescript
const query = useQuery();
const dashboard = query.get( 'dashboard' ) ?? undefined;
const redirectTo = query.get( 'redirect_to' ) ?? undefined;
const defaultRedirect = dashboardLink( `/sites/${ siteSlug }/domains` );

// Build final redirect URL from dashboard params
const redirectFromParams = buildDashboardRedirectUrl( { dashboard, redirect_to: redirectTo } );
```

### 4. In goToCheckout function - MERGE both approaches:
```typescript
const goToCheckout = ( siteSlug: string ) => {
    const hasOnlyDomainConnection =
        domainCartItems && domainCartItems.length === 1 && isDomainMapping( domainCartItems[ 0 ] );
    // ADD FROM TRUNK:
    const hasOnlyDomainTransfer =
        domainCartItems && domainCartItems.length === 1 && isDomainTransfer( domainCartItems[ 0 ] );

    // Use our redirect approach
    let destination = redirectFromParams || dashboardLink( `/sites/${ siteSlug }/domains` );

    // Domain connection redirect (our approach)
    if ( ! redirectFromParams && hasOnlyDomainConnection ) {
        const domain = domainCartItems[ 0 ].meta;
        if ( domain ) {
            destination = dashboardLink( `/domains/${ domain }/domain-connection-setup` );
        }
    }

    // ADD FROM TRUNK: Domain transfer redirect
    if ( hasOnlyDomainTransfer ) {
        const domain = domainCartItems[ 0 ].meta;
        if ( domain ) {
            destination = dashboardLink( `/domains/${ domain }/domain-transfer-setup` );
        }
    }

    // Rest of checkout redirect with our cancel_to approach...
};
```

### 5. For domain connection completion (ownership verification):
Use our approach:
```typescript
window.location.href = buildDashboardRedirectUrl( {
    dashboard,
    redirect_to: `/domains/${ providedDependencies.domain }/domain-connection-setup`,
} );
```

### 6. Stage and continue:
```bash
git add client/landing/stepper/declarative-flow/flows/domain/domain.ts
git rebase --continue
```

### 7. Update PROGRESS.md

## Critical: Do NOT use `domainConnectionSetupUrl` pattern
The old pattern with `%s` replacement is being eliminated by our approach. Any code that did:
```typescript
domainConnectionSetupUrl.replace( '%s', domain )
```
Should instead use:
```typescript
buildDashboardRedirectUrl( { dashboard, redirect_to: `/domains/${ domain }/domain-connection-setup` } )
```

## Next Plan
Proceed to `redirect-poc-08-resolve-remaining-stepper.md`

---

After completing this plan, update `~/.claude/plans/PROGRESS.md` with the status.

You can then run /clear and "/execute-plan redirect-poc-08-resolve-remaining-stepper.md"
