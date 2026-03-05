# Subagent Experiments

Deeper patterns for subagent orchestration, including worktree isolation.

## Experiments

1. **[parallel-analysis/](parallel-analysis/)** — fan-out 4 subagents to analyze hook scripts in parallel, synthesize results
2. **[context-protection/](context-protection/)** — subagent reads 90-line noisy build log, returns 30-line structured summary; raw file never enters main context
3. **[worktree-isolation/](worktree-isolation/)** — two concurrent worktree agents; reveals that `isolation: "worktree"` gives repo isolation, not permission elevation

## Suggested Starting Points

1. **Parallel file analysis** — spawn N subagents to analyze N files simultaneously
2. **Worktree isolation** — two subagents editing the same repo without conflicts
3. **Context protection** — use a subagent to summarize a large file before returning results to main
