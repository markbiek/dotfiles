---
description: Review current, unstaged changes for issues.
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git log:*), Read, Grep, Glob
---

Review unstaged changes and provide a structured code review. Compare it to existing code, and list any feedback, questions, areas of improvement or concerns in markdown format. Deeply research how it interacts with existing code, and raise any potential bugs or performance issues that may arise. Focus on security and WordPress best practices and coding standards.

## Context
- Current git status: !`git status --short`
- Unstaged changes: !`git diff`
- Recent commits for context: !`git log --oneline -5`

## Review Process

1. **Understand the change**: What is this diff trying to accomplish?

2. **Read related files**: Use Read/Grep to examine surrounding code for context. Don't review in isolation.

3. **Provide structured feedback**:

### Summary
Brief description of what changed.

### Issues Found
For each issue, specify:
- **File:line** - Description of the problem
- **Severity**: 🔴 Blocker | 🟡 Should fix | 🔵 Nitpick

### Categories to Check
- **Logic errors**: Edge cases, off-by-ones, null/undefined handling
- **Security**: XSS, injection, auth issues, exposed secrets
- **Performance**: N+1 queries, unnecessary re-renders, missing memoization
- **Readability**: Confusing names, missing context, overly clever code
- **Tests** (if present): Over-mocking, assertions that don't test real behavior, missing edge cases

### Verdict
✅ Good to commit | ⚠️ Needs changes | 🛑 Do not commit

If no issues found, say so briefly—don't invent problems.
