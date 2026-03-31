End of day wrap-up. Work through each step in order, then deliver a brief closing summary.

---

## Step 1 — Scratch-pad check

Read `scratch-pad.md`.

- If it contains anything beyond the placeholder comment, note that there are unprocessed notes and carry them into Step 2.
- If it is empty, note that and skip ahead to Step 3.

---

## Step 2 — Process notes

Run the `/summarise-meetings` skill to process today's meetings and any scratch-pad content into the right places.

This will:
- Pull today's calendar events and extract key context
- File any scratch-pad notes cleanly into the daily note
- Add action items and follow-ups to `task-board.md`

Once the skill completes, clear `scratch-pad.md` back to just the placeholder comment:
```
<!-- scratch-pad — jot anything here, /summarise will file it -->
```

---

## Step 3 — Final task board update

Read `task-board.md`.

- Mark any items completed today as `[x]`.
- Add any loose follow-ups or commitments from the day that aren't captured yet.
- Remove or archive items that are clearly stale or no longer relevant.
- **Remove all `[x]` completed items** from the list before writing — the board should only contain open items.

Write the updated `task-board.md`.

---

## Step 4 — Update the daily note

This command accepts an optional date argument (e.g. `2026-03-27`). If a date was passed as an argument, use that date. Otherwise use today's date.

Read `daily-notes/$DATE.md` (create it if it doesn't exist).

Append or update an **End of Day** section at the bottom:

```
## End of Day

### What got done
<brief bullets — completed tasks, decisions made, progress on in-flight work>

### Carry-forward
<anything unfinished that needs attention tomorrow>

### Notes / observations
<anything worth remembering that doesn't fit above>
```

If the file already has an "End of Day" section, update it rather than duplicating it.

Write the updated daily note.

---

## Step 5 — Update memory

Read `.claude/memory.md`.

Add or update any entries that future-me should know about:
- Decisions made today that affect ongoing work
- Commitments or deadlines that surfaced
- Context that would be useful at tomorrow's `/start`
- People, projects, or threads worth keeping an eye on

Do not duplicate entries already in memory. Remove or update anything that is now stale. Keep it concise.

Write the updated `.claude/memory.md`.

---

## Step 6 — Second brain update

Look back at today's daily note, scratch-pad, and task board changes from this session.

**Learnings:** If anything stands out as a genuine insight — something learned, a pattern noticed, a decision that changed your thinking — create a new file in `learnings/` named `YYYY-MM-DD-{slug}.md` using the learning template. Only create a file if there's something worth capturing; skip this if today was routine.

**Project updates:** If any work today touched a team project (check `teams/team-a/quarters/` and `teams/team-b/quarters/`), update the relevant quarter file — adjust status, add a note. Only if something meaningfully changed.

**Ideas:** If any new idea or opportunity surfaced today, create a file in `ideas/` named `YYYY-MM-DD-{slug}.md` using the idea template. Include the `team:` field.

Keep this step lightweight — only write files if there's genuine signal. Don't manufacture notes.

---

## Step 7 — End of day summary

Deliver a short closing summary:
- What got done today (2–4 bullets max)
- What's carrying forward to tomorrow
- Anything time-sensitive to be aware of first thing

Keep the tone calm and conclusive — like closing a tab, not a status report.
