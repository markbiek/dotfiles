# Plan: Resolve privacy-form.tsx Conflict

## Summary
Resolve conflict in `client/dashboard/sites/settings-site-visibility/privacy-form.tsx`.

## Context
**Trunk's changes:**
- Added `NavigationBlocker` component import and usage
- Added `RouterLinkButton` component for internal navigation
- Replaced `getAddNewDomainUrl()` function with `getAddSiteDomainUrl()` from `domain-url.ts`
- Removed `useDomainConnectionSetupTemplateUrl` and related imports

**Our changes:**
- Replaced `useDomainConnectionSetupTemplateUrl` with `useDashboardRedirectParams()`
- Updated `getAddNewDomainUrl()` to use `buildDashboardRedirectUrl()` and `redirectParams`
- Changed imports to use our unified link utilities

## Resolution Strategy
**Merge both approaches:**
1. Keep trunk's `NavigationBlocker` addition (useful feature)
2. Keep trunk's `RouterLinkButton` for the "Manage domains" link
3. **Use our approach** for `getAddNewDomainUrl()` instead of trunk's `getAddSiteDomainUrl()`

## Steps

1. **Check if this file is in conflict:**
   ```bash
   git status
   ```

2. **Examine the conflict carefully** - this file has significant changes from both sides

3. **Resolve imports section:**
   Keep these imports:
   ```typescript
   import { useState } from 'react';
   import { NavigationBlocker } from '../../app/navigation-blocker';  // FROM TRUNK
   import { ButtonStack } from '../../components/button-stack';
   import { Card, CardBody } from '../../components/card';
   import InlineSupportLink from '../../components/inline-support-link';
   import Notice from '../../components/notice';
   import RouterLinkButton from '../../components/router-link-button';  // FROM TRUNK
   import { isDashboardBackport } from '../../utils/is-dashboard-backport';
   import { buildDashboardRedirectUrl, useDashboardRedirectParams, wpcomLink } from '../../utils/link';  // OUR APPROACH
   ```

   Remove these imports (not needed):
   - `useDomainConnectionSetupTemplateUrl`
   - `getAddSiteDomainUrl` from `domain-url`
   - `redirectToDashboardLink` (we use `buildDashboardRedirectUrl` instead)

4. **In the component, keep our `redirectParams` hook:**
   ```typescript
   const redirectParams = useDashboardRedirectParams();
   ```

5. **Keep our `getAddNewDomainUrl()` function** (not trunk's `getAddSiteDomainUrl`):
   ```typescript
   const getAddNewDomainUrl = () => {
       const backUrl = buildDashboardRedirectUrl( redirectParams );
       if ( isDashboardBackport() ) {
           return addQueryArgs( `/domains/add/${ site.slug }`, { redirect_to: backUrl } );
       }

       return addQueryArgs( wpcomLink( '/setup/domain' ), {
           siteSlug: site.slug,
           back_to: backUrl,
           ...redirectParams,
       } );
   };
   ```

6. **Keep trunk's `NavigationBlocker` in the JSX:**
   ```tsx
   <NavigationBlocker shouldBlock={ isDirty } />
   ```

7. **Keep trunk's `RouterLinkButton` for "Manage domains":**
   ```tsx
   <RouterLinkButton
       variant="secondary"
       to={
           isDashboardBackport()
               ? `/domains/manage/${ site.slug }`
               : `/sites/${ site.slug }/domains`
       }
   >
       { __( 'Manage domains' ) }
   </RouterLinkButton>
   ```

8. **Stage and continue:**
   ```bash
   git add client/dashboard/sites/settings-site-visibility/privacy-form.tsx
   git rebase --continue
   ```

9. **Update PROGRESS.md**

## Next Plan
Proceed to `redirect-poc-05-resolve-billing-files.md`

---

After completing this plan, update `~/.claude/plans/PROGRESS.md` with the status.

You can then run /clear and "/execute-plan redirect-poc-05-resolve-billing-files.md"
