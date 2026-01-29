---
name: wpcom-development
description: WordPress.com monolith development guidance. Use when working in the wpcom codebase (public_html directory with lib/ and wp-content/ directories), when current user is wpdev (sandbox), or when explicitly working on WordPress.com backend tasks. Provides codebase navigation, coding standards, testing, and sandbox environment guidance.
---

# WordPress.com Development

The wpcom monolith is a massive WordPress multisite serving tens of millions of sites.

## Environment Detection

**Wpcom codebase**: public_html directory containing lib/ and wp-content/
**Sandbox**: Current user is `wpdev`

## Codebase Structure

```
wp-content/
├── mu-plugins/     # Must-use plugins (always loaded)
├── plugins/        # Site-specific plugins
├── lib/            # Shared libraries
├── rest-api-plugins/  # v2 REST API (default for new endpoints)
├── themes/         # pub/, premium/, a8c/ subdirs

public.api/         # Older REST endpoints
bin/                # Dev tools, tests, scripts
bin/tests/api-v2/   # REST API tests
bin/tests/isolated/ # Fast WordPress-dependent tests (preferred)
```

## Core Principles

1. **WordPress patterns first**: Prefer filters, actions, hooks, `$wpdb` over heavy OOP or DI
2. **Never edit core**: wp-includes/, wp-admin/, wp-*.php - use filters/actions instead
3. **Avoid side effects**: Changes should be isolated
4. **Existing solutions**: Reuse before creating new
5. **Minimal changes**: No unnecessary abstractions
6. **Always add tests**: See references/sandbox.md for running tests

## Security Requirements

- Escape late: `esc_*` functions, prefer escaping over sanitization
- Sanitize early if needed
- Use `$wpdb->prepare()` for queries
- Nonces for forms
- Proper authentication on API endpoints
- Secrets only in `.config/secrets/` or `.config/secrets.php`

## Performance

- Thousands of requests/second, tens of millions of rows
- Cache results, optimize queries
- No new services - reuse existing infrastructure
- No public cloud services

## Sandbox Environment

See [references/sandbox.md](references/sandbox.md) for:
- Write-limited mode and production writes
- Running tests
- Linting and code quality
- Linear CLI integration
- Troubleshooting

## Coding Standards

See [references/php-standards.md](references/php-standards.md) for WordPress PHP coding standards.

## Deploy Safety

Non-atomic deploys can cause fatal errors. When changes delete files AND remove corresponding requires, warn user and run wpcom-deploy-safety skill.

Link: https://fieldguide.automattic.com/atomicity-in-the-wordpress-com-deploy-system/
