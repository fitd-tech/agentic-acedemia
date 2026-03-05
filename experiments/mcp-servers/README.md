# MCP Servers

MCP (Model Context Protocol) is an open standard for connecting Claude to external tools,
databases, APIs, and file systems. Each MCP server exposes a set of tools that Claude can
call just like built-in tools (Read, Bash, etc.).

---

## How MCP Works

```
Claude Code  ──────►  MCP Server (stdio or HTTP/SSE)  ──────►  External System
                       (your DB, filesystem, Slack, etc.)
```

The server runs as a subprocess (stdio transport) or a remote service (HTTP/SSE transport).
Claude discovers its tools at session start via the MCP protocol handshake.

---

## Config Locations

### Project-level: `.mcp.json`

Checked into the repo — shared with the team. Claude Code prompts each user to approve
servers from `.mcp.json` before connecting.

```json
// .mcp.json  (this repo's actual config)
{
  "mcpServers": {
    "filesystem": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/path/to/project"]
    }
  }
}
```

### User-level: `~/.claude/settings.json`

Add `mcpServers` under a top-level key — available across all your projects.
Use for personal servers (your local DB, private APIs) that aren't team-shared.

```json
// ~/.claude/settings.json
{
  "mcpServers": {
    "my-db": {
      "type": "stdio",
      "command": "node",
      "args": ["/path/to/my-db-mcp-server.js"]
    }
  }
}
```

---

## Transport Types

### stdio (most common)

Claude Code spawns the server as a child process. Communication over stdin/stdout.

```json
{
  "type": "stdio",
  "command": "npx",
  "args": ["-y", "@modelcontextprotocol/server-filesystem", "/allowed/path"],
  "env": { "MY_API_KEY": "..." }
}
```

### HTTP / SSE (remote servers)

Connect to a server running elsewhere (local port or remote URL).

```json
{
  "type": "sse",
  "url": "http://localhost:3000/sse"
}
```

---

## Approval Flow

Claude Code requires explicit approval before connecting to any MCP server from `.mcp.json`.
This is a one-time prompt per server per project.

**Auto-approve all project servers** (trust the whole team's `.mcp.json`):
```json
// .claude/settings.json
{ "enableAllProjectMcpServers": true }
```

**Approve specific servers by name** (granular):
```json
// .claude/settings.json
{ "enabledMcpjsonServers": ["filesystem", "github"] }
```

**Enterprise: restrict which servers can be used:**
```json
// managed-settings.json
{
  "allowedMcpServers": [
    { "serverName": "filesystem" }
  ]
}
```

---

## The Filesystem Server (working example)

The `@modelcontextprotocol/server-filesystem` server exposes directory read/write
operations as MCP tools. It's the canonical first server to wire up.

**Config in this repo** (`.mcp.json`):
```json
{
  "mcpServers": {
    "filesystem": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem",
               "/Users/anthonypelusocook/agentic-acedemia"]
    }
  }
}
```

**Tools it exposes:**
- `read_file` / `read_multiple_files`
- `write_file` / `edit_file`
- `list_directory` / `directory_tree`
- `search_files`
- `get_file_info`
- `create_directory` / `move_file` / `delete_file`

**Why use it when Claude Code already has Read/Write/Glob?**
MCP servers are tool-agnostic — they work in any MCP-compatible client (not just Claude
Code). The filesystem server is useful for: shared tooling across MCP clients, restricted
path allowlists enforced at the server level, and as a reference implementation for
building custom servers.

---

## Building a Custom MCP Server

The fastest path is the TypeScript or Python SDK:

```bash
# TypeScript
npm init -y && npm install @modelcontextprotocol/sdk

# Python
pip install mcp
```

Minimal TypeScript server skeleton:
```typescript
import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";

const server = new Server({ name: "my-server", version: "1.0.0" }, {
  capabilities: { tools: {} }
});

server.setRequestHandler(ListToolsRequestSchema, async () => ({
  tools: [{
    name: "my_tool",
    description: "Does something useful",
    inputSchema: { type: "object", properties: { input: { type: "string" } } }
  }]
}));

server.setRequestHandler(CallToolRequestSchema, async (req) => {
  if (req.params.name === "my_tool") {
    return { content: [{ type: "text", text: `Got: ${req.params.arguments.input}` }] };
  }
  throw new Error("Unknown tool");
});

const transport = new StdioServerTransport();
await server.connect(transport);
```

---

## Governance in Settings

| Setting | Layer | Effect |
|---------|-------|--------|
| `enableAllProjectMcpServers: true` | Project/User | Auto-approve all `.mcp.json` servers |
| `enabledMcpjsonServers: ["name"]` | Project/User | Approve specific servers by name |
| `disabledMcpjsonServers: ["name"]` | Project/User | Block specific servers |
| `allowedMcpServers: [{serverName}]` | Managed | Enterprise allowlist |
| `deniedMcpServers: [{serverName}]` | Managed | Enterprise blocklist (beats allowlist) |

---

## Key Lessons

- `.mcp.json` is project-scoped and committed — the team config for shared servers
- User-level MCP servers go in `~/.claude/settings.json` under `mcpServers`
- Each user must approve `.mcp.json` servers unless `enableAllProjectMcpServers: true`
- stdio transport = local subprocess; SSE/HTTP = remote service
- MCP tools appear alongside built-in tools — Claude selects them naturally
- The `env` field in server config is how you pass secrets (API keys) to servers
- Custom servers are ~50 lines of TypeScript using the official SDK
- MCP servers enforce their own access controls — the filesystem server's path argument
  is the allowlist; it refuses requests outside that directory
