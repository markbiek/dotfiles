---
description: Review current, unstaged changes for issues.
allowed-tools: Bash(git status:*), Bash(git diff), Bash(git log:*), Bash(git diff:*)
---

Do a git diff and review the recent changes. Identify any edge cases that we're missing. Ensure there are no security or performance concerns. Make sure the code is readable and tidy. If there are new tests, review the accuracy and logic of the test suite. Check the tests for over-mocking or logic that doesn't actually test anything.

## Context
- Current git status: !`git status`
- Current git diff (staged and unstaged changes): !`git diff`
