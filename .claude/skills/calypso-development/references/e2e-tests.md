# E2E Tests (test/e2e/)

## Framework Migration

Migrating from legacy (Playwright + Jest) to Playwright Test.

| | Legacy | New (Playwright Test) |
|---|---|---|
| Files | `specs/**/*.ts` | `specs/**/*.spec.ts` |
| Docs | `docs/` | `docs-new/` |
| Status | Deprecated | Target for new tests |

**Always write new tests as `.spec.ts` files.**

## Running Tests

```bash
# Playwright Test (.spec.ts) - ALWAYS use --reporter=list
yarn playwright test specs/path/to/test.spec.ts --reporter=list

# Legacy (.ts without .spec)
yarn test specs/path/to/test.ts
```

Without `--reporter=list`, failed tests hang waiting for HTML report.

## Test Structure

```typescript
// Legacy → New
import { tags, test, expect } from '../../lib/pw-base';

test.describe( 'Test Suite', { tag: [ tags.TAG_NAME ] }, () => {
  test( 'As a user, I can do something', async ( { page } ) => {
    await test.step( 'Given precondition', async function () {
      // setup
    } );
    await test.step( 'When I take action', async function () {
      // action
    } );
    await test.step( 'Then I see result', async function () {
      // assertion
    } );
  } );
} );
```

## Fixtures

**Accounts**: `accountDefaultUser`, `accountGivenByEnvironment`, `accountAtomic`, `accountGutenbergSimple`, `accounti18n`, `accountPreRelease`, `accountSimpleSiteFreePlan`, `accountSMS`

**Pages/Components**: `page*` (e.g., `pageLogin`), `component*` (e.g., `componentSidebar`), `flow*`

**Clients**: `clientEmail`, `clientRestAPI`

**Other**: `secrets`, `environment`, `pageIncognito`, `sitePublic`

## Authentication

```typescript
// Legacy
const testAccount = new TestAccount( 'accountName' );
await testAccount.authenticate( page );

// New - use fixtures
test( 'Test', async ( { accountDefaultUser, page } ) => {
  await accountDefaultUser.authenticate( page );
} );
```

## Skip Conditions

```typescript
test( 'Test', async ( { environment } ) => {
  test.skip( environment.TEST_ON_ATOMIC, 'Reason for skipping' );
} );
```

## Key Docs

- `test/e2e/docs-new/overview.md`
- `test/e2e/docs-new/new_style_guide.md`
- `test/e2e/docs-new/custom_fixtures.md`
