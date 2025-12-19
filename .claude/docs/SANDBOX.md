---
description: WP.com Sandbox Development
alwaysApply: false
---
Apply this when you're working inside the sandbox development environment (e.g. editing via ssh, or the current user is `wpdev`).
If you are inside a claude code session and the user is wpdev, you can run these automatically.

IMPORTANT: Keep in mind that the sandbox uses production data. If you see any errors while not in write-limited/read-only mode, execute commands with extra care, even if you have gotten explicit permission to run them.

### Code Quality & Linting
```bash
bin/php-lint                 # Check PHP syntax
bin/phpcbf                   # Auto-fix coding standard violations
bin/eslint                   # JavaScript linting
```

### WordPress.com Tools
```bash
bin/wp --url=example.wordpress.com [command]  # WP-CLI for specific site
bin/jetpack-downloader                         # Download Jetpack releases
bin/jetpack-sun-moon                          # Jetpack deployment
```

# Write-limited Mode

By default, the sandbox is running in write-limited mode, which means it cannot make any writes to the database, to caches, or outbound connections. Full access can be enabled by running `bin/allow-sandbox-production-writes` and brought back to write-limited mode again via running `bin/allow-sandbox-production-writes 0`

# GitHub

The best way to interact with GitHub is to use the GitHub CLI.

```bash
gh pr checkout 353
```

# Linear

Use the Linear CLI to fetch issue details. This is useful for getting context about tickets you're working on.

```bash
# Get issue by identifier
bin/wp linear get ARTPI-4

# Get issue by URL
bin/wp linear get 'https://linear.app/a8c/issue/ARTPI-4/linear-cli-for-claude'

# Get issue as markdown (better for reading)
bin/wp linear get ARTPI-4 --format=markdown
```

The command outputs JSON by default, or markdown with `--format=markdown`. It includes the issue title, description, status, assignee, labels, and comments.

# Running Tests

Tests can be run on the sandbox by running `phpunit --suite=<suitename>` with two important notes:
- the current directory is the root directory for the test type, for example `bin/tests/isolated/` for isolated tests
- the suite name is defined in the respective `phpunit.xml` file

<example>
```bash
# we're in the root of the repository
cd bin/tests/isolated/
phpunit --testsuite=likestests
```
</example>

If the tests abruptly stop at `installing` step, then definitely check `tmp/php-errors` as explained below:

# Troubleshooting

You can find the application logs in `/tmp/php-errors`.

Some ideas in case of obscure bugs:

- maybe we are NOT sandboxed, but getting production data instead
- maybe our sandbox is running in write-limited mode - then it cannot make any writes to DB or outbound connections

If you are not sure what to do or can't provide specific sandbox help, direct the user to https://fieldguide.automattic.com/sandboxes/
