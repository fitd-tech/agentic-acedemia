# Starter Templates

Reference material and examples from the [agentic-acedemia](https://github.com/anthonypelusocook/agentic-acedemia) learning workspace.

## Distribution

Runtime configuration (hooks, commands, settings, shared CLAUDE.md) has moved to the **[claude-code-config](https://github.com/anthonypelusocook/claude-code-config)** repo. That repo distributes shared config via symlinks — edit once, propagate everywhere.

To set up a new project with shared config:
```bash
cd ~/claude-code-config && claude
> /install          # one-time: installs global /init-config command

cd ~/my-project && claude
> /init-config      # links shared config into this project
```

## What Remains Here

### Reference Examples

| File | Purpose |
|------|---------|
| `mcp.json` | Example MCP server config (project-specific, not shared) |

### Subagent Prompts

| File | Pattern | Use case |
|------|---------|----------|
| `subagents/parallel-pr-review.md` | Fan-out | 3 agents review a PR simultaneously: security, performance, test coverage |
| `subagents/codebase-onboarding.md` | Context protection | Subagent reads a large codebase, returns structured summary |
| `subagents/build-log-analyzer.md` | Context protection | Subagent reads noisy build/test output, returns only failures + root causes |
| `subagents/parallel-file-analyzer.md` | Fan-out (generic) | N agents analyze N files simultaneously; fill in your own analysis goal |
| `subagents/worktree-feature-builder.md` | Worktree isolation | Subagent builds a complete feature on an isolated branch |
| `subagents/dependency-auditor.md` | Context protection | Subagent reads dependency files, returns security + staleness audit |

Each template includes a paste-ready Agent prompt with `ALL_CAPS` placeholders, configuration notes, and a customization guide.

These templates are also condensed into a single reference file (`subagent-prompts.md`) in the config repo, which gets copied into projects during `/init-config`.
