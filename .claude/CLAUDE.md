## Documentation References
@~/.claude/docs/PERSONALIZATION.md
@~/.claude/docs/JS_CODING_STANDARDS.md

## Skills Index
Available skills and when to invoke them

### Workflow Skills
- `/create-commit` — Create a git commit
- `/create-pr` — Create a PR
- `/update-pr` — Update an existing PR with recent commits
- `/create-plans` — Create implementation plans
- `/execute-plan` — Execute an existing implementation plan
- `/review-diff` — Review current unstaged changes for issues
- `/check-deploy-safety` — Check changeset for mid-deploy fatal risks
- `/linear-solve` — Get a summary of a Linear issue
- `/keybindings-help` — Customize keyboard shortcuts and keybindings

### Domain Skills
- `/calypso-development` — Calypso React/TypeScript frontend: coding standards, component patterns, testing, PR conventions
- `/wpcom-development` — WordPress.com monolith backend: codebase navigation, coding standards, testing, sandbox
- `/wpcom-deploy-safety` — Check PHP changesets for mid-deploy fatal risks on WordPress.com
- `/investigate` — Hypothesis-driven investigation: generate hypotheses, test with data, rank by evidence, challenge winners, save results
- `/skill-creator` — Create or edit skills that extend Claude's capabilities
- `/snap-post` — Generate biweekly SNAP status posts for the Quake team

### Superpowers
- `brainstorming` — Before any creative work: features, components, modifications
- `test-driven-development` — Before writing implementation code
- `systematic-debugging` — When encountering bugs, test failures, or unexpected behavior
- `writing-plans` — When have spec/requirements for multi-step task
- `executing-plans` — When executing a written plan in a separate session
- `subagent-driven-development` — When executing plans with independent tasks in current session
- `dispatching-parallel-agents` — When facing 2+ independent tasks with no shared state
- `using-git-worktrees` — When starting feature work that needs isolation
- `requesting-code-review` — When completing tasks or before merging
- `receiving-code-review` — When receiving code review feedback before implementing suggestions
- `finishing-a-development-branch` — When implementation is complete and ready to integrate
- `verification-before-completion` — Before claiming work is complete or creating PRs
- `writing-skills` — When creating or editing skills
- `using-superpowers` — Establishes how to find and use skills
