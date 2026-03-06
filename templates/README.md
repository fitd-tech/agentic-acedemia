# Starter Templates

Drop-in configuration files for bootstrapping Claude Code in any project. These are generalized from the working artifacts in [agentic-acedemia](https://github.com/anthonypelusocook/agentic-acedemia).

## Quick Start

```bash
# From your project root:
cp templates/CLAUDE.md ./CLAUDE.md
mkdir -p .claude/hooks .claude/commands

cp templates/settings.json .claude/settings.json
cp templates/hooks/*.sh .claude/hooks/
cp templates/commands/*.md .claude/commands/

# Make hooks executable
chmod +x .claude/hooks/*.sh

# Add to .gitignore
echo '.claude/settings.local.json' >> .gitignore
echo '.claude/edit-log.jsonl' >> .gitignore
```

Then edit `CLAUDE.md` to describe your project.

## File Reference

### Configuration

| File | Destination | Purpose |
|------|-------------|---------|
| `CLAUDE.md` | `./CLAUDE.md` | Project context file — edit sections to match your project |
| `settings.json` | `.claude/settings.json` | Project settings — model default, hooks wired |
| `settings.local.json` | `.claude/settings.local.json` | Personal overrides (gitignored) — model, output style |
| `user-settings.json` | `~/.claude/settings.json` | User-level settings — applies to all projects |
| `mcp.json` | `./.mcp.json` | MCP server config — replace `/path/to/your/project` with your project root |

### Commands

| File | Destination | Purpose |
|------|-------------|---------|
| `commands/commit.md` | `.claude/commands/commit.md` | `/commit` — stage, commit (conventional), push |
| `commands/review.md` | `.claude/commands/review.md` | `/review <file>` — four-dimension code review |
| `commands/test.md` | `.claude/commands/test.md` | `/test` — detect runner, run suite, report results |

### Hooks

| File | Destination | Purpose |
|------|-------------|---------|
| `hooks/secret-scanner.sh` | `.claude/hooks/secret-scanner.sh` | PreToolUse — blocks commands that expose secrets |
| `hooks/commit-normalizer.sh` | `.claude/hooks/commit-normalizer.sh` | PreToolUse — enforces conventional commit format |
| `hooks/edit-logger.sh` | `.claude/hooks/edit-logger.sh` | PostToolUse — logs file edits to JSONL |

## Customization

**CLAUDE.md**: Replace all bracketed placeholders (`[e.g. TypeScript]`) with your actual stack. Add architecture decisions as you make them.

**settings.json**: The default model is `claude-sonnet-4-6`. Change it or add more hooks as needed. JSON has no comments, so refer to this README for field documentation.

**mcp.json**: Replace `/path/to/your/project` with your project's absolute path. This path acts as the filesystem server's access allowlist.

**Hooks**: All three hooks work as-is. The secret scanner and commit normalizer are PreToolUse hooks (they can block). The edit logger is PostToolUse (observation only). To disable a hook, remove its entry from `settings.json`.

## What to Gitignore

```
.claude/settings.local.json
.claude/edit-log.jsonl
```

`settings.local.json` is for personal overrides (model preference, output style). `edit-log.jsonl` is a local audit trail that grows with every session.
