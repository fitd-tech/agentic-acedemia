# Developer Workflows

Step-by-step patterns for common development tasks with Claude Code. Each section shows the workflow, example prompts, and tips learned from practice.

For foundational concepts (context window, plan mode, model selection), see [Workflow & Sessions](../00-workflow/index.md).

---

## 1. Setting Up a New Project

Get Claude Code configured for a new codebase in five minutes.

### Steps

1. **Create `CLAUDE.md`** at the project root. Describe the tech stack, build commands, project structure, and conventions. This is the single highest-leverage file — Claude reads it every session.
2. **Create `.claude/settings.json`** with your model preference and hooks.
3. **Copy hooks** to `.claude/hooks/` — at minimum, the secret scanner and commit normalizer.
4. **Add slash commands** to `.claude/commands/` — `/commit`, `/review`, and `/test` cover daily work.
5. **Configure `.mcp.json`** if you need filesystem or other MCP server access.
6. **Update `.gitignore`** — add `.claude/settings.local.json` and `.claude/edit-log.jsonl`.

### Example Prompt

```
Read this codebase and help me write a CLAUDE.md. Include the tech stack,
build commands, project structure, and any conventions you can infer from
the existing code.
```

### Tips

- Use the [starter templates](../../templates/) to skip boilerplate — copy and customize.
- The `/setup` slash command automates this entire process: run `/setup` in any project.
- Keep `CLAUDE.md` under 150 lines. Move detailed context into `.claude/skills/` files.

---

## 2. Planning Application Structure

Use plan mode for architecture decisions before writing any code.

### Steps

1. Enable plan mode: `/plan`
2. Describe what you want to build — goals, constraints, target users.
3. Claude explores the codebase (if existing) and proposes an architecture.
4. Review, ask questions, request changes.
5. Approve the plan — Claude exits plan mode and begins implementation.

### Example Prompt

```
/plan

I want to add a REST API to this project. It should have endpoints for
CRUD operations on users and posts. Use the existing database models.
I want input validation and proper error responses.
```

### Tips

- Append `ultrathink` to the prompt for genuinely complex architectural decisions.
- Plan mode prevents edits — you can explore freely without risk.
- For large plans, ask Claude to write the plan to a file so you can reference it later.

---

## 3. Scaffolding an Application

Generate an initial codebase from a plan or description.

### Steps

1. Start with a plan (section 2) or a detailed description of what you want.
2. Ask Claude to implement the plan, specifying the file structure you want.
3. Review the generated files — check structure, naming, and key logic.
4. Run the build and fix any issues.
5. Commit the scaffold: `/commit initial scaffold`

### Example Prompt

```
Implement the plan. Create the directory structure first, then implement
each module. Start with the data models, then the API routes, then the
tests.
```

### Tips

- Be explicit about directory structure if you have preferences.
- Ask for tests alongside the implementation, not as a follow-up.
- Review the first file carefully — Claude will follow the same patterns for the rest.

---

## 4. Adding New Features

The daily development loop: plan, implement, review, test, commit.

### Steps

1. Describe the feature. If it touches more than 2-3 files, start with `/plan`.
2. Let Claude implement. Watch for confirmation prompts on file edits.
3. Review the diff: `git diff`
4. Run tests to verify nothing broke.
5. Run `/review` on the new code.
6. Commit: `/commit feat(scope): description`

### Example Prompt

```
Add rate limiting to the API endpoints. Use a sliding window algorithm
with configurable limits per route. Store counters in Redis.
```

### Tips

- One feature per session keeps context clean.
- If the feature is large, break it into sub-tasks and commit after each one.
- Use `/compact` mid-session if context pressure builds up.

---

## 5. Setting Up Tests

Both test-first and test-after patterns.

### Test-First (TDD)

```
Write failing tests for the UserService.create method. It should:
- Create a user with valid input
- Reject duplicate emails
- Hash the password before storing
Do not implement the method yet.
```

Then after tests are written:

```
Now implement UserService.create to make these tests pass.
```

### Test-After

```
Write tests for src/services/auth.ts. Cover the happy path and edge
cases. Look at the implementation to understand what to test.
```

### Tips

- Specify the test framework if the project uses a non-default one.
- Ask for edge cases explicitly — Claude tends toward happy-path tests unless directed.
- The `/test` slash command detects your test runner and reports results.

---

## 6. Fixing Bugs

Start from the symptom, not the suspected cause.

### Steps

1. Paste the error message, stack trace, or describe the symptom.
2. Let Claude investigate — it will read files, trace the logic, and identify the root cause.
3. Review the proposed fix before approving.
4. Ask Claude to write a regression test for the bug.
5. Run the test suite to verify the fix and check for regressions.
6. Commit: `/commit fix(scope): description`

### Example Prompt

```
When I submit the login form with a valid email and password, I get a
500 error. Here's the server log:

TypeError: Cannot read property 'id' of null
    at AuthController.login (src/controllers/auth.ts:42:28)
```

### Tips

- Paste the actual error — don't paraphrase. Claude works best with exact messages.
- If the bug is intermittent, describe the conditions that reproduce it.
- Always ask for a regression test. Bugs that get fixed without tests get reintroduced.

---

## 7. Code Review

Three ways to get a review: slash command, PR-based, and CI automation.

### Slash Command

```
/review src/services/auth.ts
```

Reviews a specific file for correctness, security, clarity, and simplicity.

### PR-Based

```bash
claude --from-pr 42
```

Loads the PR diff and context, then ask:

```
Review this PR. Focus on security and correctness.
```

### CI Automation

Add a GitHub Actions workflow that runs Claude on every PR push. See [GitHub Actions](../06-github-actions/index.md) for the workflow template.

### Tips

- Use `--from-pr` for the richest review context — Claude sees the diff, commit messages, and surrounding code.
- For security-focused reviews, switch to Opus: press `Alt+P` and select Opus before reviewing.

---

## 8. Refactoring

Plan mode + incremental changes + test verification.

### Steps

1. Enable plan mode: `/plan`
2. Describe the refactoring goal and constraints.
3. Review the plan — check that tests will be preserved or updated.
4. Approve and let Claude execute incrementally.
5. Run tests after each logical step.
6. Commit after each step with a descriptive message.

### Example Prompt

```
/plan

Refactor the auth module to use the repository pattern. Currently the
database queries are inline in the controller. Extract them to a
UserRepository class. Keep all existing tests passing.
```

### Tips

- Never refactor and add features in the same session. One concern at a time.
- Run tests after each file change, not just at the end.
- If tests break mid-refactor, fix them before continuing — don't accumulate failures.

---

## 9. Working with Large Codebases

Orientation and exploration strategies for unfamiliar code.

### Orientation Session

Start a new session focused on understanding, not changing:

```
I'm new to this codebase. Give me an architectural overview: main entry
points, key modules, data flow, and any patterns or conventions I should
know about.
```

### Targeted Exploration with Subagents

For deep dives without flooding your main context, use subagents:

```
Use a subagent to analyze all the API route handlers in src/routes/ and
give me a summary of the endpoints, their HTTP methods, and what
middleware they use.
```

The subagent reads the files and returns a summary — the raw file contents never enter your main context window. See [Subagents](../03-subagents/index.md) for more patterns.

### Tips

- Start with `CLAUDE.md` and `README.md` if they exist — they're the fastest orientation.
- Use `/compact` after the orientation phase to free context for actual work.
- For very large codebases, focus on one module per session.

---

## 10. Starter Configuration Files

Ready-to-use templates for bootstrapping Claude Code in any project.

| Template | Purpose | Docs |
|----------|---------|------|
| [`CLAUDE.md`](../../templates/CLAUDE.md) | Project context file with placeholder sections | [CLAUDE.md Engineering](../01-claude-md/index.md) |
| [`settings.json`](../../templates/settings.json) | Project settings with model + hooks wired | [Settings Hierarchy](../../experiments/settings-hierarchy/README.md) |
| [`settings.local.json`](../../templates/settings.local.json) | Personal overrides (gitignored) | [Settings Hierarchy](../../experiments/settings-hierarchy/README.md) |
| [`user-settings.json`](../../templates/user-settings.json) | User-level settings for `~/.claude/settings.json` | [Settings Hierarchy](../../experiments/settings-hierarchy/README.md) |
| [`mcp.json`](../../templates/mcp.json) | MCP filesystem server starter | [MCP Servers](../05-mcp-servers/index.md) |
| [`commands/commit.md`](../../templates/commands/commit.md) | `/commit` slash command | [Custom Commands](../../.claude/commands/) |
| [`commands/review.md`](../../templates/commands/review.md) | `/review` slash command | [Custom Commands](../../.claude/commands/) |
| [`commands/test.md`](../../templates/commands/test.md) | `/test` slash command | [Custom Commands](../../.claude/commands/) |
| [`hooks/secret-scanner.sh`](../../templates/hooks/secret-scanner.sh) | Block commands exposing secrets | [Hooks](../02-hooks/index.md) |
| [`hooks/commit-normalizer.sh`](../../templates/hooks/commit-normalizer.sh) | Enforce conventional commits | [Hooks](../02-hooks/index.md) |
| [`hooks/edit-logger.sh`](../../templates/hooks/edit-logger.sh) | Log file edits to JSONL | [Hooks](../02-hooks/index.md) |

See [`templates/README.md`](../../templates/README.md) for copy instructions and customization notes.
