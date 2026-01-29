---
name: calypso-development
description: Calypso (wp-calypso) React/TypeScript development guidance. Use when working in the Calypso monorepo, identified by client/ directory with React components, packages/ directory, or test/e2e/ for E2E tests. Provides coding standards, WordPress component patterns, testing guidance, and PR conventions.
---

# Calypso Development

Calypso is WordPress.com's React/TypeScript frontend monorepo.

## Environment Detection

**Calypso codebase**: Contains `client/`, `packages/`, and uses `@wordpress/*` imports

## Short Codes

Check user messages for these prefixes:
- **ddc** - "discuss don't code" - only discuss, no changes until approved
- **jdi** - "just do it" - proceed with discussed changes
- **cpd** - "create PR description" - generate PR description from branch changes

## Core Principles

1. **Functional React**: No classes, use hooks
2. **WordPress components first**: Use `@wordpress/components`, `@wordpress/element`
3. **Named exports**: Favor named exports for components
4. **i18n ready**: Use `useTranslate` from `i18n-calypso`
5. **Accessibility**: Follow WordPress a11y guidelines

## Code Standards

```typescript
// Use @wordpress/element, not React directly
import { useState } from '@wordpress/element';

// Use clsx, not classnames
import clsx from 'clsx';

// Style import has blank line after it
import './style.scss';

import { Button } from '@wordpress/components';
```

**CRITICAL**: After modifying JS/TS files, run `yarn eslint --fix` on each file.

## Naming & Style

- Variables: `isLoading`, `hasError` (auxiliary verbs)
- Directories: `lowercase-hyphens` (e.g., `auth-wizard`)
- No `&--` or `&__` in SCSS - write full class names
- Use RTL-safe styles: `margin-inline-start` not `margin-left`

## Testing

```bash
# Unit tests
yarn test-client path/to/file

# E2E tests (always use --reporter=list to prevent hanging)
yarn playwright test specs/path/to/test.spec.ts --reporter=list
```

Use `@testing-library` queries from `render()` return, not `screen`.
Prefer `userEvent` over `fireEvent`.
Use `toBeVisible()` over `toBeInTheDocument()`.

## Subdirectory-Specific Rules

- **client/dashboard/**: See [references/dashboard.md](references/dashboard.md) for TanStack Query/Router patterns
- **client/a8c-for-agencies/**: See [references/a4a.md](references/a4a.md) for A4A conventions
- **test/e2e/**: See [references/e2e-tests.md](references/e2e-tests.md) for Playwright migration

## WordPress Imports

See [references/wordpress-imports.md](references/wordpress-imports.md) for available components from:
- `@wordpress/components`
- `@wordpress/block-editor`
- `@wordpress/data`
- `@wordpress/core-data`

## Pull Requests

- Create PRs as **draft**
- Use Linear issue IDs (e.g., `LIN-123`), not full URLs
- Don't mention people's names or link to wordpress.com URLs
- Follow `.github/PULL_REQUEST_TEMPLATE.md`
