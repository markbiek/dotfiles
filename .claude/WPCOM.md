---
alwaysApply: true
---
# WordPress.com Codebase

This is the WordPress.com (wpcom) monolithic codebase - a massive WordPress multisite installation serving tens of millions of sites. The repository contains the core single-tenant WordPress.com platform, usually as WordPress plugins, CLI tools, and tests.

## Files Overview

Most of the code is in the `wp-content/` directory:
  - `mu-plugins/` - Must-use plugins (always loaded), all top-level files are always loaded
  - `plugins/` - Plugins enabled only on certain sites
  - `themes/` - WordPress themes (pub/, premium/, a8c/ subdirectories, in separate repositories)
  - `lib/` - Shared libraries
  - `rest-api-plugins/` - v2 REST API endpoints, the default location for new REST API endpoints

Public APIs:
- `public.api/` - Older REST APIendpoints and one-off APIs are here, newer are in `wp-content/rest-api-plugins/`

Core WordPress files:
- `wp-includes/` - WordPress core files
- `wp-admin/` - WordPress admin files
- `wp-*.php` - WordPress core files in root directory

Tests:

- **API tests**: `bin/tests/api-v2/` for REST API testing
- **Isolated WordPress tests**: `bin/tests/isolated/` for tests that depend on core WordPress functionality and database, even if they look like integration tests, they are still very fast and preferred in most situations, outside of API tests
- **Unit tests**: The rest of `bin/tests/` is for various unit test suites

- **bin/** - Development tools, scripts, and utilities:
  - Testing frameworks and test suites
  - Build tools (SCSS compilation, JS bundling)
  - Deployment scripts and git hooks  
  - Code quality tools (phpcs, linting)
  - Import/export utilities
  - WordPress.com-specific tooling

More:
- **async-jobs/** - Asynchronous job processing system
- **atomic.api/** - Atomic hosting platform API

## Important Rules

Follow these rules before writing any code and before trying to make sense of the codebase yourself.

- Prefer WordPress-specific patterns, principles, and coding standards. Good examples are filters, actions, hooks, using WordPress data retrieval functions, internal WordPress data  storage, `$wpdb` for database queries, etc. versus typical PHP patterns like heavy OOP, dependency injection, custom database tables, etc.
- NEVER edit core WordPress files directly, if you need to edit functionality in a core file, look for a filter or an action that can achieve the same result. If you can't do that, tell the user explicitly to find a solution.
- Make special effort to make sure the code changes won't have inadvertent side effects on other parts of the codebase.
- Strongly prefer existing solutions over novel ones.
- Avoid making changes that are not strictly necessary or adding abstractions that are trying to solve a problem that doesn't exist yet.
- If the change is not trivial, ask the user for more context and start with a plan for the implementation before writing any code.
- ALWAYS try adding tests for the change, if you can't, ask the user for help. Look at the `sandbox.mdc` file for more information on how to run the tests.
- Deployment on WordPress.com is not atomic, because of opcache usage. If a change both deletes a file and removes the corresponding `require`/`require_once`/`import` warn the user and send them a link to https://fieldguide.automattic.com/atomicity-in-the-wordpress-com-deploy-system/ to avoid fatal errors during deployment.


## Performance and Scalability

- WordPress.com handles thousands of requests per second and often datasets are in the tens of millions of rows. Take this into account when making changes, make sure database queries and remote requests are optimized, whenever possible cache the results.
- Avoid suggesting new services (like databases, caches, queue managers, etc.), reuse existing ones that you find in the codebase, operational simplicity is an important aspect of keeping the services scalable.
- We run almost everything on our own infrastructure, so avoid suggesting public cloud services.

## Security

- Security is of a paramount importance!
- All code must follow WordPress security best practices.
- Proper data sanitization and escaping required, prefer WordPress functions like `esc_*`, nonces, `$wpdb->prepare()` over standard PHP or custom ones. Prefer escaping over sanitization. Escape data as late as possible, if ever needed to sanitize, sanitize early.
- API endpoints must implement proper authentication.
- Typical security issues to look out and avoid: authentication bypass, XSS, CSRF, SQL injection, misuse of encryption.
- If a change is looking like having wider security implications, nudge the user to ask the secops team for a review.
- Sensitive data (API keys, credentials) must live only in the `.config/secrets/` directory or in `.config/secrets.php` file, don't add secrets anywhere else.

## Development Process

See @.rules/sandbox.mdc and @.rules/local.mdc for running tests and other development commands on the sandbox development environment or locally.

## Coding Standards

See @.rules/wordpress-coding-standards-php.mdc and @.rules/wordpress-coding-standards-javascript.mdc for WordPress.com PHP and JavaScript coding standards.
