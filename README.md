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

The `gcloud` skill requires the `gws` CLI for Gmail, Calendar, and Drive access. See `.claude/skills/gcloud/SKILL.md` for setup instructions, and the [Troubleshooting: Google Workspace setup](#troubleshooting-google-workspace-setup-grafana) section below if you hit OAuth errors.

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

---

## Troubleshooting: Google Workspace setup (Grafana)

This fixes the common setup failure where `gws` or the gcloud skill cannot auto-create an OAuth client in `grafanalabs-dev` because that project has hit its OAuth client limit.

### Symptoms

You may see errors like:

- `Access denied. No credentials provided. Run gws auth login`
- `No OAuth client configured yet`
- `Auto-setup can't create OAuth clients on grafanalabs-dev`
- `The project has reached the limit of 36 OAuth clients`

### Recommended workaround

Instead of trying to use `grafanalabs-dev`, create your own GCP project under the `sandbox` parent and do the OAuth setup manually in the GCP UI.

### Steps

1. **Create a new GCP project**
   - Create a new project under the **sandbox** parent project.
   - Do this in the **Google Cloud UI**, not via CLI.

2. **Enable a Google Workspace API**
   - In your new project, go to **APIs**.
   - Open **Library** or **Add new**.
   - Enable at least one Google Workspace API, such as:
     - **Drive API**
     - **Docs API**

3. **Create an OAuth client**
   - Go to **Credentials**.
   - Click **Create credentials**.
   - Choose **OAuth Client ID**.
   - Use:
     - **Application type:** `Desktop app`
     - **User type:** `External`
     - **Name:** anything you want

4. **Generate and save the client secret**
   - Open the new OAuth client.
   - Click **Add secret**.
   - Save the downloaded OAuth JSON file locally.

5. **Add yourself as a test user**
   - In the left navigation, open **Audience**.
   - Scroll to **Test users**.
   - Add your `@grafana.com` email address.

6. **Enable any other APIs you need**
   - Return to the API Library.
   - Enable additional Google Workspace APIs as needed.
   - You should not need to repeat the full OAuth client setup each time.

7. **Authenticate from the terminal**
   - Run:
     ```bash
     gws auth login
     ```
   - If needed, use `-s` to restrict scopes to a smaller set, such as only Drive.

8. **Complete the browser auth flow**
   - If your environment can open a browser, complete auth normally.
   - Otherwise, copy-paste the login URL manually.
   - If you get a **404** after authorizing, copy the final 404 URL and curl it from the terminal to complete the redirect.

9. **Configure gws to use your new project**
   - If the tool still points at `grafanalabs-dev`, reconfigure it to use the new sandbox project instead.

### Notes

- The main blocker is not Drive itself; it is usually the **OAuth client creation** step.
- The key fix is using a **new sandbox project** instead of `grafanalabs-dev`.
- One person in the thread also noted that using the new project made it easier for `gws` to enable the larger set of Google APIs it wanted.

### TL;DR

- Create a new project under **sandbox**
- Enable **Drive API** or another Workspace API
- Create a **Desktop app** OAuth client with **External** user type
- Download the client secret JSON
- Add yourself under **Audience > Test users**
- Run `gws auth login`
- Point `gws` at the new project if needed
