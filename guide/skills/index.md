# SKILL.md Files

Skills are reusable workflow files that live in `.claude/skills/`. Each skill is a
Markdown file that Claude loads when it's relevant to the current task — guided by
the file name and content.

## What Skills Are

A skill is structured prose that describes a workflow. It's not code, not a script,
and not a prompt template. It's a document that Claude reads and follows, like a
Standard Operating Procedure.

```
.claude/
└── skills/
    ├── new-experiment.md      ← loaded when creating experiments
    └── conventional-commit.md ← loaded when writing commits
```

Skills complement CLAUDE.md and hooks:

| Mechanism | Purpose | When it runs |
|-----------|---------|-------------|
| `CLAUDE.md` | Project context, conventions, working style | Every session |
| Hooks | Enforce rules mechanically | At tool use boundaries |
| Skills | Guide workflows with project-specific knowledge | When contextually relevant |

## How Claude Loads Skills

Claude infers relevance from the skill file's name and content. A file named
`conventional-commit.md` will be pulled in when you ask Claude to commit changes.
A file named `new-experiment.md` activates when you say "let's create a new experiment."

**Naming is the primary interface.** Choose names that match the natural language
you'd use to trigger the workflow.

## Anatomy of a Skill File

A skill file typically contains:

1. **A title and one-line purpose** — so Claude knows immediately whether to load it
2. **Steps** — numbered, concrete, sequentially executable
3. **Project-specific context** — the scopes, paths, and conventions that Claude
   couldn't infer from reading the codebase
4. **Examples** — especially for format-constrained outputs like commit messages

Avoid putting information in a skill that Claude already knows universally.
The value is in what's *specific to this project*.

## Skills vs. CLAUDE.md

The distinction comes down to frequency and scope:

- **CLAUDE.md** is always loaded. Put stable facts there: project purpose, structure,
  conventions that apply everywhere.
- **Skills** are loaded on demand. Put workflow-specific detail there: step-by-step
  instructions that are only relevant for one task type.

A skill that was always relevant would be better as a CLAUDE.md section.
A CLAUDE.md section that only matters for one workflow would be cleaner as a skill.

## Skills vs. Hooks

Skills and hooks are complementary, not competing:

| | Hooks | Skills |
|---|---|---|
| Mechanism | Shell scripts, exit codes | Markdown prose |
| Enforcement | Mechanical (can block) | Guidance (Claude follows voluntarily) |
| Best for | Preventing bad outputs | Guiding good process |

The commit normalizer hook *blocks* non-conventional commits.
The conventional-commit skill *explains* what's valid and why.
Together they cover different failure modes.

## Working Examples

Both skills in this project are in `.claude/skills/` and documented in
`experiments/skills/README.md`.

### `new-experiment.md`

Scaffolds a new experiment: creates the directory, writes the artifact, fills in the
README template, updates the guide, updates MEMORY.md, and commits.

This is a *meta-skill* — a skill for doing the work of this project itself.
It captures the steps that would otherwise require re-reading CLAUDE.md and looking
at existing experiment structure each time.

### `conventional-commit.md`

Guides Claude through writing a well-formed conventional commit message for this
project. Includes:
- The type/scope table with project-specific scopes
- Imperative mood and length rules
- The heredoc gotcha with the commit-normalizer hook

This skill has a direct relationship with the commit-normalizer hook:
the hook enforces the rule; the skill explains the context behind it.

## Key Takeaways

1. **Skills are institutional memory.** The value isn't the generic steps — it's the
   project-specific context that Claude couldn't reconstruct from the codebase alone.

2. **Name skills after the trigger phrase.** `new-experiment.md` → "let's create a
   new experiment." The file name is how Claude knows when to load it.

3. **Skills don't need to be exhaustive.** Write just enough for Claude to execute
   the workflow without asking clarifying questions. Trust Claude's general knowledge
   for the universal parts.

4. **Skills scale with the project.** Each skill you write reduces the prompt-per-session
   overhead for recurring tasks. Over a large project, this compounds significantly.
