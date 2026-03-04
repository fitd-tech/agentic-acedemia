#!/usr/bin/env bash
# Hook: PreToolUse
# Experiment: Commit Normalizer
#
# Blocks git commit commands whose messages don't follow conventional commit format:
#   type(scope): description
#   type: description
#
# Valid types: feat, fix, chore, docs, style, refactor, test, perf, ci, build, revert
#
# Claude Code sends JSON to stdin:
#   { "tool_name": "Bash", "tool_input": { "command": "git commit -m \"...\"" } }

INPUT=$(cat)
TOOL=$(echo "$INPUT" | jq -r '.tool_name')

# Only inspect Bash commands
if [ "$TOOL" != "Bash" ]; then
  echo '{}'
  exit 0
fi

COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command')

# Only act on git commit commands
if ! echo "$COMMAND" | grep -q 'git commit'; then
  echo '{}'
  exit 0
fi

# Extract the commit message from -m "..." or -m '...'
MSG=$(echo "$COMMAND" | sed -n "s/.*-m ['\"]\\(.*\\)['\"].*/\\1/p" | head -1)

# If we can't parse a -m message (e.g. interactive commit), let it through
if [ -z "$MSG" ]; then
  echo '{}'
  exit 0
fi

# Strip Co-Authored-By trailer lines before checking the subject
SUBJECT=$(echo "$MSG" | head -1)

TYPES="feat|fix|chore|docs|style|refactor|test|perf|ci|build|revert"
PATTERN="^($TYPES)(\([a-zA-Z0-9_/-]+\))?: .+"

if echo "$SUBJECT" | grep -Eiq "$PATTERN"; then
  echo '{}'
else
  REASON="Commit message does not follow conventional commit format.

Subject: \"$SUBJECT\"

Required format:  type(scope): description
                  type: description

Valid types: feat, fix, chore, docs, style, refactor, test, perf, ci, build, revert

Examples:
  feat: add login page
  fix(auth): handle expired tokens
  chore: update dependencies"

  echo "{\"decision\": \"block\", \"reason\": $(echo "$REASON" | jq -Rs .)}"
fi
