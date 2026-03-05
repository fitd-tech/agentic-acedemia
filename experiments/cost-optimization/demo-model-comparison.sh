#!/usr/bin/env bash
# Demonstrates model selection by running the same structured extraction task
# on Haiku and Sonnet, printing cost from each response.
#
# Usage: bash experiments/cost-optimization/demo-model-comparison.sh
# Must be run outside a Claude Code session (CLAUDECODE env var blocks nested calls).

set -euo pipefail

PROMPT='List the hook scripts in experiments/hooks/ as a JSON array.
Each element: { "file": "<filename>", "hook_type": "<PreToolUse|PostToolUse>", "one_line": "<what it does>" }.
Output only the JSON array, no other text.'

echo "=== Haiku ==="
HAIKU_RESULT=$(CLAUDECODE="" claude \
  --allowedTools "Glob,Read" \
  --model claude-haiku-4-5-20251001 \
  --output-format json \
  -p "$PROMPT" 2>/dev/null)
echo "$HAIKU_RESULT" | jq '{model: .model, cost_usd: .cost_usd, result: (.result | fromjson? // .result)}'

echo ""
echo "=== Sonnet ==="
SONNET_RESULT=$(CLAUDECODE="" claude \
  --allowedTools "Glob,Read" \
  --model claude-sonnet-4-6 \
  --output-format json \
  -p "$PROMPT" 2>/dev/null)
echo "$SONNET_RESULT" | jq '{model: .model, cost_usd: .cost_usd, result: (.result | fromjson? // .result)}'
