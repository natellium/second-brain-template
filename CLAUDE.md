# Vault Guide

<!--
  SETUP: Replace the placeholders below before your first session.
  - [Your Name]      → your name
  - [Your Company]   → your company or org
  - [Your Role]      → your role (e.g. "Engineering Manager", "Product Manager")
  - Team A / team-a  → your first team's name (slug in lowercase-hyphenated)
  - Team B / team-b  → your second team's name (or remove the second team if you only have one)
-->

This is a personal assistant and second brain for [Your Name], a [Your Role] at [Your Company] overseeing two teams: **Team A** and **Team B**.

This file is automatically loaded into every conversation. Use it to understand the vault structure, conventions, and how to file and navigate notes.

---

## Vault Structure

```
teams/
  team-a/
    strategy.md          # 1-year vision and objectives for Team A
    quarters/
      YYYY-QN.md         # quarterly priority list ([title, goals, GH link, status])
    YYYY-summary.md      # created at year-end, replaces per-quarter files
  team-b/
    strategy.md
    quarters/
      YYYY-QN.md
    YYYY-summary.md

ideas/                   # emerging opportunities and experiments (global pool)
learnings/               # retrospective insights, what worked/didn't

daily-notes/             # daily log — the raw feed, source of most signal
task-board.md            # active to-do list
scratch-pad.md           # staging area for quick notes
meetings/
  raw/                   # raw meeting notes
  summaries/             # processed summaries

reviews/
  weekly/                # output from /review (weekly)
  monthly/               # output from /review (monthly)
  retro/                 # output from /retro (personal) and /quarterly-review (team-facing)

templates/               # use these when creating new notes
  strategy.md
  quarter.md
  idea.md
  learning.md

outputs/                 # produced documents (e.g. Product DNA, analyses)
  team-a/analyses/
  team-b/analyses/
```

---

## Note Conventions

### Frontmatter
Every note uses YAML frontmatter. Key fields:

| Field | Used in | Values |
|-------|---------|--------|
| `type` | all | `strategy`, `quarter`, `idea`, `learning`, `review`, `retro`, `quarterly-review` |
| `team` | ideas, learnings, strategy, quarter | `team-a`, `team-b`, `both` |
| `status` | ideas | `raw`, `explored`, `pursuing`, `archived` |
| `quarter` | quarter files | e.g. `2026-Q2` |
| `updated` | strategy | ISO date — when you last meaningfully revised the strategy |
| `date` / `created` | learnings, ideas | ISO date |

### Linking
Use `[[wikilinks]]` to connect notes. Examples:
- `[[teams/team-a/strategy]]` — link to Team A strategy
- `[[teams/team-b/quarters/2026-Q2]]` — link to a specific quarter
- `[[ideas/2026-03-15-some-idea]]` — link to an idea

### Filing rules
| Content | Goes in |
|---------|---------|
| New idea or opportunity | `ideas/YYYY-MM-DD-{slug}.md` |
| Something learned (insight, pattern, lesson) | `learnings/YYYY-MM-DD-{slug}.md` |
| New quarter's priorities | `teams/{team}/quarters/YYYY-QN.md` |
| Strategy update | `teams/{team}/strategy.md` (update `updated:` field) |
| Weekly review output | `reviews/weekly/YYYY-WNN.md` |
| Monthly review output | `reviews/monthly/YYYY-MM.md` |
| Personal retro | `reviews/retro/YYYY-QN-retro.md` |
| Team quarterly review | `reviews/retro/YYYY-QN-review.md` |

---

## GitHub Integration

Quarter files (`teams/{team}/quarters/YYYY-QN.md`) reference GitHub issues as the source of truth for project status. When running `/brief`, `/quarterly-review`, or `/retro`:

```
gh issue view <url>
```

Use this to fetch live title, status, and recent activity. Do not guess or infer project status from other sources when a GH link is available.

---

## Strategy Authorship

Strategy files are owned by you and updated manually. Claude's role:
- **Read** strategy files to inform briefs, reviews, and retros
- **Surface signals** during `/review` or `/wrap-up` if daily note patterns suggest the strategy may need updating — but never edit strategy files without being asked
- **Help draft** strategy content when explicitly asked

---

## Writing Style

- Concise and structured — bullet points and clear headers over prose
- Use `[[wikilinks]]` for cross-note references
- Frontmatter fields must be filled in — don't leave `team:` or `date:` blank
- Slugs: lowercase, hyphen-separated, descriptive (e.g. `2026-03-15-some-learnings`)
- Don't manufacture notes — only create `learnings/` or `ideas/` files when there's genuine signal

---

## Commands Reference

Commands are defined in `.claude/commands/` as markdown files. Each file matches its slash command name (e.g. `wrap-up.md` → `/wrap-up`).

| Command | File | Purpose |
|---------|------|---------|
| `/start` | `start.md` | Morning standup — loads memory, emails, task board, team context |
| `/process-emails` | `process-emails.md` | Triage unread emails, extract actions |
| `/wrap-up` | `wrap-up.md` | End of day — daily note, task board, second brain update |
| `/review` | `review.md` | Weekly or monthly review — themes, wins, opportunities |
| `/brief [topic]` | `brief.md` | On-demand context brief from the vault |
| `/retro` | `retro.md` | Personal quarterly retrospective |
| `/quarterly-review` | `quarterly-review.md` | Team-facing quarterly review against goals |
| `/summarise-meetings` | `summarise-meetings.md` | File loose meeting notes into the vault |
