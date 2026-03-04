# Workflow & Sessions

Core habits for working effectively with Claude Code — before you write a single hook or skill.

---

## Context Window

The context window is the total amount of information Claude can hold in working memory
for a single session. Every message, tool call, file read, and system prompt consumes tokens.
When the window fills up, Claude either auto-compacts or loses earlier context.

### Monitoring with `/context`

```
/context
```

Shows a live breakdown of token usage by category:

| Category | What it includes |
|----------|-----------------|
| System prompt | Claude Code's built-in instructions |
| System tools | Tool definitions (Read, Edit, Bash, etc.) |
| MCP tools | Any connected MCP server tool definitions |
| Memory files | `CLAUDE.md` + auto-memory files |
| Skills | Any loaded SKILL.md files |
| Messages | Your conversation history — the one that grows |
| Free space | Available tokens remaining |
| Autocompact buffer | Reserved for compaction; not usable |

**Messages** is the category to watch. It grows with every turn and is the primary
driver of context pressure.

### Strategies for Managing Context

**Start fresh for unrelated tasks.** Don't continue a long session into a completely
different problem. A new session starts with a clean messages budget.

**Use subagents as context shields.** When a task requires reading many large files,
delegate it to a subagent. The subagent's file reads don't enter your main context —
only its summary does. This is one of the most underused context management techniques.

**Use SKILL.md files instead of re-explaining.** If you find yourself re-explaining
the same patterns session after session, that context belongs in a skill file. Skills
are loaded only when relevant, not on every turn.

**`/compact` — manual compaction.** Compresses earlier conversation history into a
summary, freeing space while preserving key decisions. Use it when you're deep in a
session and want to keep going without starting over.

**`PreCompact` hook.** Fires before auto-compaction. Use it to save a snapshot of
in-progress state to a file so nothing critical is lost.

---

## Plan Mode

Plan mode is a read-only phase where Claude explores the codebase, designs an approach,
and presents it for your approval — before touching any files.

### Enabling

```
/plan
```

Toggles plan mode on. Claude can read files and search the codebase but cannot edit,
write, or run commands. Exits when you approve the plan or type `/plan` again.

### When to Use It

Use plan mode for any task that would touch more than 2-3 files or involves an
architectural decision. The cost of a wrong approach compounds quickly once edits
start — plan mode catches misalignment before it happens.

**Good candidates for plan mode:**
- Refactoring a module
- Adding a new feature with multiple touchpoints
- Debugging an unfamiliar codebase
- Anything where you'd want to review the approach before execution

**Skip plan mode for:**
- Single-file fixes with obvious solutions
- Tasks where you've given explicit, detailed instructions

### The Approval Flow

1. You enable plan mode (`/plan`)
2. Claude explores the codebase and writes a plan
3. Claude calls `ExitPlanMode` to signal it's ready for your review
4. You review and either approve or give feedback
5. On approval, plan mode exits and execution begins

You can ask questions, redirect, or request changes before approving. This is the
right moment to catch misunderstandings — not after 20 file edits.

### Plan Mode + Hooks

`PreToolUse` hooks still fire in plan mode for read operations (Glob, Grep, Read).
Write-class tools (Edit, Write, Bash) are blocked by plan mode itself, so hooks
that target those tools effectively don't run until execution begins.

---

## Session Management

### Resuming Sessions

```bash
claude --resume
```

Picks up the last session with full conversation history intact. Use this after a
restart, a break, or when switching machines via cloud handoff.

Named sessions let you resume a specific session by name rather than the most recent:

```bash
claude --resume my-session-name
```

### Session Forking

Fork a session to explore two different approaches from the same point without
losing either branch:

```bash
claude --fork
```

Both branches share history up to the fork point. Useful for comparing implementation
strategies without committing to one.

### `--from-pr`

Initialize a session pre-loaded with the diff and context of a GitHub PR:

```bash
claude --from-pr 42
```

Claude starts with full knowledge of what changed, why, and the surrounding file
context — no manual copy-pasting of diffs.

---

## Model Selection

Different models have different capability/cost/speed tradeoffs. Choosing the right
one for the task saves money and time.

| Model | Best for |
|-------|---------|
| **Haiku 4.5** | Quick lookups, simple edits, high-volume automation |
| **Sonnet 4.6** | Default for most development work — best balance |
| **Opus 4.6** | Complex reasoning, agent teams, security scanning, `ultrathink` tasks |

### Switching Mid-Session

```
Alt+P
```

Opens the model picker without starting a new session. Switch to Opus for a hard
problem, then back to Sonnet to keep going.

### `ultrathink`

Appending `ultrathink` to a prompt triggers maximum reasoning effort for that turn:

```
Refactor this auth module. ultrathink
```

Use it for genuinely hard architectural questions. It's more expensive and slower —
don't use it for routine tasks.
