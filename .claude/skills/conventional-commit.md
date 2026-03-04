# Skill: Conventional Commit

Use this skill when writing a git commit message for this project.

## Format

```
type(scope): description
```

`scope` is optional. `description` must be lowercase, imperative mood, no trailing period.

## Valid Types

| Type | Use when |
|------|---------|
| `feat` | Adding new functionality |
| `fix` | Fixing a bug |
| `docs` | Documentation only |
| `chore` | Maintenance, deps, config (no production code change) |
| `refactor` | Code change that neither fixes a bug nor adds a feature |
| `test` | Adding or updating tests |
| `style` | Formatting, whitespace (no logic change) |
| `perf` | Performance improvement |
| `ci` | CI/CD configuration |
| `build` | Build system or tooling |
| `revert` | Reverting a previous commit |

## Scopes Used in This Project

| Scope | What it covers |
|-------|---------------|
| `hooks` | Hook scripts in `experiments/hooks/` |
| `skills` | Skill files in `.claude/skills/` |
| `guide` | Documentation in `guide/` |
| `experiments` | Experiment directories and READMEs |
| `config` | `.claude/settings.json`, `mkdocs.yml`, `CLAUDE.md` |
| `memory` | `memory/MEMORY.md` |
| `ci` | `.github/workflows/` |

## Examples

```
feat(hooks): add dry-run injector for destructive commands
fix(hooks): use printf instead of echo to avoid trailing newline in JSON
docs(guide): add workflow and sessions section
chore(config): add commit-normalizer to settings.json
refactor(skills): split new-experiment into setup and document phases
```

## Steps

1. Run `git diff --staged` to see what's actually staged
2. Choose the type that best describes the *intent*, not the *mechanism*
   - Adding a new hook script → `feat`
   - Fixing a bug in a hook → `fix`
   - Updating a README → `docs`
3. Use the scope from the table above, or omit it if the change spans multiple areas
4. Write the description in imperative mood: "add X", "fix Y", "update Z" (not "added", "fixing")
5. Keep it under 72 characters total

## Note on the Commit Normalizer Hook

This project enforces conventional commits via `experiments/hooks/commit-normalizer.sh`.
The hook blocks commits with non-conforming messages. Use multi-line `-m "..."` syntax
(not heredoc) to pass the message — the normalizer's sed parser doesn't handle heredoc.
