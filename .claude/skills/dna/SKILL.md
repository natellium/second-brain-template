---
name: dna
description: Create a Product DNA document with signal gathering from user research, BigQuery analytics, and competitive research.
allowed-tools: Read, Write, Edit, Glob, Grep, Task, WebFetch, Bash, Skill
model: opus
---

# Product DNA Workflow

You are helping the user create a Product DNA — a strategic document used to align stakeholders on why a feature or capability should exist, what problem it solves, and what success looks like.

DNAs are written in Markdown first, reviewed locally, then published to Google Docs once approved.

---

## Step 1: Understand the Topic

Ask the user:

1. What is the DNA about? (feature, capability, or product decision)
2. What problem are we trying to solve? Any data or anecdotes already known?
3. Who are the target users? (e.g. novice users, power users, enterprise admins)
4. Which product area? (Team A, Team B, cross-product)
5. Are we exploring options, or do we already know what we're building?
6. Is competitive analysis relevant for this one?

---

## Step 2: Gather Signals

### 2a. User Research (always)

Run `/user-research` before drafting. This searches Aha Ideas, GitHub Issues, Gong calls, Zendesk tickets, Community forums, and Slack.

```
/user-research [topic keywords]
```

**What to capture:**
- Specific customer quotes (verbatim, with source)
- Vote counts and request frequency
- Named customers or orgs with explicit need (e.g. Deutsche Telekom, Google)
- Usage metrics already mentioned by customers
- How customers describe the problem in their own words (may differ from internal terminology)

### 2b. Product Analytics (when relevant)

Use the `grafana-product:product-analytics` skill to pull usage data from BigQuery when the problem involves low adoption, usage patterns, or funnel metrics.

Examples of useful queries:
- Adoption rate (% of orgs using a feature)
- Funnel drop-off (e.g. "X% of users who click Y actually complete Z")
- Usage frequency vs. alternative workflows

Always note: sample size, time range, and data source.

### 2c. Competitive Research (sometimes — ask first)

Use web research or the `[your-research-skill]` skill when relevant. Ask the user: "Is competitive context useful here?"

Focus on:
- How direct competitors solve the same problem (Datadog, Splunk, Tableau, etc.)
- Why existing [Your Company] panels/features don't solve it ("Why not Canvas?" style)
- Industry patterns that validate the customer need

---

## Step 3: Draft the DNA

Use the structure below. Sections marked **(optional)** should only be included when they add real value — don't fill them in for completeness.

```markdown
# Product DNA: [Feature Name]
*[One-liner tagline — what this enables for users]*

| | |
|---|---|
| **Author(s)** | [Name(s)] |
| **Date** | YYYY-MM-DD |
| **Release Date** | [Quarter or target date] |
| **Status** | In Discussion |
| **Reviewer(s)** | Awaiting Review [Name] |
| **Informed** | [team alias or names] |

---

## Customer problem

[The core problem narrative. Lead with what's broken or missing today. Weave in
evidence inline — specific metrics, customer quotes, usage data. Don't save the
data for a separate section; let it support the argument as you make it.]

[Example pattern: "Currently, only 4.46% of users who click X actually complete Y.
In the same timeframe, we've seen 200K clicks on [related thing], which tells us
users do value [underlying need]."]

[Direct customer quotes go here, inline:
> "Quote in customer's own words." — Source (Gong / Aha / GitHub #XXXX)]

## Who are we designing for? (optional)

[Include only when personas meaningfully shape the solution. Skip if it's obvious
from context.]

- **[Persona]**: [One sentence on their goal and context]
- **[Persona]**: [One sentence]

## Why does it matter?

[Business context: how this connects to team or department goals, OKRs, or
product strategy. Link to relevant strategy docs.

Example: "Our department aims to increase product consumption, measured by how
quickly users build dashboards with richer content. See [Team A FY27 Strategy]."]

## What are we building?

[Brief description of the solution. Can be "[TBD — pending discovery]" if we're
still in the research phase. This is not an engineering spec — just enough to
align on direction.

If there's a prototype or Figma, link it here.]

## What's the desired outcome?

[Success criteria and how we'll measure it. Can be a table or bullets depending
on complexity.

Example table format:]

| Outcome | How we measure it |
|---------|-------------------|
| [Goal]  | [Metric or method] |
| [Goal]  | [Metric or method] |

## Options (optional)

[Include only when there's a genuine decision with real tradeoffs — e.g. sunset
vs. invest vs. pivot. If the path is clear, skip this section entirely.

Proposal 0: Do nothing — always worth articulating.]

## Competitive analysis (optional)

[Include when competitive context meaningfully informs the direction.

Lead with the key insight, then support it. Example:
"None of our direct competitors support X, making this a differentiation opportunity."

Or: "Why not [existing [Your Company] panel]?" — short explanation of the gap.]

## Resources

- [Link to related design doc, Figma, GitHub issue, or prior research]
- [Link to strategy doc or OKR if referenced above]
```

---

## Step 4: Quality Check

Before presenting the draft, verify:

**Content:**
- [ ] Problem section includes at least one specific data point or customer quote
- [ ] Evidence is woven into the narrative — not dumped in a list at the end
- [ ] "What are we building" is honest about uncertainty if we don't know yet
- [ ] No section restates what another section already said

**Writing:**
- [ ] Leads with the point — no preamble
- [ ] Active voice, present tense
- [ ] Customer quotes are verbatim, not paraphrased
- [ ] Links are included for any referenced docs or data sources

**Structure:**
- [ ] Optional sections are only present when they add value
- [ ] Status is set correctly (In Discussion / In Progress / Not started)
- [ ] Reviewer(s) use "Awaiting Review [Name]" format

---

## Step 5: Save

Save the draft to:
```
outputs/{product}/analyses/YYYY-MM-DD-{slug}-dna.md
```

Examples:
- Team A feature → `outputs/team-a/analyses/`
- Team B feature → `outputs/team-b/analyses/`
- Cross-product → `outputs/_cross-product/analyses/`

Ask the user which product area if unclear.

Also save raw research output to `outputs/{product}/research/` as an audit trail.

---

## Step 6: Review & Publish (when approved)

Once the DNA has been reviewed and approved:

1. Create a Google Doc copy using the `/dna-publish` skill *(to be set up)*
2. Replace the local markdown file content with a reference to the doc:

```markdown
# Product DNA: [Feature Name]

> This DNA has been published. See the Google Doc for the current version:
> [Product DNA: Feature Name](https://docs.google.com/document/d/...)
>
> Published: YYYY-MM-DD
```

This keeps the local file as a pointer while the Google Doc becomes the source of truth for collaboration.

---

## Writing principles

- **Evidence inline, not appended.** The problem section should make the case. Data and quotes support the argument where they appear, not in a separate "signals" dump.
- **Honest about unknowns.** If "What are we building" is TBD, say so. If we're still deciding between options, include the options section.
- **Length follows content.** Some DNAs are half a page; some are two pages with a discovery section. Don't pad, don't compress artificially.
- **Named customers > anonymous evidence.** "Deutsche Telekom needs X" is stronger than "some enterprise customers need X."
- **Link don't duplicate.** If detailed research exists elsewhere (Gong call, design doc, POC), link to it rather than copying it in.
