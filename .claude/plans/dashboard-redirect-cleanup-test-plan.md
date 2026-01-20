# Test Plan: Dashboard Redirect Cleanup

## Overview

This PR introduces a unified approach for handling redirects between the Hosting Dashboard (/v2 and /ciab) and Stepper flows. Key changes:

1. New `dashboard=` query parameter that identifies which dashboard the user came from
2. `redirect_to` now contains only the path portion (e.g., `/sites/example.com/domains`) instead of full URLs
3. Stepper flows use `buildDashboardRedirectUrl()` to reconstruct the full redirect URL
4. Woo branding shown in Stepper when `dashboard=ciab`

---

## Test Environments

- [ ] Local development (my.localhost:3000)
- [ ] Horizon
- [ ] Production (my.wordpress.com)

---

## Part 1: Dashboard → Stepper → Dashboard Redirects

### 1.1 Plan Upgrade Flow (from /v2 dashboard)

**Setup:** Navigate to `/v2/sites/{site-slug}/settings` on a site without a Business plan.

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Click "Upgrade" or any plan upgrade CTA | URL should contain `dashboard=v2` and `redirect_to=/sites/{site-slug}/...` |
| 2 | Select a plan and proceed to checkout | Checkout URL should have proper `redirect_to` and `cancel_to` params |
| 3 | Click cancel/back from checkout | Should return to the /v2 dashboard page you started from |
| 4 | Complete checkout | Should redirect back to the /v2 dashboard |

### 1.2 Plan Upgrade Flow (from /ciab dashboard)

**Setup:** Navigate to `/ciab/sites/{site-slug}/settings` on a CIAB site.

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Click any upgrade CTA | URL should contain `dashboard=ciab` and `redirect_to=/sites/{site-slug}/...` |
| 2 | Verify Stepper branding | **Woo logo** should appear instead of WordPress logo in the header |
| 3 | Select a plan and proceed to checkout | Checkout URL should have proper params |
| 4 | Click cancel/back from checkout | Should return to the /ciab dashboard |
| 5 | Complete checkout | Should redirect back to the /ciab dashboard |

### 1.3 Domain Flow (from /v2 dashboard)

**Setup:** Navigate to `/v2/sites/{site-slug}/domains`.

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Click "Add a domain" | Stepper URL should contain `dashboard=v2` param |
| 2 | Search for and select a domain | Should proceed to checkout with proper redirect params |
| 3 | Cancel from checkout | Should return to /v2 domains page |
| 4 | Complete purchase | Should redirect to /v2 domains page (or domain connection setup if applicable) |

### 1.4 Domain Flow (from /ciab dashboard)

**Setup:** Navigate to `/ciab/sites/{site-slug}/domains`.

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Click "Add a domain" | Stepper URL should contain `dashboard=ciab` param |
| 2 | Verify Stepper branding | **Woo logo** should appear |
| 3 | Search for and select a domain | Should proceed to checkout with proper redirect params |
| 4 | Cancel from checkout | Should return to /ciab domains page |
| 5 | Complete purchase | Should redirect to /ciab dashboard |

---

## Part 2: Specific Dashboard Entry Points

### 2.1 Site Launch Button (`/sites/{site-slug}`)

| Dashboard | Action | Expected Result |
|-----------|--------|-----------------|
| /v2 | Click "Launch site" on unlaunched site | Upgrade flow should have `dashboard=v2` |
| /ciab | Click "Launch site" on unlaunched site | Upgrade flow should have `dashboard=ciab` + Woo branding |

### 2.2 Storage Add-on Modal

**Setup:** Navigate to site overview for a site eligible for storage upgrades.

| Dashboard | Action | Expected Result |
|-----------|--------|-----------------|
| /v2 | Click to add storage → proceed to checkout | Should redirect back to /v2 after checkout |
| /ciab | Click to add storage → proceed to checkout | Should redirect back to /ciab after checkout |

### 2.3 Trial Ended Page (`/sites/{site-slug}` for expired trial)

| Dashboard | Action | Expected Result |
|-----------|--------|-----------------|
| /v2 | Click upgrade CTA | Should redirect back to /v2 after checkout |
| /ciab | Click upgrade CTA | Should redirect back to /ciab after checkout + Woo branding |

### 2.4 Privacy/Visibility Settings

**Setup:** Navigate to `/v2/sites/{site-slug}/settings/site-visibility`.

| Dashboard | Action | Expected Result |
|-----------|--------|-----------------|
| /v2 | Attempt to launch → need plan upgrade | Upgrade flow returns to /v2 |
| /ciab | Attempt to launch → need plan upgrade | Upgrade flow returns to /ciab + Woo branding |

### 2.5 Domain Upsell Card (Site Overview)

| Dashboard | Action | Expected Result |
|-----------|--------|-----------------|
| /v2 | Click domain upsell CTA | Domain flow with `dashboard=v2` |
| /ciab | Click domain upsell CTA | Domain flow with `dashboard=ciab` + Woo branding |

### 2.6 Hosting Feature Gated (Activation/Upsell)

| Dashboard | Action | Expected Result |
|-----------|--------|-----------------|
| /v2 | Click upgrade for gated feature | Returns to /v2 after upgrade |
| /ciab | Click upgrade for gated feature | Returns to /ciab after upgrade |

### 2.7 Site Redirects (`/sites/{site-slug}/settings/redirect`)

| Dashboard | Action | Expected Result |
|-----------|--------|-----------------|
| /v2 | Create redirect requiring upgrade | Upgrade flow returns to /v2/sites/.../settings/redirect |
| /ciab | Create redirect requiring upgrade | Upgrade flow returns to /ciab/sites/.../settings/redirect |

### 2.8 Cancel Purchase Upsell Step

**Setup:** Navigate to `/v2/me/billing/purchases/{purchaseId}/cancel`.

| Dashboard | Action | Expected Result |
|-----------|--------|-----------------|
| /v2 | Click upsell CTA during cancel flow | Should return to /v2 after any upgrade |
| /ciab | Click upsell CTA during cancel flow | Should return to /ciab after any upgrade |

### 2.9 Purchase Settings/Notices

**Setup:** Navigate to `/v2/me/billing/purchases/{purchaseId}`.

| Dashboard | Action | Expected Result |
|-----------|--------|-----------------|
| /v2 | Click any upgrade/renewal CTAs | Should return to /v2 after checkout |
| /ciab | Click any upgrade/renewal CTAs | Should return to /ciab after checkout |

---

## Part 3: Woo Branding Verification

### 3.1 TopBar Logo in Stepper

| Scenario | Expected |
|----------|----------|
| Navigate to `/setup/plan-upgrade?siteSlug=...` (no dashboard param) | WordPress logo |
| Navigate to `/setup/plan-upgrade?siteSlug=...&dashboard=v2` | WordPress logo |
| Navigate to `/setup/plan-upgrade?siteSlug=...&dashboard=ciab` | **Woo logo** |
| Navigate to `/setup/domain?siteSlug=...&dashboard=ciab` | **Woo logo** |

---

## Part 4: Backwards Compatibility

### 4.1 Legacy Redirects (no `dashboard` param)

| Scenario | Expected |
|----------|----------|
| External link with only `redirect_to=/some/path` (no dashboard) | Should use redirect_to as-is (legacy behavior) |
| Existing bookmarks/links without dashboard param | Should continue to work |

### 4.2 Backport Mode

| Scenario | Expected |
|----------|----------|
| Running dashboard in Calypso backport mode | Should use relative paths without dashboard param |

---

## Part 5: Edge Cases

### 5.1 URL Parameter Encoding

| Scenario | Expected |
|----------|----------|
| Site slug with special characters | Should be properly encoded in redirect params |
| Paths with query strings | Should preserve query strings in redirect_to |

### 5.2 Environment Differences

| Environment | Expected Behavior |
|-------------|------------------|
| Local dev (my.localhost:3000) | Links construct with localhost origin |
| Production (my.wordpress.com) | Links construct with my.wordpress.com |

---

## Part 6: Smoke Tests

Quick sanity checks to run before merging:

- [ ] From /v2: Add domain → complete flow → returns to /v2
- [ ] From /ciab: Add domain → complete flow → returns to /ciab
- [ ] From /v2: Upgrade plan → complete checkout → returns to /v2
- [ ] From /ciab: Upgrade plan → see Woo logo → complete checkout → returns to /ciab
- [ ] Click cancel/back at any point in Stepper → returns to correct dashboard
- [ ] Legacy links without `dashboard` param still work

---

## Notes

- The `dashboard` parameter is used both for redirect construction AND for branding decisions in Stepper
- When `dashboard=ciab`, Stepper shows Woo branding instead of WordPress
- The `redirect_to` parameter should be a path only (e.g., `/sites/example.com`), not a full URL
- `buildDashboardRedirectUrl()` reconstructs the full URL based on the dashboard type
