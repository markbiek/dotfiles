# Plan: Hide "Change site address" action for garden sites

## Summary
Hide the "Change site address" action in the domains DataViews when the site is a garden site.

## Analysis

### Current behavior
The "Change site address" action is shown for sites that:
1. Have a site object (`!! site`)
2. Are NOT Atomic sites (`! site?.is_wpcom_atomic`)
3. Have a default address domain (`item.subtype.id === DomainSubtype.DEFAULT_ADDRESS`)

### Garden site detection
- Sites have an `is_garden` boolean property
- Utility function `isGarden(site)` exists in `client/dashboard/utils/site-types.ts`
- Other site type checks in the codebase already exclude garden sites (e.g., `isSelfHostedJetpackConnected`, `isSimple`)

## Implementation

### File to modify
`client/dashboard/domains/dataviews/actions.tsx` (line 251)

### Change
Add `! site.is_garden` to the `isEligible` condition:

```typescript
// Before (line 248-252)
isEligible: ( item: DomainSummary ) => {
    const site = sitesByBlogId[ item.blog_id ];
    return (
        !! site && ! site?.is_wpcom_atomic && item.subtype.id === DomainSubtype.DEFAULT_ADDRESS
    );
},

// After
isEligible: ( item: DomainSummary ) => {
    const site = sitesByBlogId[ item.blog_id ];
    return (
        !! site &&
        ! site?.is_wpcom_atomic &&
        ! site.is_garden &&
        item.subtype.id === DomainSubtype.DEFAULT_ADDRESS
    );
},
```

## Notes
- Using `! site.is_garden` directly matches the pattern used for `! site?.is_wpcom_atomic` in the same condition
- No need to import the `isGarden()` utility since direct property access is consistent with existing code
