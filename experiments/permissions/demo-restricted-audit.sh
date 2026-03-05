#!/usr/bin/env bash
# Demonstrates CLI permission flags by running a read-only headless audit
# of the hooks directory using only Read, Glob, and Grep tools.
#
# Usage: bash experiments/permissions/demo-restricted-audit.sh

set -euo pipefail

REPO_ROOT=$(git rev-parse --show-toplevel)

echo "Running read-only audit with --allowedTools Read,Glob,Grep ..."
echo ""

# Unset CLAUDECODE so nested claude invocation is allowed
CLAUDECODE="" claude \
  --allowedTools "Read,Glob,Grep" \
  --model claude-haiku-4-5-20251001 \
  --output-format json \
  -p "You are auditing the hooks in experiments/hooks/ of this repo.
List each hook script, its hook type (PreToolUse/PostToolUse), and one sentence
describing what it does. Output as a JSON array with keys: file, hook_type, description.
Do not write or modify any files." \
  2>/dev/null | jq '.result' -r 2>/dev/null || echo "(Run outside a Claude Code session to avoid CLAUDECODE restriction)"
