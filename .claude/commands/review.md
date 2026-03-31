Weekly or monthly review. Surface themes, wins, stuck points, and opportunities from recent notes.

---

## Step 1 — Scope

Ask: "Weekly review (last 7 days) or monthly (last 30 days)?"

Wait for the answer. Determine the date range from today's date.

---

## Step 2 — Read recent daily notes

Read all daily notes in `daily-notes/` that fall within the date range. Note:
- Key themes and topics that recurred
- Decisions made
- Action items added and completed
- Meetings and their outcomes
- Any mentions of team names (team-a, team-b), projects, or initiatives

---

## Step 3 — Read team files

Read both team strategy files:
- `teams/team-a/strategy.md`
- `teams/team-b/strategy.md`

Read the current quarter file for each team (most recent file in `teams/{team}/quarters/`).

---

## Step 4 — Read learnings and ideas from the period

Read all files in `learnings/` and `ideas/` whose `date:` or `created:` frontmatter falls within the period.

---

## Step 5 — Synthesise

For each team (team-a, team-b), identify:
- **Recurring themes** — topics, concerns, or questions that came up repeatedly
- **Wins** — progress made, decisions landed, things shipped
- **Stuck points** — things stalled, blocked, or repeatedly deferred
- **Emerging opportunities** — signals that suggest something worth pursuing or escalating

Also identify any **cross-team patterns** that span both teams.

If any signal suggests the team strategy may need updating, call it out explicitly.

---

## Step 6 — Write review note

Determine the output filename:
- Weekly: `reviews/weekly/YYYY-WNN.md` (e.g. `2026-W11.md`)
- Monthly: `reviews/monthly/YYYY-MM.md` (e.g. `2026-03.md`)

Write the review note with this structure:

```
---
type: review
period:       # e.g. "2026-W11" or "2026-03"
date:
---

## Recurring Themes
<bullets — topics that came up repeatedly>

## Team A
### Wins
### Stuck Points
### Opportunities

## Team B
### Wins
### Stuck Points
### Opportunities

## Cross-Team Patterns
<anything that spans both teams>

## Strategy Signals
<any signals that suggest a strategy needs revisiting — or "None this period">
```

---

## Step 7 — Update memory

Read `.claude/memory.md`. Add or update any entries based on insights from this review. Keep it concise — only what future-me should know going into next week.

Write the updated memory file.

---

Deliver a brief closing summary of the 2–3 most important things from the review.
