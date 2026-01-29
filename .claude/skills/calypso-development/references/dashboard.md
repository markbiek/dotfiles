# Dashboard Development (client/dashboard/)

Modern React patterns with TanStack Query and TanStack Router.

## Documentation

Refer to `client/dashboard/docs/`:
- `data-library.md` - TanStack Query, loaders, caching
- `ui-components.md` - WordPress components, placeholders, DataViews
- `router.md` - TanStack Router patterns, lazy loading
- `i18n.md` - Translation patterns, CSS logical properties
- `typography-and-copy.md` - Capitalization, snackbar messages
- `testing.md` - Testing strategies

## External Link Handling

All URLs to old WordPress.com/Calypso MUST use `wpcomLink()`:

```typescript
import { wpcomLink } from '@automattic/dashboard/utils/link';

// ✅ Correct
<a href={ wpcomLink( '/me/security' ) }>Security Settings</a>

// ❌ Wrong - hardcoded or relative
<a href="https://wordpress.com/me/security">...</a>
<a href="/me/security">...</a>
```

Links to `/checkout` must have `redirect_to` and `cancel_to` params.
Links to `/setup/plan-upgrade` must have `cancel_to` param.

## Mutation Callbacks

Attach `onSuccess`/`onError` to `mutate()` call, NOT `useMutation()`:

```typescript
// ✅ Correct - component-specific callbacks on mutate
const { mutate: saveSetting } = useMutation( saveSettingMutation() );

const handleSave = () => {
  saveSetting( newValue, {
    onSuccess: () => setShowSuccessMessage( true ),
    onError: ( error ) => setError( error.message ),
  } );
};

// ❌ Wrong - overrides query option callbacks, breaks cache updates
const { mutate } = useMutation( {
  ...saveSettingMutation(),
  onSuccess: () => setShowSuccessMessage( true ),
} );
```

## Typography and Copy

- **Sentence case** for buttons, labels, headings
- **Periods** on sentences, NOT on buttons/labels
- **Curly quotes** ("like this") and apostrophes (it's)
- "Hosting Dashboard" capitalized as proper noun

```typescript
// ✅ Correct
<Button>Save changes</Button>  // No period, sentence case
<p>Your settings have been saved.</p>  // Period

// Snackbar patterns
`SSH access enabled.`
`Failed to save PHP version.`

// ❌ Wrong
<Button>Save Changes.</Button>  // Title case, has period
```
