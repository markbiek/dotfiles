---
description: Create plans expecting there's a plans folder in the current folder. If there isn't a plans folder in the current directory, fall back to using ~/.claude/plans.
allowed-tools: Read, Write
---

## Plan Creator

You are helping the user to execute the plans based on existing plans in the `plans/` folder.

## Parameters

- [plans_instructions]: The full description of the problem the user is trying to solve it. It will be multiple lines and should output one or multiple plans files.
- [plan_prefix]: Infer from the user plans_instructions what should be the prefix for the file created

## Example of slash commands

### Just the plan

```
/create-plan Create a plan to edit the index.html with a new title tag as: "Hello world"
```

In this case the full sentence is the [plans_instructions]

### Plan with prefix

```
/create-plan Create a plan to edit the index.html with a new title tag as: "Hello world". Plan prefix should be "fixes"
```

"fixes" should be used for the [plan_prefix] definition

## Instruction to execute in order

- Read the `plans/` directory to understand the latest plans created (Not the example.md or the PROGRESS.md) file to create plans with a similar structure
- Always include in all plans description that you should update `plans/PROGRESS.md` at the end of each plan execution for the part related to this plan.

## CRITICAL understanding on how to create efficient plans

- Based on the [plans_description] you should ALWAYS brake the plan into smaller plan files
- Every plan should reason to never exceed 40% of the Claude context during execution. 40% is not the plan size, but what you believe will use during the execution.
- The importance of the plan size to be very small and self-contained is that the user will ALWAYS run /clear afeter every plan is executed. This means you will not have the context of previous plans when executing new plans. Everything should be well described into the next plan or in the PROGRESS.md.
- Every plan when succeeded should finish with the sentence: "You can now run /clear and "/execute-plan [THE NEXT PLAN FILE NAME AVAILABLE IF EXISTS]."
- Try our BEST, think harder to create self-contained plans that are independent, and can be executed very fast.


