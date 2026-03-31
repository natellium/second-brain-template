Quarterly review for each team. Wins & impact against goals, other achievements, leftovers, and opportunities for next quarter.

Distinct from `/retro` (which is personal and inward-looking). This is team-facing and goal-oriented.

---

## Step 1 — Determine the quarter

Ask: "Which quarter? (default: the quarter just ended)"

Determine the date range.

---

## Step 2 — Read team files

For each team (team-a, team-b):
- Read `teams/{team}/strategy.md`
- Read `teams/{team}/quarters/YYYY-QN.md` for the quarter being reviewed

---

## Step 3 — Fetch live GitHub status

For every project in the quarter files that has a GH link, run:

```
gh issue view <url>
```

Collect: title, current status, assignees, whether it was closed/shipped this quarter.

---

## Step 4 — Read supporting context

Read all files in `learnings/` and `ideas/` created during the quarter period.
Read daily notes from the quarter — focus on mentions of each team's projects, decisions, and outcomes.

---

## Step 5 — Synthesise for each team

For each team, produce:

**Wins & Impact**
Achievements that map directly to the quarterly goals and strategy. Be specific — reference the goal, what was done, and the outcome or evidence of impact.

**Other Achievements**
Valuable things done that weren't on the original priority list. Useful for surfacing unplanned but meaningful work.

**Leftovers**
Items listed in the quarter file that weren't completed. For each: brief note on why, and a recommendation — carry forward, drop, or descope.

**Opportunities for Next Quarter**
Ideas, patterns, or signals (from `ideas/`, from themes in daily notes, from what got stuck) that suggest what to prioritise next. Link to relevant ideas files where applicable.

---

## Step 6 — Write review and confirm

Draft the review with this structure for each team:

```
---
type: quarterly-review
quarter:
date:
---

# Quarterly Review — YYYY QN

## Team A

### Wins & Impact
### Other Achievements
### Leftovers
### Opportunities for Next Quarter

---

## Team B

### Wins & Impact
### Other Achievements
### Leftovers
### Opportunities for Next Quarter
```

Show the draft and ask: "Anything to add or correct before I save this?"

Wait for the answer, apply any changes, then write to `reviews/retro/YYYY-QN-review.md`.
