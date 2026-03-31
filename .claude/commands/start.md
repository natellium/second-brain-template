Good morning! Let's get your day started. Working through your morning standup now.

**Step 1 — Memory & context**
Read the `.claude/memory.md` file. Note any open follow-ups, reminders, or carry-over context that's relevant for today.

Then load team context:
- Read `teams/team-a/strategy.md` and `teams/team-b/strategy.md` — note anything with a stale `updated:` date (older than 30 days).
- Read the most recent quarter file in `teams/team-a/quarters/` and `teams/team-b/quarters/` — flag any projects marked blocked or with no recent progress.
- Scan `ideas/` for any files with `status: raw` — surface them briefly if there are any.

Keep this quick — one short paragraph per team if there's anything worth flagging, otherwise skip silently.

**Step 2 — Emails**
Run the `/process-emails` skill. Summarize any action items, decisions needed, or time-sensitive threads. Keep it brief — flag only what matters.

**Step 3 — Task board**
Read `task-board.md`. Give a concise summary of what's on the plate: what's in progress, what's blocked, and what's coming up next.

**Step 4 — Prioritize**
Based on the emails and task board, suggest a focus order for the day. Flag anything time-sensitive or that has dependencies.

**Step 5 — Yesterday's wrap-up**
Check the task board for any items marked `done` or `completed`. Remove them silently and note what was cleared in the summary.

**Step 6 — Write daily note**
Create a new daily note at `daily-notes/YYYY-MM-DD.md` (today's date). Use this structure:

```
---
date: YYYY-MM-DD
---

## Emails

### Actionable
<bullet per actionable email: sender, subject, required action>

### Skipped
<brief list of noise/automated emails>

## Task Board
<concise summary: what's in progress, what's blocked, what's up next>

## Focus Order
<ordered list of today's priorities with rationale>

## Context Flags
<anything surfaced from memory, strategy files, or raw ideas — omit section if nothing to flag>
```

Do not output the standup summary to the terminal — write it directly to the daily note file. Confirm with the filename once done.

Keep the tone like a quick morning standup — direct, no fluff. Total time to get through this should feel like 5 minutes.
