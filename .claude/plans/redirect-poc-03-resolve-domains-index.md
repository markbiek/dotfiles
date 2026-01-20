# Plan: Resolve sites/domains/index.tsx Conflict

## Summary
Resolve conflict in `client/dashboard/sites/domains/index.tsx` - the main domains page.

## Context
**Trunk's changes:**
- Changed import from `useDomainConnectionSetupTemplateUrl` to `getDomainConnectionSetupTemplateUrl`
- Moved import from `../../utils/domain` to `../../utils/domain-url`
- Still passes `domainConnectionSetupUrl` prop to `AddDomainButton`

**Our changes:**
- Removed `useDomainConnectionSetupTemplateUrl` import entirely
- Removed `useAppContext` import
- Simplified `AddDomainButton` to NOT receive `domainConnectionSetupUrl` prop
- The button now handles redirects internally using our unified approach

## Resolution Strategy
**Use our approach** - it's cleaner and doesn't need the template URL hack.

The `AddDomainButton` component in our branch handles the redirect params internally via `useDashboardRedirectParams()`.

## Steps

1. **Check if this file is in conflict:**
   ```bash
   git status
   ```

2. **Examine the conflict markers in the file**

3. **Resolve by keeping our version:**
   - NO import of `getDomainConnectionSetupTemplateUrl` or `useDomainConnectionSetupTemplateUrl`
   - NO import of `useAppContext`
   - `AddDomainButton` receives only `siteSlug` and `redirectTo` props (no `domainConnectionSetupUrl`)

4. **The resolved imports section should look like:**
   ```typescript
   import { usePersistentView } from '../../app/hooks/use-persistent-view';
   import { siteRoute, siteDomainsRoute, siteSettingsRedirectRoute } from '../../app/router/sites';
   // ... other imports, but NOT domain-url or useAppContext
   ```

5. **The AddDomainButton JSX should look like:**
   ```tsx
   actions={ <AddDomainButton siteSlug={ site.slug } redirectTo={ redirectTo } /> }
   ```

6. **The redirectTo variable should be:**
   ```typescript
   const redirectTo = `/sites/${ site.slug }/domains`;
   ```
   (NOT using `basePath` prefix - our system handles that)

7. **Stage and continue:**
   ```bash
   git add client/dashboard/sites/domains/index.tsx
   git rebase --continue
   ```

8. **Update PROGRESS.md**

## Next Plan
Proceed to `redirect-poc-04-resolve-privacy-form.md`

---

After completing this plan, update `~/.claude/plans/PROGRESS.md` with the status.

You can then run /clear and "/execute-plan redirect-poc-04-resolve-privacy-form.md"
