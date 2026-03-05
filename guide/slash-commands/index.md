# Custom Slash Commands

Custom slash commands let you define reusable, project-specific workflows that users trigger by typing `/command-name` in Claude Code.

## Quick start

Create a Markdown file in `.claude/commands/`:

```
.claude/commands/
  standup.md    →  /standup
  review.md     →  /review
```

The file contents are prose instructions that Claude follows when the command is invoked.

## `$ARGUMENTS`

Text typed after the command name is available as `$ARGUMENTS`:

```
/review src/parser.ts
```

In `review.md`:

```markdown
Review the code at: $ARGUMENTS

Instructions:
1. Read the file at $ARGUMENTS
...
```

If no argument is given, `$ARGUMENTS` is an empty string. Write your instructions to handle that gracefully (e.g. "If no argument is given, use git diff to find recently changed files").

## Scope

| Location | Scope |
|----------|-------|
| `.claude/commands/` | Project — checked into the repo |
| `~/.claude/commands/` | User — available in every project |

Project commands encode team conventions. User commands encode personal workflows.

## Slash commands vs skills

Both are Markdown files with prose instructions. The difference is who triggers them:

- **Slash commands** — user types `/name` to invoke
- **Skills** — Claude reads the file when it needs guidance on how to do something

A command like `/commit` is user-initiated. A skill like `conventional-commit.md` is Claude-initiated reference material. They can complement each other: `/commit` references the conventional-commit skill internally.

## Design guidelines

1. **Name after the verb** — `/review`, `/standup`, `/deploy`. Short and memorable.
2. **Default safely** — if the command makes changes, require confirmation or explicit follow-up. Don't auto-apply.
3. **Be explicit about output format** — if you want structured output, say so in the instructions.
4. **Reference other files** — commands can point to skills, CLAUDE.md conventions, or config files.
5. **Handle missing arguments** — if `$ARGUMENTS` is optional, write a fallback in the instructions.

## Examples in this project

- `.claude/commands/commit.md` — multi-step commit workflow, infers scope from diff
- `.claude/commands/review.md` — structured code review, uses `$ARGUMENTS` to target a file
