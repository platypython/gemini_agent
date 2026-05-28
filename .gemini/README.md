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

The Context7 MCP is intentionally configured with `npx -y @upstash/context7-mcp@latest`, so Gemini can download and run it automatically when a task needs current library/API docs. If the `context7` server is missing or stale, use that command from `.gemini/settings.json` on demand instead of asking for manual setup, unless Node.js/npm is unavailable or the command fails.

## Run

From this directory:

```sh
gemini
```

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
Use code7 to look up the current React useEffect docs, then summarize cleanup behavior.
```

To verify iOS tooling, first make sure Xcode and Node.js are installed, then run:

```sh
npx --package xcodebuildmcp@latest xcodebuildmcp-doctor
```

For Xcode 26.3+ built-in MCP access, enable Xcode > Settings > Intelligence > Model Context Protocol > "Allow external agents to use Xcode tools", keep the project open in Xcode, then add `xcode-ide` to `.xcodebuildmcp/config.yaml` when a task needs Xcode's built-in bridge.
