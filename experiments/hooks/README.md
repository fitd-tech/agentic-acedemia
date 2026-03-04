# Hooks Experiments

## Completed

### Secret Scanner (`secret-scanner.sh`)

A `PreToolUse` hook that intercepts Bash tool calls and blocks commands that
appear to expose secrets.

**What it blocks:**
- `echo $API_KEY` — echoing env vars with secret-like names
- `cat .env` — reading `.env` / credential files
- `curl -H "Authorization: Bearer ..."` — authenticated HTTP requests
- `env` / `printenv` — printing all environment variables

**What it allows:**
- All non-Bash tools (Read, Write, Edit, etc.)
- Bash commands with no secret-like patterns

**Wired in:** `.claude/settings.json` under `PreToolUse` → `Bash` matcher

#### What Was Learned

1. **The hook contract is stdin/stdout JSON.** Claude writes `{ "tool": "...", "input": {...} }`
   to stdin. Return `{}` to allow, or `{ "decision": "block", "reason": "..." }` to block.

2. **`PreToolUse` fires before anything happens** — it's the right place for governance.
   `PostToolUse` is for observation, not prevention.

3. **Use `grep -Eiq --`** — the `--` is required when patterns start with `-` (like `-H`)
   to prevent grep from treating the pattern as a flag. macOS BSD grep respects this.

4. **Matchers scope hooks to specific tools.** The `"matcher": "Bash"` in `settings.json`
   means this script only runs for Bash calls — no overhead on Read/Write/etc.

5. **Shell state doesn't persist between Claude Code tool calls.** Each Bash invocation
   is a fresh shell. Avoid relying on variables set in previous calls.

## Suggested Next Experiments

- **Edit logger** — `PostToolUse` hook that appends every file edit to a local audit log
- **Commit normalizer** — `PreToolUse` hook that enforces conventional commit format
- **Dry-run injector** — `PreToolUse` hook that adds `--dry-run` to destructive commands
