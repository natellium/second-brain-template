---
name: dna-publish
description: Publish an approved Product DNA from local markdown to Google Drive. Converts to .docx (preserving formatting), uploads to the DNAs folder, and replaces the local file with a reference link.
allowed-tools: Read, Write, Edit, Bash, Glob
model: sonnet
---

# DNA Publish Workflow

Converts a local DNA markdown file to a Word doc, uploads it to Google Drive, and
replaces the local file with a pointer to the doc.

**Target folder:** `1Bov9eiU6b9pnkKK19irrt2HBcyN66sUd`
(https://drive.google.com/drive/u/0/folders/1Bov9eiU6b9pnkKK19irrt2HBcyN66sUd)

---

## Step 1: Find the file

If a file path was passed as an argument, use it. Otherwise ask:

> "Which DNA file should I publish? (e.g. `outputs/team-a/analyses/2026-03-15-mesh-panel-dna.md`)"

Read the file and extract:
- **Title**: from the `# Product DNA: [Title]` heading — used as the Drive filename
- **Status**: from the metadata table — warn (but don't block) if it's not "Approved" or "In Progress"
- **Slug**: from the filename, used for temp file naming

---

## Step 2: Confirm

Show the user before doing anything:

```
I'll publish the following DNA to Google Drive:

  Title:  Product DNA: [Title]
  File:   [local path]
  Folder: https://drive.google.com/drive/u/0/folders/1Bov9eiU6b9pnkKK19irrt2HBcyN66sUd

Proceed? (Y/n)
```

Only continue after explicit confirmation.

---

## Step 3: Ensure pandoc is available

```bash
command -v pandoc >/dev/null 2>&1 && echo "PANDOC_OK" || echo "PANDOC_MISSING"
```

If missing, install it:

```bash
brew install pandoc
```

Confirm it installed successfully before continuing. If brew is unavailable or install
fails, fall back to plain text (see Step 3b) and warn the user.

---

## Step 3a: Convert markdown to .docx

```bash
pandoc [input.md] \
  --from markdown \
  --to docx \
  -o /tmp/dna-publish-[slug].docx
```

If the conversion fails, fall back to Step 3b.

---

## Step 3b: Fallback — plain text

If pandoc is unavailable or conversion failed:

```bash
cp [input.md] /tmp/dna-publish-[slug].txt
```

Warn the user:
> "Publishing as plain text — formatting will not be preserved. Install pandoc for
> better results: `brew install pandoc`"

Use `.txt` as the upload file for the next step.

---

## Step 4: Upload to Google Drive

```bash
gws drive +upload /tmp/dna-publish-[slug].docx \
  --parent 1Bov9eiU6b9pnkKK19irrt2HBcyN66sUd \
  --name "Product DNA: [Title].docx"
```

After upload, retrieve the file's web link:

```bash
gws drive files list --params '{
  "q": "name='\''Product DNA: [Title].docx'\'' and '\''1Bov9eiU6b9pnkKK19irrt2HBcyN66sUd'\'' in parents",
  "fields": "files(id,name,webViewLink)",
  "pageSize": 1
}'
```

Extract the `webViewLink` from the response.

---

## Step 5: Update local file

Replace the entire content of the local markdown file with a reference pointer:

```markdown
# Product DNA: [Title]

> This DNA has been published to Google Drive. The doc is now the source of truth
> for collaboration and review.
>
> **[Open in Google Drive →]([webViewLink])**
>
> Published: [YYYY-MM-DD]

---

*To edit or share this DNA, use the Google Drive link above.*
*Sharing is controlled manually — use Drive's sharing controls.*
```

---

## Step 6: Clean up and confirm

Remove the temp file:

```bash
rm /tmp/dna-publish-[slug].docx
```

Tell the user:

```
✓ Published.

  Google Drive: [webViewLink]
  Local file:   [local path] (updated with reference link)

To share with reviewers, open the Drive link and use Drive's sharing controls.
```

---

## Error handling

| Situation | Action |
|-----------|--------|
| `gws` not authenticated | Run `gws auth login -s drive` then retry |
| Upload fails (403 / permission) | Inform user they may lack write access to the folder |
| File already exists in Drive | Ask: overwrite, add date suffix (e.g. `2026-03-15 Product DNA: [Title].docx`), or cancel |
| pandoc install fails | Fall back to plain text upload, warn user |
