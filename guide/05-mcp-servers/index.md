# MCP Servers

Model Context Protocol servers extend Claude Code with external tools and data sources.
You already know the basics — this section focuses on production patterns.

## Status

> Work in progress.

## What MCP Enables

- Connect Claude to databases, APIs, file systems, and services
- Share tool configurations across team members via committed config
- Build internal tooling that Claude can use as first-class tools

## Configuration

MCP servers are configured in `.claude/settings.json` and can be scoped
to a project (committable) or globally (`~/.claude/settings.json`).

## Resources

- [MCP documentation](https://modelcontextprotocol.io/)
- [Claude Code MCP setup](https://code.claude.com/docs/en/)
