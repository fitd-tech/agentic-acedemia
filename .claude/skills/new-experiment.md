# Skill: New Experiment

Use this skill when creating a new experiment in this project.

## What This Skill Does

Scaffolds a new experiment following the established pattern:
- Creates the experiment directory with a README
- Writes the working artifact (hook script, skill file, workflow, etc.)
- Updates `experiments/<topic>/README.md` with what was learned
- Wires any new configs into `.claude/settings.json` if needed
- Adds a guide section if the topic is new

## Steps

### 1. Confirm the topic and experiment name

The experiment should fit into one of the established topic areas:
- `experiments/hooks/` — lifecycle hooks (PreToolUse, PostToolUse)
- `experiments/skills/` — reusable SKILL.md workflows
- `experiments/subagents/` — subagent delegation patterns
- `experiments/agent-teams/` — peer-to-peer multi-agent coordination
- `experiments/sdk/` — Claude API / Agent SDK usage

Name the experiment concisely in kebab-case (e.g., `context-guardian`, `parallel-researcher`).

### 2. Create the working artifact first

Build the thing before documenting it. For a hook:
- Write the shell script in `experiments/hooks/<name>.sh`
- Make it executable: `chmod +x experiments/hooks/<name>.sh`
- Wire it in `.claude/settings.json`

For a skill:
- Write the SKILL.md in `.claude/skills/<name>.md`
- No wiring needed — Claude loads skills contextually

For a subagent or agent-team experiment:
- Write the orchestrating script or prompt in the experiment directory
- Include a `run.sh` or inline instructions in the README

### 3. Test it

Run a real invocation and verify the behavior. For hooks, confirm they fire and
produce the expected block/allow/modify result. For skills, invoke the skill and
verify Claude follows the workflow.

### 4. Write the README

Use this template for `experiments/<topic>/README.md` (or append to it if it exists):

```markdown
### <Experiment Name> (`<filename>`)

<One-line description of what it does.>

**What it does:**
- Bullet list of key behaviors

**Wired in:** (if applicable) where it's configured

#### What Was Learned

1. **<Key lesson>** — explanation
2. **<Key lesson>** — explanation
...
```

Focus `What Was Learned` on things that would be confusing to reconstruct cold —
not "I ran a test and it passed" but "the thing that surprised me or that I'd
forget next time."

### 5. Update the guide page

If this experiment introduces a new concept or technique, add it to the
relevant `guide/<section>/index.md`. Prefer appending a new subsection over
rewriting existing content.

### 6. Update MEMORY.md

Add a brief entry under `## Current Progress` in
`memory/MEMORY.md`:
- What was built
- The most important lesson learned
- Any gotcha worth preserving

### 7. Commit

Use conventional commit format (enforced by hook):
```
feat(experiments): add <name> experiment
```
or
```
docs(guide): add <topic> section
```
