# Gemini CLI Setup

This directory is part of a portable Gemini CLI asset bundle. To install the bundle into another codebase, use the root `README.md` copy instructions first, then use this file to verify the Gemini setup from inside the destination project.

This project is configured for Gemini CLI with:

- `GEMINI.md` as the root instruction file.
- `.gemini/settings.json` as project-local Gemini settings.
- Context7 MCP registered as `context7`. In this repo, "code7" means Context7.
- Apple documentation MCP registered as `apple-docs` for Swift, SwiftUI, UIKit, and Apple framework lookup.
- XcodeBuildMCP registered as `xcodebuildmcp` for iOS build, test, simulator, Swift package, and UI automation workflows.
- `.gemini/skills/accessibility.md` imported by `GEMINI.md` for WCAG-focused UI work.
- `.gemini/skills/ios-development.md` imported by `GEMINI.md` for iOS/Xcode workflow discipline.
- `.xcodebuildmcp/config.yaml` keeps the Xcode tool surface focused to save context.
- `.agent/CONTINUITY.md` is the required persistent briefing Gemini should read and maintain.
- Built-in Gemini subagents are disabled in `.gemini/settings.json` so required source-gate, MCP documentation, build, and simulator work happens in the main session where the configured tools are available.

The Context7 MCP is intentionally configured with `npx -y @upstash/context7-mcp@latest`, so Gemini can download and run it automatically when a task needs current library/API docs. If the `context7` server is missing or stale, use that command from `.gemini/settings.json` on demand instead of asking for manual setup, unless Node.js/npm is unavailable or the command fails.

## Run

From this directory:

```sh
gemini
```

For headless, temp-directory, or CI-style runs, trust the workspace for that process so Gemini does not suppress project MCP servers:

```sh
GEMINI_CLI_TRUST_WORKSPACE=true gemini --skip-trust --yolo --prompt "..."
```

If this environment variable is omitted in an untrusted folder, `gemini mcp list` can show configured servers as disabled and tool calls such as `mcp_context7_resolve-library-id` or `mcp_apple-docs_search_apple_docs` will be unavailable.

If Gemini CLI is not installed, install it using the current official Gemini CLI documentation. Do not rely on old install commands from memory.

## Optional Context7 API Key

Context7 works without committing secrets. For higher rate limits, set an environment variable before starting Gemini:

```sh
export CONTEXT7_API_KEY="your_key_here"
gemini
```

Do not put a real key in `.gemini/.env.example`.

## Verify

Inside Gemini CLI, run:

```text
/memory show
```

Confirm that `GEMINI.md` and `.gemini/skills/accessibility.md` are loaded.

Also confirm Gemini acknowledges the continuity rule and reads or creates `.agent/CONTINUITY.md` before making changes.

To verify Context7 is available, ask Gemini for a library API task and require it to use Context7, for example:

```text
Use code7 with the exact MCP tools `mcp_context7_resolve-library-id` and `mcp_context7_query-docs` to look up the current React useEffect docs, then summarize cleanup behavior. Do not use subagents.
```

To verify Apple docs are available, ask:

```text
Use `mcp_apple-docs_search_apple_docs` to look up SwiftUI TextField availability and summarize it. Do not use subagents.
```

If Gemini reports "Unauthorized tool call" or "not available", the setup is failing. Stop and inspect `/tools` and `gemini mcp list` instead of letting Gemini retry guessed tool names.

When verifying from a temp folder or any folder Gemini has not explicitly trusted, run the verification with `GEMINI_CLI_TRUST_WORKSPACE=true`.

To verify iOS tooling, first make sure Xcode and Node.js are installed, then run:

```sh
npx --package xcodebuildmcp@latest xcodebuildmcp-doctor
```

For Xcode 26.3+ built-in MCP access, enable Xcode > Settings > Intelligence > Model Context Protocol > "Allow external agents to use Xcode tools", keep the project open in Xcode, then add `xcode-ide` to `.xcodebuildmcp/config.yaml` when a task needs Xcode's built-in bridge.
