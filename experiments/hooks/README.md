# Hooks Experiments

Hands-on experiments for learning the hooks system.

## Experiments

*None yet — add one to get started.*

## Suggested Starting Points

1. **Secret scanner** — a `PreToolUse` hook that blocks Bash commands containing common secret patterns
2. **Edit logger** — a `PostToolUse` hook that logs every file edit to a local file
3. **Commit normalizer** — a `PreToolUse` hook that enforces conventional commit format
4. **Dry-run injector** — a `PreToolUse` hook that adds `--dry-run` to destructive shell commands

## Hook Script Template

```bash
#!/usr/bin/env bash
# Hook: PreToolUse
# Purpose: [describe what this enforces]
#
# Receives JSON on stdin:
# { "tool": "Bash", "input": { "command": "..." } }
#
# Returns on stdout:
# {} = allow
# { "decision": "block", "reason": "..." } = block
# { "input": { ... } } = allow with modified input

INPUT=$(cat)
TOOL=$(echo "$INPUT" | jq -r '.tool')
# ... your logic here
echo '{}'
```
