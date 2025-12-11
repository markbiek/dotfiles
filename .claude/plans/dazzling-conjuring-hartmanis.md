# Plan: Add `garden` parameter to domainsQuery for CIAB

## Goal
1. Update the `/all-domains` API call to pass `garden=commerce` only when on the `/ciab/domains` dashboard page.
2. Remove the `DEFAULT_ADDRESS` filter for CIAB so `.commerce-garden.com` domains are shown.

## Approach
Follow the existing pattern used for `sitesQuery`, `dashboardSiteListQuery`, and `dashboardSiteFiltersQuery` - add `domainsQuery` to the `AppConfig.queries` interface so each app can configure it with app-specific parameters.

## Files to Modify

### 1. `packages/api-core/src/domains/fetchers.ts`
Update `fetchDomains` to accept an optional `garden` parameter:

```typescript
import { addQueryArgs } from '@wordpress/url';

export interface FetchDomainsOptions {
  garden?: string;
}

export async function fetchDomains( options: FetchDomainsOptions = {} ): Promise< DomainSummary[] > {
  const { garden } = options;
  const queryArgs = garden ? { garden } : {};
  const { domains } = await wpcom.req.get( {
    path: addQueryArgs( '/all-domains', queryArgs ),
    apiVersion: '1.2'
  } );
  return domains;
}
```

### 2. `packages/api-queries/src/domains.ts`
Update `domainsQuery` to accept and pass through the options:

```typescript
import type { FetchDomainsOptions } from '@automattic/api-core';

export const domainsQuery = ( options: FetchDomainsOptions = {} ) =>
  queryOptions( {
    queryKey: [ 'domains', options ],
    queryFn: () => fetchDomains( options ),
  } );
```

### 3. `client/dashboard/app/context.tsx`
Add `domainsQuery` to the `AppConfig.queries` interface:

```typescript
import { domainsQuery } from '@automattic/api-queries';
import type { FetchDomainsOptions } from '@automattic/api-core';

// In AppConfig.queries:
domainsQuery: () => ReturnType< typeof domainsQuery >;

// In APP_CONTEXT_DEFAULT_CONFIG.queries (with DEFAULT_ADDRESS filter):
domainsQuery: () => ( {
  ...domainsQuery(),
  select: ( data ) => data.filter( ( domain ) => domain.subtype.id !== DomainSubtype.DEFAULT_ADDRESS ),
} ),
```

### 4. `client/dashboard/app-ciab/index.tsx`
Configure `domainsQuery` to pass `garden: 'commerce'` and NOT filter out DEFAULT_ADDRESS:

```typescript
import { domainsQuery } from '@automattic/api-queries';

// In queries config (no select filter = show all domains including default addresses):
domainsQuery: () => domainsQuery( { garden: 'commerce' } ),
```

Note: CIAB will show all domains including `.commerce-garden.com` default addresses.

### 5. `client/dashboard/app-dotcom/index.tsx`
Add `domainsQuery` with DEFAULT_ADDRESS filter (same as default config):

```typescript
import { domainsQuery } from '@automattic/api-queries';
import { DomainSubtype } from '@automattic/api-core';

// In queries config:
domainsQuery: () => ( {
  ...domainsQuery(),
  select: ( data ) => data.filter( ( domain ) => domain.subtype.id !== DomainSubtype.DEFAULT_ADDRESS ),
} ),
```

### 6. `client/dashboard/domains/index.tsx`
Update to use `queries.domainsQuery()` from context instead of direct import, and move the `DEFAULT_ADDRESS` filter into the query configuration:

```typescript
// Change from:
import { domainsQuery } from '@automattic/api-queries';
const { data: domains } = useQuery( {
  ...domainsQuery(),
  select: ( data ) => data.filter( ( domain ) => domain.subtype.id !== DomainSubtype.DEFAULT_ADDRESS ),
} );

// To:
const { queries } = useAppContext();
const { data: domains } = useQuery( queries.domainsQuery() );
```

The `select` filter logic moves to the app config so each app can decide whether to filter DEFAULT_ADDRESS.

### 7. `client/dashboard/app/router/domains.ts`
Update route loader to use context-aware query:

```typescript
// Change prefetch from direct domainsQuery() to context-aware version
loader: async ( { context } ) => {
  await queryClient.ensureQueryData( context.config.queries.domainsQuery() );
  // ...
}
```

## Additional Considerations

- **Query Key**: Including `options` in the query key ensures CIAB and dotcom domains are cached separately
- **Cache Invalidation**: `bulkDomainsActionMutation` in `packages/api-queries/src/domains.ts` uses `domainsQuery().queryKey` for invalidation - will need to use partial key match `['domains']` to invalidate all variants
- **Export FetchDomainsOptions**: Ensure `FetchDomainsOptions` is exported from `@automattic/api-core` package index

## Summary of Changes

| File | Change |
|------|--------|
| `packages/api-core/src/domains/fetchers.ts` | Add `FetchDomainsOptions` interface, update `fetchDomains` to accept `garden` param |
| `packages/api-queries/src/domains.ts` | Update `domainsQuery` to accept options, include in queryKey |
| `client/dashboard/app/context.tsx` | Add `domainsQuery` to `AppConfig.queries` interface and default config |
| `client/dashboard/app-ciab/index.tsx` | Add `domainsQuery` with `garden: 'commerce'`, no DEFAULT_ADDRESS filter |
| `client/dashboard/app-dotcom/index.tsx` | Add `domainsQuery` with DEFAULT_ADDRESS filter |
| `client/dashboard/domains/index.tsx` | Use `queries.domainsQuery()` from context, remove inline select filter |
| `client/dashboard/app/router/domains.ts` | Use `context.config.queries.domainsQuery()` in loader |
