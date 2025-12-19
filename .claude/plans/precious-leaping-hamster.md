# Remove domainConnectionSetupUrl Parameter

## Problem
The `domainConnectionSetupUrl` parameter passes a full URL template (e.g., `https://my.wordpress.com/v2/domains/%s/domain-connection-setup`) through domain flows. This bakes in the dashboard prefix, causing users from `/ciab` to be redirected to `/v2`.

## Solution
Remove `domainConnectionSetupUrl` entirely. The domain flow will construct the redirect URL using:
- The `dashboard` param (already implemented)
- A known path pattern: `/domains/{domain}/domain-connection-setup`

## Implementation

### Phase 1: Remove from Dashboard Sources

**1. Delete `useDomainConnectionSetupTemplateUrl()` hook**
- File: `client/dashboard/utils/domain.ts`
- Remove the entire function

**2. Update `AddDomainButton` component**
- File: `client/dashboard/domains/add-domain-button.tsx`
- Remove `domainConnectionSetupUrl` prop
- Remove from `buildQueryArgs()` function

**3. Update `SiteDomains` component**
- File: `client/dashboard/sites/domains/index.tsx`
- Remove `useDomainConnectionSetupTemplateUrl()` call
- Remove `domainConnectionSetupUrl` prop from `<AddDomainButton>`

**4. Update `PrivacyForm` component**
- File: `client/dashboard/sites/settings-site-visibility/privacy-form.tsx`
- Remove `useDomainConnectionSetupTemplateUrl()` call
- Remove `domainConnectionSetupUrl` from `getAddNewDomainUrl()` query args

### Phase 2: Update Domain Flow Consumer

**File: `client/landing/stepper/declarative-flow/flows/domain/domain.ts`**

Replace `domainConnectionSetupUrl` usage with `buildDashboardRedirectUrl()`:

```typescript
// Before
const domainConnectionSetupUrl = queryArgs.domainConnectionSetupUrl as string | undefined;
window.location.href = domainConnectionSetupUrl
  ? domainConnectionSetupUrl.replace('%s', domain)
  : defaultRedirect;

// After
const domainConnectionRedirect = buildDashboardRedirectUrl({
  dashboard,
  redirect_to: `/domains/${domain}/domain-connection-setup`,
});
window.location.href = domainConnectionRedirect;
```

**Locations to update in domain.ts:**
1. After ownership verification (USE_MY_DOMAIN.slug case, ~line 191-193)
2. After domain mapping with paid plan (~line 239-245)

## Files to Modify

| File | Action |
|------|--------|
| `client/dashboard/utils/domain.ts` | Delete `useDomainConnectionSetupTemplateUrl()` |
| `client/dashboard/domains/add-domain-button.tsx` | Remove prop and query arg |
| `client/dashboard/sites/domains/index.tsx` | Remove hook call and prop |
| `client/dashboard/sites/settings-site-visibility/privacy-form.tsx` | Remove hook call and query arg |
| `client/landing/stepper/declarative-flow/flows/domain/domain.ts` | Use `buildDashboardRedirectUrl()` instead |

## Backwards Compatibility

- If `dashboard` param is missing in older flows, `buildDashboardRedirectUrl()` returns `/v2/domains/{domain}/domain-connection-setup` (default)
- This maintains the existing default behavior while fixing the ciab redirect issue
