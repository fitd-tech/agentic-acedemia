# Experiment: Parallel File Analysis

Demonstrates the fan-out/fan-in subagent pattern: spawn N subagents in parallel,
each analyzing one file, then synthesize the results in the main context.

## What Was Built

Spawned 4 background subagents (one per hook script) in a single message, waited
for all 4 to complete, then synthesized their structured output into a summary.

## The Pattern

```
Main agent
  ├── Agent(edit-logger.sh)    ─┐
  ├── Agent(secret-scanner.sh)  │ all launched in one message
  ├── Agent(commit-normalizer)  │ run_in_background: true
  └── Agent(dry-run-injector) ─┘
           ↓  (all complete)
  Synthesize results in main context
```

## Synthesis: Hook Script Analysis

| Hook | Type | Matcher | Mechanism |
|------|------|---------|-----------|
| edit-logger | PostToolUse | Edit, Write, NotebookEdit | Appends JSONL audit record — observe only, cannot block |
| secret-scanner | PreToolUse | Bash | Regex-matches secret patterns, blocks on match |
| commit-normalizer | PreToolUse | Bash (git commit) | Validates conventional commit format, blocks on mismatch |
| dry-run-injector | PreToolUse | Bash (git clean, rsync) | Rewrites command to inject `--dry-run` flag |

**Patterns across all hooks:**
- PreToolUse = enforce/transform. PostToolUse = observe/log.
- All parse `tool_name` + `tool_input` from stdin JSON.
- Block returns `{ "decision": "block", "reason": "..." }`, modify returns `{ "tool_input": { ... } }`, allow returns `{}`.

## Why Use Subagents Here

Each hook is self-contained — the analyses are fully independent. Without subagents,
you'd read and analyze each file sequentially (4 round trips). With parallel subagents,
all 4 complete in roughly the time of 1.

The results are also scoped: each subagent reads one file and returns a compact
summary. The main context never sees the raw file contents — only the summaries.
This is context window protection as a side effect of fan-out.

## Key Lessons

1. **Launch parallel agents in one message** — put all `Agent` tool calls in the
   same response to get true parallelism. Sequential messages = sequential execution.

2. **`run_in_background: true` is required for parallelism** — without it, each
   agent blocks until complete before the next launches.

3. **Fan-in happens naturally** — you wait for all notifications, then synthesize.
   No explicit join mechanism needed; notifications arrive as tasks complete.

4. **Subagents don't share context** — each agent starts fresh. Pass all needed
   context in the prompt (file paths, instructions, output format).

5. **Context protection is a side effect** — the main agent never sees raw file
   contents, only the summaries each subagent returned. Useful for large files.
