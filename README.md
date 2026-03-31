# Second Brain — Claude-Powered Personal Assistant

A vault-based second brain for engineering managers, built to run inside Claude Code. It combines an Obsidian-compatible note structure with Claude slash commands and agents that automate the daily rhythm of note-taking, reviews, and strategy work.

---

## What's in here

| Path | Purpose |
|------|---------|
| `CLAUDE.md` | System prompt loaded into every Claude conversation — defines the vault structure and conventions |
| `.claude/commands/` | Slash commands: `/start`, `/wrap-up`, `/review`, `/brief`, `/retro`, etc. |
| `.claude/agents/` | Subagents: vault operations, strategy research, strategy review |
| `.claude/skills/` | Skills: strategy writing, Google Workspace integration, Product DNA |
| `templates/` | Note templates for ideas, learnings, strategies, and quarter files |
| `scripts/` | Optional automation scripts (e.g. morning startup) |
| `teams/`, `daily-notes/`, `ideas/`, etc. | Vault folders — empty, ready to fill |

---

## Setup

### 1. Rename the team placeholders

This template uses `Team A` / `team-a` and `Team B` / `team-b` as placeholder names. Do a global find-and-replace across the repo before your first session:

```
Team A  →  [Your Team 1 Name]
team-a  →  [your-team-1-slug]
Team B  →  [Your Team 2 Name]
team-b  →  [your-team-2-slug]
```

Files to update: `CLAUDE.md`, `MOC.md`, all `.claude/commands/*.md`, `.claude/agents/*.md`, `.claude/skills/strategy/SKILL.md`.

If you only manage one team, remove all `Team B` / `team-b` references and the `teams/team-b/` directory.

### 2. Update CLAUDE.md

At the top of `CLAUDE.md`, fill in:
- Your name
- Your company
- Your role

### 3. Customize the strategy reviewer agents

The two strategy reviewer agents (`.claude/agents/strategy-reviewer-pm.md` and `.claude/agents/strategy-reviewer-doe.md`) have placeholder sections marked with `> Replace this section`. Fill in your company's product context and your manager's perspective so the reviews are grounded.

### 4. Set up Google Workspace (optional)

The `gcloud` skill requires the `gws` CLI for Gmail, Calendar, and Drive access. See `.claude/skills/gcloud/SKILL.md` for setup instructions.

### 5. Open as an Obsidian vault (optional)

The folder structure is Obsidian-compatible. Open `~/path/to/your/vault` as a vault in Obsidian to get wikilink navigation, graph view, and frontmatter filtering.

### 6. Automate the morning routine (optional)

`scripts/morning-start.sh` runs `/wrap-up` for yesterday and `/start` for today on login. Update the paths inside the script, then add it as a macOS Login Item or launchd job.

---

## Daily workflow

| When | Command | What it does |
|------|---------|-------------|
| Morning | `/start` | Loads memory, checks emails, reads team context, writes daily note |
| During day | `/brief <topic>` | Pulls everything known about a topic from the vault |
| End of day | `/wrap-up` | Files meetings, updates task board, writes end-of-day note, updates memory |
| Weekly/monthly | `/review` | Surface themes, wins, and stuck points from recent notes |
| Quarterly | `/quarterly-review` | Team-facing review against goals |
| Quarterly | `/retro` | Personal retrospective — what moved, what didn't |
| Ad hoc | `/strategy` | Write or refresh a team strategy document |

---

## Vault conventions

- Every note has YAML frontmatter (see `CLAUDE.md` for required fields)
- Use `[[wikilinks]]` to connect notes
- File ideas in `ideas/YYYY-MM-DD-{slug}.md`, learnings in `learnings/YYYY-MM-DD-{slug}.md`
- Quarter files reference GitHub issues as the source of truth for project status

---

## Claude Code setup

This vault is designed to be opened as a project in Claude Code:

```
claude --dir /path/to/your/vault
```

`CLAUDE.md` is auto-loaded into every conversation. Slash commands in `.claude/commands/` are available immediately as `/command-name`.
