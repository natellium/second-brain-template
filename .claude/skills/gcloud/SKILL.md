---
name: gdrive
description: "Search, list, read, download, and upload files on Google Drive, read/create Calendar events, and read/send Gmail messages, via the gws CLI."
allowed-tools: Bash, Read, Write, Edit, Glob
---

# Google Drive, Calendar & Gmail Skill

Access a company Google Drive, Calendar, and Gmail ([Your Company]) via the `gws` CLI. Default mode is **read-only**. Write operations require explicit user confirmation.

## Step 0: Preflight Check

Before any Drive operation, verify `gws` is installed and authenticated.

```bash
command -v gws >/dev/null 2>&1 && echo "GWS_INSTALLED" || echo "GWS_NOT_FOUND"
```

### If `GWS_NOT_FOUND`

Guide the user through installation and auth:

### Install gws

```bash
brew install node   # if needed
npm install -g @googleworkspace/cli
```

### Authenticate

**Option A: Automatic (requires `gcloud` CLI)**

```bash
gcloud auth login          # login with your company email first
gws auth setup             # creates GCP project, enables APIs, logs you in
```

**Option B: Manual OAuth setup (recommended if Option A asks for credentials)**

This is needed when `gws auth setup` can't auto-create OAuth credentials, which is common in corporate Google Workspace environments.

1. Go to [Google Cloud Console](https://console.cloud.google.com/) and sign in with your company email
2. **Create a project** (or pick an existing one):
   - Click the project dropdown (top bar) > "New Project"
   - Name it something like `gws-cli-personal`
3. **Enable the Drive API**:
   - Go to APIs & Services > Library
   - Search for "Google Drive API" > click **Enable**
4. **Configure OAuth consent screen**:
   - Go to APIs & Services > OAuth consent screen
   - User Type: **External** (testing mode is fine)
   - Fill in app name (e.g., `gws-cli`), support email (your email)
   - Skip scopes for now, click through to save
5. **Add yourself as a test user**:
   - On the OAuth consent screen page, click **Test users** > **Add users**
   - Enter your company email address
   - This is required — without it, login fails with "Access blocked"
6. **Create OAuth credentials**:
   - Go to APIs & Services > Credentials
   - Click **Create Credentials** > **OAuth client ID**
   - Application type: **Desktop app**
   - Name: `gws-cli`
   - Click **Create**
7. **Download the credentials JSON**:
   - Click the download icon next to the new client
   - Save the file to: `~/.config/gws/client_secret.json`
   ```bash
   mkdir -p ~/.config/gws
   # Move the downloaded file:
   mv ~/Downloads/client_secret_*.json ~/.config/gws/client_secret.json
   ```
8. **Login with Drive, Calendar, and Gmail scopes**:
   ```bash
   gws auth login -s drive,calendar,gmail
   ```
   - Browser opens, sign in with your company email
   - If you see "Google hasn't verified this app", click **Continue**
   - Approve Drive, Calendar, and Gmail access
   - Also enable the **Gmail API** in APIs & Services > Library if not already enabled

### Verify

```bash
gws drive about get --params '{"fields": "user"}'
```

You should see JSON with your company email. If so, you're ready. Run `/gdrive` again.

**Stop here.** Do not proceed until `gws` is installed and authenticated.

### If `GWS_INSTALLED`

Verify Drive auth is working:

```bash
gws drive about get --params '{"fields": "user"}' 2>&1
```

- If this returns an auth error → guide user to run `gws auth login -s drive,calendar,gmail`.

Then verify Calendar auth:

```bash
gws calendar calendarList list --params '{"maxResults": 1}' 2>&1
```

- If this returns a `403 insufficientPermissions` error → guide user to run `gws auth login -s drive,calendar,gmail` to add calendar scope.

Then verify Gmail auth:

```bash
gws gmail users getProfile --params '{"userId": "me"}' 2>&1
```

- If this returns a `403 insufficientPermissions` error → guide user to run `gws auth login -s drive,calendar,gmail` to add Gmail scope.
- If all three succeed → proceed to the requested operation.

**Important:** Note the authenticated user's email from the Drive response. This determines what files and calendars are visible. Inform the user:

```
Authenticated as: {email}
Drive and Calendar access is scoped to files and events this account can see.
```

## Operations

### 1. Search / List Files

Use `drive files list` with the `q` parameter for search queries.

**List recent files:**
```bash
gws drive files list --params '{"pageSize": 10, "orderBy": "modifiedTime desc", "fields": "files(id,name,mimeType,modifiedTime,owners,shared)"}'
```

**Search by name:**
```bash
gws drive files list --params '{"q": "name contains '\''search term'\''", "pageSize": 20, "fields": "files(id,name,mimeType,modifiedTime,owners,shared)"}'
```

**Search by file type:**
```bash
# Google Docs
gws drive files list --params '{"q": "mimeType='\''application/vnd.google-apps.document'\''", "pageSize": 10, "fields": "files(id,name,modifiedTime,owners)"}'

# Google Sheets
gws drive files list --params '{"q": "mimeType='\''application/vnd.google-apps.spreadsheet'\''", "pageSize": 10, "fields": "files(id,name,modifiedTime,owners)"}'

# PDFs
gws drive files list --params '{"q": "mimeType='\''application/pdf'\''", "pageSize": 10, "fields": "files(id,name,modifiedTime,owners)"}'
```

**Search within a folder:**
```bash
gws drive files list --params '{"q": "'\''FOLDER_ID'\'' in parents", "pageSize": 20, "fields": "files(id,name,mimeType,modifiedTime)"}'
```

**Search in shared drives:**
```bash
gws drive files list --params '{"q": "name contains '\''search term'\''", "includeItemsFromAllDrives": true, "supportsAllDrives": true, "corpora": "allDrives", "pageSize": 20, "fields": "files(id,name,mimeType,modifiedTime,driveId,owners)"}'
```

**Combine filters:**
```bash
# Docs modified in last 7 days
gws drive files list --params '{"q": "mimeType='\''application/vnd.google-apps.document'\'' and modifiedTime > '\''2026-03-04T00:00:00'\''", "pageSize": 10, "fields": "files(id,name,modifiedTime,owners)"}'
```

**Paginate all results (large result sets):**
```bash
gws drive files list --params '{"q": "name contains '\''quarterly'\''", "pageSize": 100, "fields": "files(id,name,mimeType,modifiedTime)"}' --page-all --page-limit 5
```

#### Common MIME Types

| Type | MIME |
|------|------|
| Google Doc | `application/vnd.google-apps.document` |
| Google Sheet | `application/vnd.google-apps.spreadsheet` |
| Google Slides | `application/vnd.google-apps.presentation` |
| Google Form | `application/vnd.google-apps.form` |
| Folder | `application/vnd.google-apps.folder` |
| PDF | `application/pdf` |
| CSV | `text/csv` |

#### Presenting Results

Display results as a table for readability:

```
| Name | Type | Modified | Owner |
|------|------|----------|-------|
| ... | Doc | 2026-03-10 | user@grafana.com |
```

If no results found, suggest:
- Broadening the search term
- Checking shared drives (`includeItemsFromAllDrives`)
- Verifying the user has access to the target folder/drive

---

### 2. Read / Download Files

#### Get file metadata:
```bash
gws drive files get --params '{"fileId": "FILE_ID", "fields": "id,name,mimeType,modifiedTime,size,owners,shared,webViewLink"}'
```

#### Export Google Workspace files (Docs, Sheets, Slides):

Google Workspace files must be **exported** to a standard format. They cannot be downloaded directly.

```bash
# Google Doc → Markdown (plain text)
gws drive files export --params '{"fileId": "FILE_ID", "mimeType": "text/plain"}' -o ./output.txt

# Google Doc → PDF
gws drive files export --params '{"fileId": "FILE_ID", "mimeType": "application/pdf"}' -o ./output.pdf

# Google Sheet → CSV
gws drive files export --params '{"fileId": "FILE_ID", "mimeType": "text/csv"}' -o ./output.csv

# Google Slides → PDF
gws drive files export --params '{"fileId": "FILE_ID", "mimeType": "application/pdf"}' -o ./output.pdf
```

#### Download binary files (PDFs, images, etc.):
```bash
gws drive files get --params '{"fileId": "FILE_ID", "alt": "media"}' -o ./downloaded-file.pdf
```

#### Export Format Reference

| Source | Export MIME | Extension |
|--------|-----------|-----------|
| Google Doc | `text/plain` | .txt |
| Google Doc | `text/markdown` | .md |
| Google Doc | `application/pdf` | .pdf |
| Google Doc | `application/vnd.openxmlformats-officedocument.wordprocessingml.document` | .docx |
| Google Sheet | `text/csv` | .csv |
| Google Sheet | `application/vnd.openxmlformats-officedocument.spreadsheetml.sheet` | .xlsx |
| Google Slides | `application/pdf` | .pdf |
| Google Slides | `application/vnd.openxmlformats-officedocument.presentationml.presentation` | .pptx |

#### Where to Save Downloads

- Analysis inputs → `outputs/research/`
- Reference docs → `outputs/{product}/`
- Temporary → `/tmp/`

Always tell the user where the file was saved.

---

### 3. Upload Files (WRITE — Requires Confirmation)

> **WRITE OPERATION:** Always confirm with the user before executing.

Before uploading, confirm:
```
I'll upload the following file to Google Drive:

  File: {local_path}
  Name: {target_name}
  Destination: {folder name or "My Drive root"}
  Authenticated as: {email}

Proceed? (Y/n)
```

**Only proceed after explicit user confirmation.**

#### Upload to Drive root:
```bash
gws drive +upload ./file.pdf
```

#### Upload to a specific folder:
```bash
gws drive +upload ./file.pdf --parent FOLDER_ID
```

#### Upload with a custom name:
```bash
gws drive +upload ./report.pdf --name 'Q1 2026 Report.pdf'
```

#### Create a Google Doc from content:
```bash
gws drive files create --json '{"name": "My Document", "mimeType": "application/vnd.google-apps.document"}'
```

#### Create a folder:
```bash
gws drive files create --json '{"name": "New Folder", "mimeType": "application/vnd.google-apps.folder"}'
```

#### Upload to a shared drive:

```bash
gws drive +upload ./file.pdf --parent SHARED_DRIVE_FOLDER_ID
```

Note: The authenticated user must have **write access** to the target folder. If the upload fails with a permission error, inform the user they need write access granted by the drive/folder owner.

---

### 4. Calendar

#### List calendars:
```bash
gws calendar calendarList list --params '{"maxResults": 10}' 2>&1
```

#### Today's events:
```bash
gws calendar events list --params '{"calendarId": "primary", "timeMin": "'"$(date -u +%Y-%m-%dT00:00:00Z)"'", "timeMax": "'"$(date -u -v+1d +%Y-%m-%dT00:00:00Z)"'", "singleEvents": true, "orderBy": "startTime", "fields": "items(id,summary,start,end,attendees,location,hangoutLink)"}'
```

#### Events for a specific date range:
```bash
gws calendar events list --params '{"calendarId": "primary", "timeMin": "2026-03-10T00:00:00Z", "timeMax": "2026-03-14T23:59:59Z", "singleEvents": true, "orderBy": "startTime", "fields": "items(id,summary,start,end,attendees,location,hangoutLink)"}'
```

#### Events from a specific calendar:
```bash
# Use the calendar ID from calendarList list (not "primary")
gws calendar events list --params '{"calendarId": "CALENDAR_ID", "timeMin": "'"$(date -u +%Y-%m-%dT00:00:00Z)"'", "timeMax": "'"$(date -u -v+1d +%Y-%m-%dT00:00:00Z)"'", "singleEvents": true, "orderBy": "startTime"}'
```

#### Get a specific event:
```bash
gws calendar events get --params '{"calendarId": "primary", "eventId": "EVENT_ID"}'
```

#### Presenting Calendar Results

Display events as a table:

```
| Time | Event | Attendees | Link |
|------|-------|-----------|------|
| 09:00-09:30 | Standup | 5 people | meet.google.com/... |
```

Tips:
- `"primary"` = the authenticated user's main calendar
- Always use `singleEvents: true` to expand recurring events
- Times are UTC — convert to user's timezone when presenting
- Attendee list may be large; show count and key names only

#### Calendar Write Operations (WRITE — Requires Confirmation)

> **WRITE OPERATION:** Always confirm with the user before executing.

**Create an event:**
```bash
gws calendar events insert --params '{"calendarId": "primary"}' --json '{
  "summary": "Meeting Title",
  "start": {"dateTime": "2026-03-12T10:00:00+01:00"},
  "end": {"dateTime": "2026-03-12T10:30:00+01:00"},
  "attendees": [{"email": "colleague@grafana.com"}]
}'
```

Before creating, confirm:
```
I'll create the following calendar event:

  Title: {summary}
  When: {start} - {end}
  Attendees: {list}
  Calendar: {calendarId}

This will send invitations to attendees. Proceed? (Y/n)
```

---

### 5. Gmail

#### Get mailbox profile:
```bash
gws gmail users getProfile --params '{"userId": "me"}'
```

#### List messages (most recent first):
```bash
gws gmail users messages list --params '{"userId": "me", "maxResults": 10}'
```

#### Search messages (Gmail query syntax):
```bash
# Unread messages
gws gmail users messages list --params '{"userId": "me", "q": "is:unread", "maxResults": 20}'

# From a specific sender
gws gmail users messages list --params '{"userId": "me", "q": "from:someone@example.com", "maxResults": 20}'

# By subject keyword
gws gmail users messages list --params '{"userId": "me", "q": "subject:standup", "maxResults": 20}'

# Combined filters (unread + in inbox)
gws gmail users messages list --params '{"userId": "me", "q": "is:unread in:inbox", "maxResults": 20}'
```

#### Read a message (get full content):
```bash
# Get message with full payload (includes body)
gws gmail users messages get --params '{"userId": "me", "id": "MESSAGE_ID", "format": "full"}'
```

The body is base64url-encoded in `payload.body.data` (or `payload.parts[].body.data` for multipart). Decode it:
```bash
# Decode body inline
gws gmail users messages get --params '{"userId": "me", "id": "MESSAGE_ID", "format": "full"}' | python3 -c "
import sys, json, base64
msg = json.load(sys.stdin)
parts = msg.get('payload', {}).get('parts', [])
body = msg.get('payload', {}).get('body', {}).get('data', '')
if parts:
    body = next((p['body']['data'] for p in parts if p.get('mimeType') == 'text/plain'), body)
print(base64.urlsafe_b64decode(body + '==').decode('utf-8', errors='replace'))
"
```

#### Get message metadata only (headers, no body):
```bash
gws gmail users messages get --params '{"userId": "me", "id": "MESSAGE_ID", "format": "metadata", "metadataHeaders": ["From","To","Subject","Date"]}'
```

#### List labels:
```bash
gws gmail users labels list --params '{"userId": "me"}'
```

#### Presenting Email Results

Display message lists as a table:

```
| Date | From | Subject | Labels |
|------|------|---------|--------|
| 2026-03-15 09:00 | alice@grafana.com | Re: Q1 Review | INBOX, UNREAD |
```

Tips:
- Message bodies are base64url-encoded — always decode before presenting
- Multipart messages: prefer `text/plain` part; fall back to `text/html`
- Strip excessive whitespace/quoted text when summarizing long threads
- Show thread context (message count) when listing threads

#### Send Email (WRITE — Requires Confirmation)

> **WRITE OPERATION:** Always confirm with the user before executing.

Before sending, confirm:
```
I'll send the following email:

  From: {authenticated email}
  To: {recipients}
  Subject: {subject}
  Body preview: {first ~100 chars}

Proceed? (Y/n)
```

**Only proceed after explicit user confirmation.**

```bash
# Build and send a raw RFC 2822 message (base64url-encoded)
python3 -c "
import base64, sys
msg = '''From: me
To: recipient@example.com
Subject: Hello
Content-Type: text/plain; charset=utf-8

Message body here.'''
encoded = base64.urlsafe_b64encode(msg.encode()).decode().rstrip('=')
print(encoded)
" | xargs -I{} gws gmail users messages send --params '{"userId": "me"}' --json '{"raw": "{}"}'
```

Or compose the JSON directly for simple messages:
```bash
RAW=$(python3 -c "
import base64
msg = 'From: me\r\nTo: recipient@example.com\r\nSubject: Hello\r\nContent-Type: text/plain; charset=utf-8\r\n\r\nBody here.'
print(base64.urlsafe_b64encode(msg.encode()).decode().rstrip('='))
")
gws gmail users messages send --params '{"userId": "me"}' --json "{\"raw\": \"$RAW\"}"
```

#### Reply to a message (WRITE — Requires Confirmation)

Include the original `threadId` to keep replies in the same thread:
```bash
gws gmail users messages send --params '{"userId": "me"}' --json '{"threadId": "THREAD_ID", "raw": "BASE64URL_ENCODED_MESSAGE"}'
```

---

## Permission Awareness

This skill operates on a **company Drive** ([Your Company]). Key rules:

1. **Respect access boundaries.** Only files visible to the authenticated user are returned. If a search returns no results, it may be a permissions issue, not an empty result.

2. **Shared drives require explicit flags.** Always include `includeItemsFromAllDrives` and `supportsAllDrives` when searching across the organization.

3. **Write failures = permission issue first.** If an upload or create fails, check permissions before retrying. Common causes:
   - User lacks Editor/Contributor role on the target folder
   - Shared drive has restricted upload settings
   - File quota exceeded

4. **Don't assume ownership.** Files found in search may be owned by others. Check `owners` field before suggesting modifications.

5. **Dry-run for destructive operations.** Use `--dry-run` when available to preview what would happen.

---

## Error Handling

| Error | Likely Cause | Action |
|-------|-------------|--------|
| `401 Unauthorized` | Token expired or missing | Run `gws auth login -s drive,calendar,gmail` |
| `403 insufficientPermissions` | Missing calendar or Gmail scope | Run `gws auth login -s drive,calendar,gmail` |
| `403 Forbidden` | No access to file/folder | Inform user, suggest requesting access |
| `404 Not Found` | File deleted or no access | Check file ID, may be a permissions issue |
| `429 Rate Limit` | Too many requests | Wait and retry with `--page-delay` |
| `ENOENT` / command not found | `gws` not installed | Run Step 0 setup |

---

## Stretch Goals (Not Yet Implemented)

- **Share files** — `drive permissions create` to share files/folders with specific users or groups
- **Move files** — Update parent folders via `drive files update`
- **Watch for changes** — `drive changes list` for monitoring updates
- **Batch operations** — Multi-file search/download patterns
