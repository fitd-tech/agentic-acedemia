# Experiment: Worktree Isolation

Demonstrates `isolation: "worktree"` — subagents get their own copy of the repo
on a fresh branch, enabling concurrent edits without conflicts.

## What Was Attempted

Two subagents launched in parallel, each with `isolation: "worktree"`:
- **Agent A**: write `agent-a-output.md` (PreToolUse reference card)
- **Agent B**: write `agent-b-output.md` (PostToolUse reference card)

Goal: both edit the same repo concurrently, no conflicts, changes on separate branches.

## What Actually Happened

Both agents were blocked — Bash and Write tools were denied in their worktree sessions.
Agent B confirmed the worktree path: `.claude/worktrees/agent-ac046f6b/`

Since neither agent made any changes, both worktrees were **auto-cleaned** (no
leftover branches or worktree directories).

## Key Finding: Worktrees Don't Change Permissions

`isolation: "worktree"` gives **repo isolation** (separate working directory and branch),
not **permission elevation**. Subagents in worktrees still operate under the same
tool permission model as any other Claude Code session.

If Bash/Write are not auto-approved in your settings, worktree agents will be blocked
just like any other agent.

## How the Pattern Works (When Permissions Allow)

```
Main agent
  ├── Agent(task_A, isolation="worktree")  → .claude/worktrees/<id-A>/  branch: <id-A>
  └── Agent(task_B, isolation="worktree")  → .claude/worktrees/<id-B>/  branch: <id-B>

Each agent:
  - Gets a full copy of the repo at HEAD
  - Works on its own branch — edits don't conflict
  - Auto-cleanup: worktree removed if no changes; kept if changes made

Main agent then:
  - Reviews changes on each branch independently
  - Merges, cherry-picks, or discards as needed
```

## Worktree Lifecycle

| Condition | Result |
|-----------|--------|
| Agent makes no changes | Worktree and branch auto-deleted |
| Agent makes changes | Worktree path and branch returned in result |
| Agent is resumed | Continues with full prior context |

## When to Use Worktree Isolation

- Two agents editing **the same file** — they get independent copies, no race condition
- Long-running parallel tasks where you want clean branch-per-task separation
- Generating multiple implementation variants to compare before choosing one
- CI-style "try this refactor" where you want easy discard if it fails

## What You Need for This to Work

1. **Tool permissions**: agents must be allowed Bash/Write/Edit in your settings
2. **Mindset**: treat worktree agents like CI jobs — they need the same permissions as a CI runner
3. For headless/CI use: configure auto-approve in your `settings.json`

## Key Lessons

1. **`isolation: "worktree"` = repo isolation, not permission isolation** — the
   tool permission model still applies inside the worktree.

2. **Worktrees auto-clean on no changes** — if an agent is blocked or makes no edits,
   the worktree and branch disappear. No manual cleanup needed.

3. **The worktree path is returned on success** — when changes are made, the result
   includes the worktree path and branch name for review/merge.

4. **Best used in CI or fully-approved sessions** — interactive sessions with selective
   approval will block write-capable agents. Pre-approve in settings for autonomous use.

5. **Fan-out + worktree compose** — parallel agents each with their own worktree is
   the pattern for concurrent editing. Without worktrees, parallel editors would conflict.
