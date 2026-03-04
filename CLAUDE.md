# Agentic Academia

This is a personal learning and reference workspace for mastering Claude Code.
The repo itself is the guide — every hook, skill, and config here is a working artifact.

## Purpose

Build and document production-grade patterns for:
- CLAUDE.md engineering
- Hooks (lifecycle control and governance)
- SKILL.md modular workflows
- Subagent orchestration with worktree isolation
- Agent Teams (multi-agent peer coordination)
- GitHub Actions / headless / CI integration

## Project Structure

- `.claude/hooks/` — hook scripts (documented in `guide/02-hooks/`)
- `.claude/skills/` — reusable SKILL.md files (documented in `guide/`)
- `.claude/commands/` — custom slash commands
- `experiments/` — hands-on mini-projects for each concept
- `guide/` — publishable Markdown documentation (served via GitHub Pages)

## Working Style

- Prefer small, focused experiments over large monolithic projects
- Document as you go — each experiment should have a README
- When a pattern proves stable, extract it to `.claude/skills/` or `.claude/hooks/`
- Keep this file under 150 lines and high-signal

## Learning Order

1. CLAUDE.md engineering (this file is the example)
2. Hooks — `guide/02-hooks/` and `experiments/hooks/`
3. SKILL.md files — `.claude/skills/`
4. Subagent patterns — `experiments/subagents/`
5. Agent Teams — `experiments/agent-teams/`
6. GitHub Actions + headless — `experiments/` + `.github/workflows/`

## Conventions

- All experiments have a `README.md` explaining what was learned
- Hook scripts are executable shell scripts with inline comments
- Skills are self-contained SKILL.md files usable in other projects
