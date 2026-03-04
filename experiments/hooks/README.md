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

#### When This Hook Is (and Isn't) Appropriate

**Blocks are for irreversible or dangerous actions in your context.** For a local solo
project, `echo $API_KEY` in a terminal you control carries little real risk. Blocking
it here is overcautious — the hook is most valuable as a learning artifact.

The same pattern applied to a **team project or CI environment** is genuinely important:
a secret echoed in GitHub Actions logs is exposed to anyone with repo access, and
`echo $TOKEN` in a committed workflow is a real credential leak vector.

**Practical rule of thumb:**

| Context | Right tool |
|---------|-----------|
| Local solo project | `PostToolUse` log (observe, don't block) |
| Shared team repo | `PreToolUse` block (enforce for everyone) |
| CI/CD pipeline | `PreToolUse` block (logs are often retained and visible) |

For this project specifically, an **edit logger** (`PostToolUse`) would be a more
proportionate use of hooks than a secret blocker.

## Suggested Next Experiments

- **Edit logger** — `PostToolUse` hook that appends every file edit to a local audit log
- **Commit normalizer** — `PreToolUse` hook that enforces conventional commit format
- **Dry-run injector** — `PreToolUse` hook that adds `--dry-run` to destructive commands
