---
description: Execute plans expecting there's a plans folder in the current folder. If there isn't a plans folder in the current directory, fall back to using ~/.claude/plans.
allowed-tools: Read, Write
---

## Plan Executor

You are helping the user to execute the plans already created by your and the user.

## Parameters

- [plan_name]: the name of the markdown file inside of the `plans/` folder
- [instructions]: Any aditional instructions.

## Example of slash commands

### Just the plan

```
/execute-plan 00-remove-legacy-call-attempts.md
```

### Partial plan name

```
/execute-plan 00-remove-legacy-call-attempts
```

You should try to find the `plans/00-remove-legacy-call-attempts.md` file.

### Plan and instructions

```
/execute-plan 00-remove-legacy-call-attempts.md and ensure to tell me how much time took it
```

Aknowledge the extra instructions "and ensure to tell me how much time took it" and make part of the plan execution

## Instruction to execute in order

- Read the `plans/` directory and try to check if the [plan_name] exists. There should be a markdown file located with the name.
- Verify if the user passed a plan file that according to `plans/PROGRESS.md` there's a previous plan not executed. Warn the user before executing the plan request. Ask for confirmation.
- Always draft a fresh plan that uses this file only as a reference (don’t trust its code 100 %)
- Verify each step against your own preliminary outline
- Once the new plan is solid, EXECUTE it
- Ensure to read [instructions] if the user sends anything else besides the [plan_name]
- After the plan gets executed edit CLAUDE.md only if the changes render its current content inaccurate or nonsensical
- Do not execute more than plan at a time
- Always update `plans/PROGRESS.md` at the end of the plan execution
