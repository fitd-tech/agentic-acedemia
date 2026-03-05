# Refresh Documentation

Research the latest Claude Code features, compare to existing docs in this repo, and propose targeted updates.

**Arguments (optional):** $ARGUMENTS — topic to focus on (e.g. "hooks", "MCP"). If blank, covers all topics.

---

## Step 0 — Preflight checks (abort if either fails)

**Model check:** Your system context tells you which model you are running on.
If it is NOT `claude-opus-4-6` (Opus), stop immediately and tell the user:

> This command requires the Opus model for research quality.
> Run `/model` and select **opus**, then try again.

**Plan mode check:** Check whether you are currently operating in plan mode.
If you are NOT in plan mode, stop immediately and tell the user:

> This command requires plan mode so changes can be reviewed before applying.
> Run `/plan` to enable plan mode, then try again.

Only continue past Step 0 if both checks pass.

---

## Step 1 — Research Claude Code changes

Use `WebSearch` to gather current information. Run these searches (adjust scope if `$ARGUMENTS` specifies a topic):

1. `Claude Code release notes changelog 2025`
2. `Claude Code new features hooks MCP slash commands 2025`
3. `Claude Code best practices tips agentic workflows 2025`
4. `Anthropic Claude Code documentation updates`
5. `site:docs.anthropic.com claude code` (or similar to surface official docs pages)

For each result, extract:
- New features or capabilities not present in the current docs
- Changed behavior, deprecated patterns, or renamed APIs
- New best practices or usage guidance
- Any new primitives (new hook types, new settings keys, new tool names, etc.)

Compile a **Research Summary** with findings grouped by topic area.

---

## Step 2 — Audit existing documentation

Read the following files to understand what is currently documented:

- `guide/index.md`
- `guide/00-workflow/index.md`
- `guide/01-claude-md/index.md`
- `guide/02-hooks/index.md`
- `guide/skills/index.md`
- `guide/03-subagents/index.md`
- `guide/04-agent-teams/index.md`
- `guide/05-mcp-servers/index.md`
- `guide/06-github-actions/index.md`
- `guide/slash-commands/index.md`
- `CLAUDE.md`
- `memory/MEMORY.md`

Also scan experiment READMEs for patterns that may be outdated:

- `experiments/hooks/README.md`
- `experiments/skills/README.md`
- `experiments/subagents/README.md`
- `experiments/agent-teams/README.md`
- `experiments/mcp-servers/README.md`
- `experiments/cost-optimization/README.md`
- `experiments/permissions/README.md`
- `experiments/settings-hierarchy/README.md`
- `experiments/context-management/README.md`

---

## Step 3 — Gap analysis

Cross-reference Step 1 findings against Step 2 content. For each finding:

- Mark as **NEW** if not covered anywhere in the repo
- Mark as **CHANGED** if existing docs describe the old behavior
- Mark as **CONFIRMED** if already accurately documented (skip these)

Produce a gap table:

```
| Finding | Type | Affected file(s) |
|---------|------|-----------------|
| ...     | NEW  | guide/02-hooks/index.md |
| ...     | CHANGED | CLAUDE.md, memory/MEMORY.md |
```

If no gaps are found, report that and stop — do not fabricate updates.

---

## Step 4 — Propose updates (plan mode proposals)

For each NEW or CHANGED finding, propose a specific, minimal edit:

- Quote the current text (if CHANGED)
- Show the replacement or addition
- Explain in one sentence why this change is warranted

Do NOT propose changes to files you haven't read. Do NOT refactor or reorganize — minimal targeted updates only.

Focus on:
1. `guide/` pages — primary audience is readers of the GitHub Pages site
2. `CLAUDE.md` — only if a convention is now wrong or a new one is essential
3. `memory/MEMORY.md` — only if a key lesson is now outdated

---

## Step 5 — Changelog entry

After completing the gap analysis (even if there are no gaps), write a new entry to `guide/changelog/index.md`.

The entry format is:

```markdown
## YYYY-MM-DD

**Research date:** <today's date>
**Model used:** claude-opus-4-6
**Scope:** <"all topics" or the specific $ARGUMENTS topic>

### New findings
- <bullet per NEW item, with link to relevant guide section>

### Updated
- <bullet per CHANGED item, noting what was corrected>

### No changes needed
- <bullet for CONFIRMED items or "All documentation is current" if nothing found>
```

If `guide/changelog/index.md` does not exist yet, create it with a page header before the first entry.

---

## Step 6 — Summary

Output a concise summary to the user:

- How many findings were NEW, CHANGED, CONFIRMED
- Which files have proposed edits (if any)
- Remind the user: "Since you are in plan mode, no files have been modified. Review the proposals above and approve each edit individually."
