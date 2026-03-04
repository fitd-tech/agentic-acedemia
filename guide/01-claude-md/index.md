# CLAUDE.md Engineering

`CLAUDE.md` is the file Claude Code loads into every conversation automatically.
It is the foundation that everything else depends on.

## Status

> Work in progress. See `experiments/` and the root `CLAUDE.md` for current state.

## Key Principles

- **Every line must earn its place.** Ask: "Would removing this cause Claude to make mistakes?" If no, cut it.
- **Keep it under 150 lines.** Beyond that, the signal-to-noise ratio drops.
- **Advisory only.** CLAUDE.md is for context and conventions — not enforcement. Use hooks for enforcement.
- **Use `@path/to/file` imports** to pull in additional files modularly (useful for monorepos).
- **Place hierarchically.** Root-level is global; subdirectory-level is scoped to that module.

## What Belongs Here

- Project purpose and architecture overview
- Commands to run tests, build, lint
- Coding conventions specific to this project
- File structure and where things live
- Known gotchas or non-obvious decisions

## What Does NOT Belong Here

- Things that must always happen — use a hook instead
- Documentation that already lives in a README
- Generic best practices Claude already knows
- Anything that will be stale within a week

## Resources

- [Official CLAUDE.md guide](https://claude.com/blog/using-claude-md-files)
- [HumanLayer: Writing a good CLAUDE.md](https://www.humanlayer.dev/blog/writing-a-good-claude-md)
- [Official best practices](https://code.claude.com/docs/en/best-practices)
