---
name: snap-post
description: Generate biweekly SNAP status posts for the Quake team. Use when asked to generate, write, or draft a SNAP post, or when invoking /snap-post. Gathers activity from Linear, GitHub (Calypso + wpcom), Slack (#dotcom-slack), and quakep2 P2, groups by Linear project, and produces a markdown draft.
---

# SNAP Post Generator

Generate a biweekly SNAP post by gathering team activity from multiple sources, grouping by Linear project, and writing a markdown draft.

## Team Roster

Team members and their identifiers across systems:

| Name     | GitHub.com | github.a8c.com | Linear Display Name      | Slack ID    |
|----------|------------|----------------|--------------------------|-------------|
| Mark     | markbiek   | TODO           | markbiek                 | U02P8T5JWF9 |
| Luis     | zaguiini   | zaguiini       | luis.felipe.zaguini      | U027412KDAQ |
| Leonardo | leonardost | leotaba        | leonardo.taba            | U01DZTXSCRE |
| Paulo    | paulopmt1  | paulopmt1      | paulopmt1                | U02RDMUMUBV |
| Kamen    | hambai     | hambai         | kamen                    | U14QFJERY   |
| Igor     | gius80     | gius80         | igor.giussani            | U026F91K9PC |

The Quake team project view can be found in Linear at https://href.li/?https://linear.app/a8c/view/quake-projects-46e0ebb4de73.

Update this table when team membership changes.

## Workflow

### Step 0: Determine Date Range

- Default: last 14 days from today
- If the user specifies a date range, use that instead
- Calculate `start_date` and `end_date`

### Step 1: Gather Data

Collect data from all sources. Parallelize where possible using subagents.

#### 1a. Linear Issues and Projects

Use the context-a8c MCP provider:

1. Load the `linear` provider

**Team-based queries:** Fetch issues from the team's primary Linear teams. The Quake team's issues live across multiple team keys — currently `DOMENG` (Domains Engineering) and `DOMAINS`. Run these in parallel:

2. Fetch team issues: `team-issues` with `team: "DOMENG"` and `days` matching the date range
3. Fetch team issues: `team-issues` with `team: "DOMAINS"` and `days` matching the date range
4. Fetch active projects: `projects` with `team: "DOMENG"`

**Per-assignee queries (cross-team):** Team members may also have issues in other Linear teams (e.g., DOTCOM, VIDP, A8CRTR). To catch these, query issues by assignee for each team member using their Linear display name:

5. For each team member, fetch: `search` with `query: "assignee:<Linear Display Name>"` and `days` matching the date range. Note: the `issues` tool requires UUID assignee IDs; `search` with `assignee:` prefix accepts display names and works across all teams.
6. Deduplicate issues that were already returned by the team-based queries (match by identifier)

Record each issue's project, title, status, assignee, and identifier (e.g., DOMENG-123).

Note: If the team's primary Linear team keys change, update steps 2-4 accordingly.

#### 1b. GitHub PRs (Calypso)

For each team member's GitHub.com username:

```bash
gh pr list --repo Automattic/wp-calypso --author <username> --state merged --search "merged:>=<start_date>" --json title,url,body,mergedAt --limit 100
```

#### 1c. GitHub PRs (wpcom)

For each team member's github.a8c.com username:

```bash
GH_HOST=github.a8c.com gh pr list --repo Automattic/wp-calypso --author <username> --state merged --search "merged:>=<start_date>" --json title,url,body,mergedAt --limit 100
```

Note: Adjust the repo name if wpcom PRs live in a different repository. The `GH_HOST` env var tells `gh` to use the enterprise instance.

#### 1d. Slack Daily Statuses

Use the context-a8c MCP provider:

1. Load the `slack` provider
2. For each team member, search: `search` with `query: "from:<slack_id> in:#dotcom-slack"` and `days` matching the date range
3. These messages provide day-to-day narrative context

#### 1e. quakep2 P2 Posts

Use the context-a8c MCP provider:

1. Load the `wpcom` provider
2. Fetch posts: `posts-search` with `wpcom_site: "quakep2.wordpress.com"` and filter to the date range
3. These may contain discussions, decisions, or announcements

### Step 2: Cross-Reference Items

Match PRs and Slack messages to Linear issues:

- Look for Linear issue identifiers (e.g., `DOMENG-123`, `DOMAINS-456`) in PR titles, branch names, and PR descriptions
- Look for issue identifiers mentioned in Slack messages
- Items that match a Linear issue get grouped under that issue's project
- Items with no match go into the catch-all bucket

### Step 3: Build Topic Groups

1. Group all matched items by their Linear project
2. Within each project group, combine the Linear issues, PRs, and Slack context
3. Collect all unmatched items into the catch-all group
4. Drop any projects with trivial activity (use judgment — a single minor PR might fold into catch-all)

### Step 4: Generate the Markdown Draft

Write the output file to `/tmp/snap-post-YYYY-MM-DD.md`.

#### Structure

```markdown
# Quake snaps: [Topic 1], [Topic 2], [Topic 3]

This update covers [Month Day]–[Month Day], [Year]

## [Project/Topic Name]

[Narrative paragraph describing what the team accomplished in this area.
Mention team members by first name. Include inline links to PRs and
Linear issues naturally in the prose.]

## [Next Project/Topic Name]

[Another narrative paragraph...]

## Bug fixing, fine tuning and improvements

- [Bullet point for each catch-all item, with links where applicable]
- [Another item]

+snapsp2 #snaps
```

#### Style Guide

- Write in **third person, past tense** ("Mark shipped...", "Luis delivered...")
- Keep paragraphs **concise but informative** — 3-6 sentences per section
- **Link to PRs and Linear issues inline** — e.g., "shipped the [billing updates](https://github.com/...)"
- Do NOT link to Slack messages
- The title should list 3-4 of the most significant topics, comma-separated
- The catch-all section uses bullet points, not prose
- End with `+snapsp2 #snaps` on its own line

See `references/snap-example.md` for a concrete example of the expected tone and format.

### Step 5: Present the Result

After writing the file:

1. Display the file path
2. Show a brief summary: how many sections, how many total items, any items that seemed ambiguous in grouping
3. Remind the user to review and edit before posting
