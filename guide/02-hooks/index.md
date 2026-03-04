# Hooks

Hooks are the single most important addition to Claude Code since Fall 2025.
They give you deterministic control over Claude's behavior at every step.

## Status

> Work in progress. See `experiments/hooks/` for working examples.

## What Hooks Are

Shell commands, HTTP endpoints, or LLM prompts that fire at lifecycle events.
Unlike CLAUDE.md (advisory), hooks are **enforced** — they can block or modify tool calls.

## The 3 Handler Types

| Type | How | Best For |
|------|-----|----------|
| Command | Shell script, JSON on stdin/stdout | Local enforcement, secret scanning |
| HTTP | POST JSON to a URL | Observability, external systems |
| Prompt/Agent | Spin up an LLM | Semantic evaluation of complex decisions |

## Key Events

| Event | When It Fires | Can Block? |
|-------|--------------|------------|
| `PreToolUse` | Before any tool call | Yes — and can modify inputs |
| `PostToolUse` | After a tool succeeds | No |
| `SessionStart` | Session begins | No |
| `SubagentStart` | Subagent spawns | Yes |
| `PreCompact` | Before context compaction | No |
| `Stop` | Claude finishes responding | No |

## Scoping

```
~/.claude/settings.json          # All your projects (global)
.claude/settings.json            # This project (committable)
.claude/settings.local.json      # Personal overrides (gitignored)
```

## Practical Use Cases

- Auto-redact secrets before they reach a Bash command
- Normalize commit messages to match project conventions
- Block file writes outside approved directories
- Run a linter after every Edit tool call
- Log all tool calls to an observability stack

## Resources

- [Hooks reference](https://code.claude.com/docs/en/hooks)
- [DataCamp hooks tutorial](https://www.datacamp.com/tutorial/claude-code-hooks)
- [GitButler automation patterns](https://blog.gitbutler.com/automate-your-ai-workflows-with-claude-code-hooks)
- [Multi-agent observability via hooks](https://github.com/disler/claude-code-hooks-multi-agent-observability)
