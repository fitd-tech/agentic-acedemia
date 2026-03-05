# Cost Optimization

Token cost scales with model capability and context size. The goal is to match model
capability to task complexity — never use Opus for what Haiku can do.

---

## 1. Model Selection Strategy

### The model ladder

| Model | Use when | Avoid when |
|-------|----------|------------|
| `claude-haiku-4-5-20251001` | Structured extraction, classification, CI linting, summarization | Complex reasoning, ambiguous requirements |
| `claude-sonnet-4-6` | Most coding tasks, code review, multi-step reasoning | Simple extraction, high-volume batch tasks |
| `claude-opus-4-6` | Architectural decisions, complex debugging, nuanced review | Routine tasks — it costs ~5x Sonnet |

### Decision rule

> Start with Haiku. Upgrade only when output quality is demonstrably insufficient.

For agentic pipelines, use a tiered approach:
- **Orchestrator**: Sonnet (plans, delegates, synthesizes)
- **Workers**: Haiku (reads files, extracts data, formats output)
- **Reviewer**: Sonnet or Opus only if the stakes are high

### Setting the default model per project

```json
// .claude/settings.json
{
  "model": "claude-sonnet-4-6"
}
```

Override per session: `claude --model claude-haiku-4-5-20251001`
Override per headless call: `claude -p "..." --model claude-haiku-4-5-20251001`

---

## 2. Context Size Management

Context is the primary cost driver — more tokens in = more tokens out = higher cost.

### Tactics

**Load only what's needed**
- Use `Glob` + `Grep` to find the right file before reading it
- Pass file excerpts to subagents instead of full files
- Use subagents for noisy inputs (build logs, large diffs) — see `experiments/subagents/context-protection/`

**Compact aggressively**
- `/compact` between major subtasks — cuts context size without losing intent
- `PreCompact` hook (`experiments/context-management/pre-compact.sh`) shapes what's retained

**Keep CLAUDE.md tight**
- Every line in CLAUDE.md is loaded every session — cut ruthlessly
- The project CLAUDE.md enforces a 150-line limit for exactly this reason
- Move stable reference content to linked files; only put active instructions in CLAUDE.md

**Keep MEMORY.md tight**
- MEMORY.md is auto-loaded every session — same cost pressure as CLAUDE.md
- Summarize completed sections rather than appending indefinitely
- Archive old session detail to topic files, keep MEMORY.md as a compact index

### Estimating cost before running

The status bar context percentage shows current usage. High percentage = high per-turn cost.
Compact before starting expensive operations if context is already high.

---

## 3. Thinking Tokens

Extended thinking (visible as the "thinking" block) adds tokens but improves quality on
hard problems. It's enabled by default on supported models.

**Disable for simple tasks:**
```json
{ "alwaysThinkingEnabled": false }
```

Or per session: `claude --no-thinking` (if supported)

Thinking is worth it for: architectural decisions, complex debugging, multi-constraint problems.
Not worth it for: file reading, formatting, extraction, summarization.

---

## 4. Headless / CI Optimization

CI is where unmanaged cost accumulates fastest.

**Always specify the model in CI:**
```yaml
- run: claude -p "$PROMPT" --model claude-haiku-4-5-20251001 --output-format json
```

**Scope the context explicitly:**
Instead of letting Claude discover the codebase, pass the relevant files directly:
```bash
DIFF=$(git diff HEAD~1)
claude -p "Review this diff for security issues: $DIFF" \
  --model claude-haiku-4-5-20251001 \
  --allowedTools "" \
  --output-format json
```

**Use `--allowedTools ""` for pure-prompt tasks:**
When Claude doesn't need any tools (just input text → output text), passing an empty
allowedTools list prevents tool calls entirely — faster and cheaper.

**Batch similar tasks:**
Instead of one claude invocation per file, consolidate:
```bash
# Expensive: N invocations
for f in *.py; do claude -p "lint $f" ...; done

# Better: one invocation, batch prompt
FILES=$(ls *.py | tr '\n' ' ')
claude -p "Lint all of these files for style issues: $FILES" ...
```

---

## 5. `availableModels` (Enterprise / Team)

Administrators can restrict which models team members can select:

```json
{
  "availableModels": ["haiku", "sonnet"]
}
```

This prevents accidental Opus usage in high-volume workflows. Accepts family aliases
(`"opus"`, `"sonnet"`, `"haiku"`) or full model IDs.

---

## Key Lessons

- Haiku handles ~80% of structured/extraction tasks well — try it first
- Context size matters more than model choice for cost — compact and scope aggressively
- CLAUDE.md and MEMORY.md are loaded every session — keep them lean
- `--allowedTools ""` for pure-prompt headless tasks disables tool overhead entirely
- Never let CI default to Sonnet/Opus — always pin `--model` explicitly
- The status bar cost display is the fastest feedback loop for cost awareness
