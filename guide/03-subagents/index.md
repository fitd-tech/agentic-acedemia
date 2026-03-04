# Subagents

You already know the basics. This section focuses on production patterns —
worktree isolation, scoping, and when subagents are the right tool vs. Agent Teams.

## Status

> Work in progress. See `experiments/subagents/` for working examples.

## When to Use Subagents

- Focused, isolated tasks where only the result matters
- Parallel independent work (multiple subagents on different files)
- Protecting the main context window from large tool outputs
- Tasks with a clear, bounded scope

## Worktree Isolation

New in late 2025: subagents can get their own isolated git worktree.
Multiple agents can work on the same repo in parallel without conflicts.

```json
// In agent definition
{
  "isolation": "worktree"
}
```

Or via CLI flag: `--worktree`

The `WorktreeCreate` and `WorktreeRemove` hooks let you customize the lifecycle.

## Subagents vs. Agent Teams

| | Subagents | Agent Teams |
|---|---|---|
| Communication | Report to caller only | Peer-to-peer messaging |
| Coordination | Caller manages | Shared task list, self-organize |
| Cost | Lower | Higher (scales with team size) |
| Best for | Focused isolated tasks | Complex cross-cutting work |

## Resources

- [Claude Code subagents docs](https://code.claude.com/docs/en/)
- [Enabling autonomy blog post](https://www.anthropic.com/news/enabling-claude-code-to-work-more-autonomously)
