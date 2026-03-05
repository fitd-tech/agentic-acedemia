# Experiment: Custom Slash Commands

## What was built

Two project-level slash commands in `.claude/commands/`:

| Command | File | Purpose |
|---------|------|---------|
| `/commit` | `commit.md` | Stage, write conventional commit, push |
| `/review [target]` | `review.md` | Structured code review with `$ARGUMENTS` |

## How slash commands work

A slash command is a Markdown file in `.claude/commands/` (project) or `~/.claude/commands/` (user-global).
When invoked, Claude reads the file and follows the prose instructions — same mechanism as skills,
but user-initiated rather than Claude-initiated.

```
.claude/commands/
  commit.md    →  /commit
  review.md    →  /review
```

The filename (without `.md`) becomes the slash command name.

## Key patterns

### `$ARGUMENTS` interpolation

Text after the command name is injected as `$ARGUMENTS` before Claude reads the file:

```
/review experiments/hooks/commit-normalizer.sh
```

Inside `review.md`:
```
Target: $ARGUMENTS
```

Becomes:
```
Target: experiments/hooks/commit-normalizer.sh
```

This lets a single command template handle many different targets. Without `$ARGUMENTS`, the command
is fixed-purpose (like `/commit`).

### Slash commands vs skills

| | Slash commands | Skills |
|---|---|---|
| Invoked by | User (types `/name`) | Claude (reads skill file when needed) |
| Location | `.claude/commands/` | `.claude/skills/` |
| Arguments | `$ARGUMENTS` from command line | None |
| Discovery | Listed in Claude's UI autocomplete | Claude must know to look for them |

Use a slash command when **the user** wants to trigger a specific workflow.
Use a skill when **Claude** needs a reference for how to do something.

### Prose = instructions

Both commands are plain prose — not scripts. Claude reads the file and follows the steps.
This means:
- No special syntax to learn
- Instructions can reference other files (e.g. `see .claude/skills/conventional-commit.md`)
- Complex multi-step workflows read naturally
- Easy to update without touching any code

### Project vs user scope

- `.claude/commands/` — project-scoped, checked into the repo, shared with the team
- `~/.claude/commands/` — user-scoped, available in every project on your machine

Project scope is preferred for workflow commands that encode team conventions.
User scope is preferred for personal productivity commands that work anywhere.

## What was learned

- File name = command name; keep names short and verb-like (`commit`, `review`, `standup`)
- `$ARGUMENTS` is all-or-nothing — the entire string after the command name; split it with prose instructions if you need structure (e.g. "first word is the scope, rest is the message")
- Commands should be idempotent and safe by default — `review.md` explicitly says "do not edit unless asked"
- `/commit` delegates scope inference to Claude; `/review` uses `$ARGUMENTS` to target a specific file — both patterns are valid depending on whether the user has a specific target in mind
