# Skills Experiments

## Completed

### New Experiment Scaffolder (`new-experiment.md`)

A skill that guides Claude through creating a new experiment in this project —
from writing the working artifact to committing the result.

**What it does:**
- Identifies the right topic directory for the experiment
- Builds the artifact first, documents second
- Provides a README template focused on "what would be confusing to reconstruct cold"
- Prompts to update the guide page and MEMORY.md at the end
- Enforces the commit convention as a final step

**Wired in:** `.claude/skills/new-experiment.md` — loaded contextually when creating experiments

#### What Was Learned

1. **Skills are prose instructions, not code.** Unlike hooks (shell scripts), skills
   are markdown files that describe a workflow. Claude reads them and follows the steps —
   the "skill" is the model's ability to execute a structured process from natural language.

2. **The load trigger matters.** Claude loads a skill file when it's relevant to the
   current task, inferred from file name and content. A skill named `new-experiment.md`
   will be pulled in when you say "let's create a new experiment." Naming is the primary
   interface.

3. **Skills encode institutional memory.** The value isn't the steps themselves (Claude
   could figure those out) — it's the project-specific context: which directories exist,
   which commit types are valid, what goes in MEMORY.md vs CLAUDE.md. That's what makes
   a skill reusable across sessions.

4. **Self-referential skills are a good first experiment.** Building a skill *about*
   building experiments means every subsequent experiment benefits immediately. The
   skill itself is the artifact that proves the concept.

---

### Conventional Commit Helper (`conventional-commit.md`)

A skill that guides Claude through writing well-formed conventional commit messages
for this project, including project-specific scope conventions.

**What it does:**
- Documents the valid types and their usage distinctions
- Provides project-specific scopes (hooks, skills, guide, experiments, config, memory)
- Warns about the heredoc gotcha with the commit-normalizer hook
- Enforces imperative mood and length limits

**Wired in:** `.claude/skills/conventional-commit.md` — loaded contextually when committing

#### What Was Learned

1. **Skills complement hooks.** The commit-normalizer hook *enforces* the convention
   mechanically. The conventional-commit skill *explains* it — types, scopes, examples,
   and the heredoc gotcha. They cover different failure modes: the hook catches
   violations; the skill prevents confusion about what's valid in the first place.

2. **Project-specific context is the differentiator.** Generic "how to write conventional
   commits" information is freely available. The scope table (hooks, skills, guide,
   experiments, config, memory) is specific to this project and would otherwise require
   reading CLAUDE.md and the directory structure to reconstruct.

3. **Skills are documentation that Claude can act on.** A README documents for humans.
   A skill documents for Claude. The target audience changes the format: skills should
   be written so Claude can execute them without clarification.

---

## Skills Section Complete

Two skills built, covering the two main patterns:

| Skill | Purpose | Trigger |
|-------|---------|---------|
| `new-experiment.md` | Scaffolds new experiments | "create a new experiment" |
| `conventional-commit.md` | Writes commit messages | "commit" / "git commit" |

**Key insight:** Skills are not code — they're structured prose that encodes
project-specific workflows and context. Their value scales with how much
project-specific knowledge they capture that Claude couldn't infer from the
codebase alone.

**Next:** Subagent patterns — `experiments/subagents/`
