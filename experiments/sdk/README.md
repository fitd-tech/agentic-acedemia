# Claude Agent SDK Experiments

Programmatic Claude Code via Python or TypeScript.

## Experiments

*None yet — add one to get started.*

## Suggested Starting Points

1. **Basic query loop** — minimal Python script using the Agent SDK
2. **Programmatic hooks** — define hooks as Python callbacks instead of shell scripts
3. **Session continuity** — resume a previous session by ID across multiple script invocations

## Quick Start (Python)

```python
from claude_agent_sdk import query, ClaudeAgentOptions
import asyncio

async def main():
    async for message in query(
        prompt="List the files in the current directory",
        options=ClaudeAgentOptions(allowed_tools=["Bash"]),
    ):
        print(message)

asyncio.run(main())
```

## Resources

- [Agent SDK overview](https://platform.claude.com/docs/en/agent-sdk/overview)
