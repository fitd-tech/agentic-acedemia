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

## When to Block vs. When to Log

This is the most important design decision when writing a hook.

**Block** (`PreToolUse` returning `{ "decision": "block" }`) only when the action is
irreversible or dangerous *in your specific context*. Overusing blocks makes Claude
frustrating to work with and erodes trust in the tooling.

**Log** (`PostToolUse` writing to a file or endpoint) when you want visibility without
friction. For local solo projects, logging is almost always more appropriate than blocking.

| Context | Right approach |
|---------|---------------|
| Local solo project | `PostToolUse` log — observe, don't block |
| Shared team repo | `PreToolUse` block — enforce for everyone via committed `settings.json` |
| CI/CD pipeline | `PreToolUse` block — logs are retained and often visible to many people |

**Example:** blocking `echo $API_KEY` on a local machine you control adds no real security.
The same block in a GitHub Actions workflow prevents a credential from appearing in logs
accessible to every repo collaborator. Same pattern, completely different risk profile.

## Practical Use Cases

- **Team repo:** block file writes outside approved directories
- **CI/CD:** block commands that echo secrets into logs
- **Any context:** log all Edit tool calls to a local audit file
- **Any context:** normalize commit messages to match project conventions
- **Observability:** POST every tool call to a monitoring endpoint

## Resources

- [Hooks reference](https://code.claude.com/docs/en/hooks)
- [DataCamp hooks tutorial](https://www.datacamp.com/tutorial/claude-code-hooks)
- [GitButler automation patterns](https://blog.gitbutler.com/automate-your-ai-workflows-with-claude-code-hooks)
- [Multi-agent observability via hooks](https://github.com/disler/claude-code-hooks-multi-agent-observability)
