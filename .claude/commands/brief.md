On-demand context brief. Pull everything known about a topic, project, or theme from the vault.

Usage: `/brief <topic>` — e.g. `/brief Team B`, `/brief Q2 planning`, `/brief [some initiative]`

---

## Step 1 — Identify the topic

Use the argument passed to this command as the search topic. If no argument was given, ask: "What would you like a brief on?"

---

## Step 2 — Search the vault

Search across these locations for any mention of the topic (case-insensitive, partial match is fine):

- `teams/team-a/strategy.md` and `teams/team-b/strategy.md`
- All files in `teams/team-a/quarters/` and `teams/team-b/quarters/`
- All files in `ideas/`
- All files in `learnings/`
- All files in `reviews/`
- Recent daily notes (last 30 days in `daily-notes/`)

Collect all relevant passages, decisions, and references.

---

## Step 3 — Fetch GitHub status (if applicable)

If the topic matches a project listed in a quarter file that has a GH link, run:

```
gh issue view <url>
```

to fetch the current title, status, assignees, and any recent activity. Include this in the brief.

---

## Step 4 — Synthesise and deliver

Output a structured brief directly in the conversation (no file write):

```
## Brief: <topic>

### Current Status
<what's the state of this right now>

### Recent Activity (last 2 weeks)
<what happened recently — from daily notes, meetings, emails>

### Key Decisions Made
<decisions already locked — no need to re-litigate>

### Open Questions
<what's still unresolved or unknown>

### Related Ideas
<any ideas in ideas/ linked to this topic>
```

Keep it scannable. This is for quick orientation, not a deep dive.
