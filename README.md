# Gemini Project Assets

## Why This Exists

AI coding agents can go off the rails when they are given vague instructions, stale assumptions, or too much freedom to improvise. These files give Gemini a tighter operating manual: check current sources before using APIs, keep work inside the project, verify frontend accessibility, and prove iOS changes with real builds and simulator evidence.

The continuity file is there to keep the agent from losing the plot. Each project gets its own `.agent/CONTINUITY.md`, where Gemini records the current plan, important decisions, discoveries, and outcomes in a short factual log. That way a later session can pick up the actual state of the work instead of guessing from old chat context.

MCP servers are tool connections. Context7 gives Gemini current library and API documentation, Apple docs gives it current Apple framework references, and XcodeBuildMCP lets it build, launch, inspect, and test iOS apps in the simulator. The project instructions require Gemini to use those tools directly when the task depends on them, instead of relying on memory.

The goal is simple: make Gemini behave more like a careful project contributor and less like a chatbot with shell access.

This repository is a portable set of Gemini CLI project files. It is meant to be copied into an existing codebase, not used as the application repo itself.

## What To Copy

- `GEMINI.md`: root Gemini operating instructions.
- `.gemini/`: Gemini project settings, MCP server registrations, environment example, and skill files.
- `.xcodebuildmcp/`: focused XcodeBuildMCP workflow configuration for iOS projects.

Do not copy `.agent/CONTINUITY.md` from this repo. Continuity is project-local state; the destination project should create and maintain its own file.

## Add To An Existing Project

The easiest path is the installer script:

```sh
./install-gemini-assets.sh /path/to/your/existing/project
```

By default, the script skips files that already exist in the destination. To overwrite destination files intentionally:

```sh
./install-gemini-assets.sh --force /path/to/your/existing/project
```

Review existing `GEMINI.md` and `.gemini/settings.json` before using `--force`, because those files often contain project-specific rules.

### Manual Copy

From this repo, set the destination project path and copy the assets:

```sh
DEST="/path/to/your/existing/project"

rsync -av GEMINI.md .gemini .xcodebuildmcp "$DEST"/
```

If the destination already has `GEMINI.md` or `.gemini/settings.json`, do not overwrite them without review. Merge these instructions into the existing files so project-specific rules remain intact.

## After Copying

From the destination project:

```sh
gemini
```

For headless, temp-directory, or CI-style runs, trust the workspace for the process so Gemini loads project MCP servers:

```sh
GEMINI_CLI_TRUST_WORKSPACE=true gemini --skip-trust --yolo --prompt "..."
```

Without `GEMINI_CLI_TRUST_WORKSPACE=true`, Gemini may run core tools but suppress MCP servers in untrusted folders, causing Context7, Apple docs, or XcodeBuildMCP tool calls to appear unavailable.

Inside Gemini CLI, run:

```text
/memory show
```

Confirm that the destination project's `GEMINI.md` is loaded. Then ask Gemini to use Context7 for a library lookup to verify Context7 starts automatically.

Also confirm Gemini creates or reads the destination project's own `.agent/CONTINUITY.md`. It should not contain this repo's build history.

Confirm Gemini's MCP servers are connected:

```sh
gemini mcp list
```

The expected servers are `context7`, `apple-docs`, and `xcodebuildmcp`. The instructions use Gemini's fully qualified MCP tool names, such as `mcp_context7_resolve-library-id` and `mcp_apple-docs_search_apple_docs`. Built-in subagents are disabled so required source-gate and build work uses the main session's tools.

For frontend/UI projects, run a small verification prompt before relying on the setup:

```text
Create a one-file accessible under-construction page. Before editing, show the frontend source gate evidence.
```

Confirm Gemini reports a timestamp, reads continuity, performs a W3C/WAI accessibility standards lookup, and performs Context7 or official upstream docs lookup for any frontend platform or library details it uses. A plain HTML/CSS page still needs official web platform docs lookup; "no external libraries" is not enough. If those lookups do not happen before frontend file edits, treat the setup as failing.

## Notes

- Context7 is configured to install/run on demand with `npx -y @upstash/context7-mcp@latest`.
- Node.js/npm must be available for the MCP servers that use `npx`.
- Do not commit real API keys. Use `.gemini/.env.example` only as a template.
- Keep any copied files project-local and adapt the instructions when the destination is not an iOS project.
