# Sandbox Development Environment

**Important**: The sandbox uses production data. Execute commands with extra care when not in write-limited mode.

## Write-Limited Mode

By default, the sandbox cannot write to database, caches, or make outbound connections.

```bash
bin/allow-sandbox-production-writes     # Enable full access
bin/allow-sandbox-production-writes 0   # Return to write-limited
```

## Code Quality

```bash
bin/php-lint    # Check PHP syntax
bin/phpcbf      # Auto-fix coding standard violations
bin/eslint      # JavaScript linting
```

## WordPress.com Tools

```bash
bin/wp --url=example.wordpress.com [command]  # WP-CLI for specific site
bin/jetpack-downloader                         # Download Jetpack releases
bin/jetpack-sun-moon                          # Jetpack deployment
```

## GitHub Integration

```bash
gh pr checkout 353    # Checkout PR by number
```

## Linear CLI

```bash
bin/wp linear get ARTPI-4                           # Get issue by ID (JSON)
bin/wp linear get ARTPI-4 --format=markdown         # Get issue as markdown
bin/wp linear get 'https://linear.app/...'          # Get issue by URL
```

Returns: title, description, status, assignee, labels, comments.

## Running Tests

Run from the test type's root directory with suite name from phpunit.xml:

```bash
cd bin/tests/isolated/
phpunit --testsuite=likestests
```

**API tests**: `bin/tests/api-v2/`
**Isolated tests**: `bin/tests/isolated/` (fast, preferred for most cases)

If tests stop at "installing", check `/tmp/php-errors`.

## Troubleshooting

- **Application logs**: `/tmp/php-errors`
- **Not sandboxed?**: May be getting production data
- **Write-limited?**: Cannot write to DB or make outbound connections

More help: https://fieldguide.automattic.com/sandboxes/
