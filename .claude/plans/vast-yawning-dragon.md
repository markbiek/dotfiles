# Investigation: Domain Purchase Redirect Issue in CIAB Dashboard

## Problem Summary
When purchasing a domain from the `/ciab` dashboard for a Garden site, users end up at `/setup/...` instead of returning to the CIAB dashboard. This worked correctly on Nov 7, but broke sometime after.

## Root Cause

The issue is caused by the checkout redirect logic in `get-thank-you-page-url/index.ts` which checks for `signupFlowName === 'domain'` and then uses a cookie-stored URL instead of the `redirect_to` parameter.

### The Problematic Code

**File**: `client/my-sites/checkout/get-thank-you-page-url/index.ts` (lines 388-406):

```typescript
const signupFlowName = getSignupCompleteFlowName();

if (
  ( [ 'no-user', 'no-site' ].includes( String( cart?.cart_key ?? '' ) ) ||
    signupFlowName === 'domain' ) &&  // <-- THIS TRIGGERS FOR DOMAIN FLOW
  urlFromCookie &&                      // <-- STALE /setup URL FROM COOKIE
  receiptIdOrPlaceholder &&
  ! urlFromCookie.includes( '/start/setup-site' )
) {
  // Uses cookie URL instead of redirect_to parameter
  return `${ urlFromCookie }/${ receiptIdOrPlaceholder }`;
}
```

### Why This Happens

1. User starts domain purchase from `/ciab/sites/{siteSlug}/domains`
2. `AddDomainButton` navigates to `/setup/domain?siteSlug={siteSlug}...`
3. The domain flow (`domain.ts`) sets `signupFlowName = 'domain'` via `setSignupCompleteFlowName(this.name)`
4. A stale `/setup` URL exists in the signup destination cookie (from previous onboarding or other flow)
5. At checkout completion, the code checks `signupFlowName === 'domain'` + `urlFromCookie` exists → uses cookie URL instead of `redirect_to`

### Contributing Changes (Nov 7 - Nov 26)

Key commits that modified this flow:

1. **`778aa1228e1` (Nov 11)** - "Setup Domain: Preserve existing site when going through plans"
   - Added `goToCheckout` helper function that hardcodes destination to `/v2/sites/{siteSlug}/domains`
   - Added `setSignupCompleteFlowName(this.name)` in more code paths

2. **`ca906abcde4` (Nov 11)** - "Setup Domain: Redirect to domain connection setup if adding a connection to an existing site on a paid plan"
   - Changed domain mapping redirect logic

3. **`96da832458d` (Nov 18)** - "Garden: Domain mapping plan check"
   - Changed from `is_garden` check to plan feature check for domain mapping

### Flow Trace

For domain registration on Garden site:

```
/ciab/sites/{siteSlug}/domains
    ↓
AddDomainButton → /setup/domain?siteSlug={siteSlug}&domainConnectionSetupUrl=...
    ↓
DOMAIN_SEARCH step → selects domain → site has no paid plan
    ↓
UNIFIED_PLANS step → user selects plan → goToCheckout(siteSlug)
    ↓
/checkout/{siteSlug}?redirect_to=/v2/sites/{siteSlug}/domains&signup=1
    ↓
getThankYouPageUrl() → signupFlowName='domain' + urlFromCookie exists
    ↓
Returns cookie URL (with /setup) instead of redirect_to parameter
    ↓
User lands on /setup/... instead of /ciab or /v2 dashboard
```

### The Bug

In `domain.ts` `goToCheckout` function (lines 95-107):

```typescript
const goToCheckout = ( siteSlug: string ) => {
  const destination = `/v2/sites/${ siteSlug }/domains`;  // Hardcoded, ignores redirectTo param

  return window.location.replace(
    addQueryArgs( `/checkout/${ encodeURIComponent( siteSlug ) }`, {
      redirect_to: destination,
      signup: 1,  // <-- Triggers signup flow logic in checkout
      cancel_to: new URL( addQueryArgs( '/setup/domain', { siteSlug } ), window.location.href ).href,
    } )
  );
};
```

Issues:
1. `destination` is hardcoded, doesn't use the `redirectTo` query parameter that could point back to CIAB
2. `signup: 1` flag triggers the signup flow cookie logic in checkout
3. The `useSideEffect` clears cookies on flow entry, but doesn't prevent them from being set/read during checkout

## Key Files

| File | Role |
|------|------|
| `client/landing/stepper/declarative-flow/flows/domain/domain.ts` | Domain flow navigation & checkout redirect |
| `client/my-sites/checkout/get-thank-you-page-url/index.ts` | Post-checkout URL determination |
| `client/dashboard/domains/add-domain-button.tsx` | Initiates domain flow from dashboard |
| `client/signup/storageUtils.js` | Cookie/sessionStorage management for signup flows |

## Relevant Commits Since Nov 7

| Commit | Date | Description |
|--------|------|-------------|
| `778aa1228e1` | Nov 11 | Setup Domain: Preserve existing site when going through plans |
| `ca906abcde4` | Nov 11 | Setup Domain: Redirect to domain connection setup for paid plans |
| `d6132e91c6a` | Nov 11 | Allow changing redirect_to in the domain flow |
| `96da832458d` | Nov 18 | Garden: Domain mapping plan check |
| `702252dd95d` | Nov 21 | Use domainConnectionSetupUrl in setup/domain flow |
