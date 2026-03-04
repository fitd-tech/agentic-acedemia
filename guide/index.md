# Agentic Academia

A personal reference for production-grade Claude Code patterns — built by doing, documented as I go.

## What This Is

This site is generated directly from the same repo where the experiments live.
Every hook script, skill file, and config referenced here is a working artifact you can use.

## Why This Exists

The job market for software developers has fundamentally changed. Knowing how to *use* Claude Code
is table stakes. Knowing how to *design* agentic workflows — with proper governance, modularity,
and observability — is the differentiator.

This is my working reference for building that depth.

## Guide Structure

| Section | What You'll Learn |
|---------|------------------|
| [CLAUDE.md Engineering](01-claude-md/index.md) | Writing high-signal context files that scale across projects |
| [Hooks](02-hooks/index.md) | Lifecycle control, governance, and observability |
| [Subagents](03-subagents/index.md) | Delegation patterns, worktree isolation, scoping |
| [Agent Teams](04-agent-teams/index.md) | Peer-to-peer multi-agent coordination (Opus 4.6+) |
| [MCP Servers](05-mcp-servers/index.md) | Extending Claude with external tools and data sources |
| [GitHub Actions](06-github-actions/index.md) | Headless workflows, CI integration, async automation |

## The Learning Loop

Each section follows the same pattern:

1. **Experiment** — build something small in `experiments/`
2. **Extract** — promote stable patterns to `.claude/skills/` or `.claude/hooks/`
3. **Document** — write up what was learned here
4. **Refine** — update `CLAUDE.md` to reflect the pattern
