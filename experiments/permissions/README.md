# Permission Modes

Permission control in Claude Code operates at three levels, applied in this order:
managed settings → user settings → project settings → local settings → CLI flags.

More restrictive rules always win — a deny in any layer blocks the tool regardless of
allows elsewhere.

---

## 1. CLI Flags (per-session)

Restrict or expand tools for a single session without touching any config file.

```bash
# Allow only Read and Glob — no writes, no bash
claude --allowedTools "Read,Glob"

# Allow everything except Bash
claude --disallowedTools "Bash"

# Headless audit: read-only, structured output
claude -p "audit the hooks in experiments/hooks/" \
  --allowedTools "Read,Glob,Grep" \
  --output-format json \
  --model claude-haiku-4-5-20251001
```

**Syntax:** comma-separated tool names. Match exact tool names as shown in Claude Code
(e.g. `Bash`, `Read`, `Write`, `Edit`, `Glob`, `Grep`, `WebFetch`, `Agent`).

**When to use:**
- One-off read-only sessions (`--allowedTools "Read,Glob,Grep"`)
- CI steps that should never write files
- Demos or pair sessions where you want guardrails without permanent config

---

## 2. Settings-Based Permissions (`permissions` key)

Persistent rules applied every session. Supports tool-level and path-level granularity.

### Rule syntax

```
ToolName                  # any use of that tool
ToolName(path/to/file)    # tool on a specific path
ToolName(path/*)          # tool on any file matching glob
Bash(git *)               # Bash commands matching a pattern
```

### Example: project-level restrictions

```json
{
  "permissions": {
    "allow": [
      "Read",
      "Glob",
      "Grep",
      "Edit(experiments/*)",
      "Write(experiments/*)",
      "Bash(git *)",
      "Bash(bash experiments/*)"
    ],
    "deny": [
      "Bash(rm *)",
      "Bash(curl *)",
      "Bash(brew *)"
    ],
    "ask": [
      "Write(~/.claude/*)"
    ]
  }
}
```

**`allow`** — auto-approve these without prompting the user
**`deny`** — block these entirely (user cannot approve even if prompted)
**`ask`** — always prompt even in bypass-permissions mode

### Path-level allow example

Useful in a monorepo: let Claude freely edit its own experiment dir but always prompt
for anything in shared config:

```json
"allow": ["Edit(experiments/permissions/*)", "Write(experiments/permissions/*)"],
"ask":   ["Edit(.claude/*)", "Write(.claude/*)"]
```

---

## 3. `defaultMode` — Session Posture

Controls the overall permission prompting behavior for a session.

| Mode | Behavior |
|------|----------|
| `default` | Prompts for each potentially dangerous action |
| `acceptEdits` | Auto-approves file edits; prompts for Bash |
| `bypassPermissions` | Auto-approves everything (dangerous — use in CI only) |
| `plan` | Read-only planning mode; no writes or execution |
| `dontAsk` | Like bypassPermissions but set via flag |

```json
{
  "permissions": {
    "defaultMode": "acceptEdits"
  }
}
```

Via CLI: `claude --dangerously-skip-permissions` (equivalent to `bypassPermissions`)

**`plan` mode** is the safest for exploration — Claude can read the full codebase and
propose a plan, but cannot execute it. Run with:
```bash
claude --permission-mode plan
```

---

## 4. `additionalDirectories`

By default, Claude Code only has permission to operate within the project root.
`additionalDirectories` grants access to paths outside it.

```json
{
  "permissions": {
    "additionalDirectories": ["~/dotfiles", "/tmp/scratch"]
  }
}
```

Useful when a project legitimately needs to read or write outside its root
(e.g., updating `~/.claude/statusline.sh` from within this repo).

---

## Key Lessons

- **Deny beats allow** — a deny in any settings layer blocks regardless of upstream allows
- **`ask` survives `bypassPermissions`** — it's the only way to force a prompt even in headless/CI
- **CLI flags are additive restrictions** — they narrow permissions set in settings, never expand them
- **Tool names are exact** — `bash` won't match `Bash`; check the tool name in Claude Code UI
- **Path patterns use glob syntax** — `experiments/*` matches one level; `experiments/**` matches recursively
- **`plan` mode is underused** — great for reviewing a large codebase before committing to changes
- **`bypassPermissions` should only appear in project/managed settings for CI** — not user settings
