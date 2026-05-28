# iOS Development Skill

Use this skill whenever work touches iOS, iPadOS, Swift, SwiftUI, UIKit, Xcode projects, Swift packages used by Apple platforms, XCTest, XCUITest, app signing, entitlements, simulators, previews, or Apple framework APIs.

## Current Tooling Contract

- Use XcodeBuildMCP for Xcode-oriented work. It is configured as the `xcodebuildmcp` MCP server.
- Use Apple documentation lookup before relying on memory for Apple APIs. Prefer:
  1. Xcode's own MCP documentation tools when available through XcodeBuildMCP's Xcode IDE bridge.
  2. The `apple-docs` MCP tools for Swift, SwiftUI, UIKit, AppKit, and other Apple framework symbols. Use Gemini's fully qualified MCP tool names: `mcp_apple-docs_search_apple_docs`, `mcp_apple-docs_expand_result`, and `mcp_apple-docs_list_frameworks`.
  3. Official Apple Developer documentation in the browser if the MCP tools do not return enough detail.
- Use Context7 for non-Apple dependencies such as Firebase, Supabase, Stripe, Swift package libraries, backend SDKs, and JavaScript tooling around the app. Use `mcp_context7_resolve-library-id` and `mcp_context7_query-docs`.
- Do not delegate Apple documentation, build, simulator, or UI verification work to subagents. Use the main session's tools directly so tool permission failures are visible and actionable.

## Documentation Workflow

- For any Apple API, symbol, modifier, environment value, entitlement, build setting, Info.plist key, or framework behavior, look it up before recommending or implementing it.
- Search by exact symbol names when possible, for example `NavigationStack`, `@Observable`, `URLSession`, `UNUserNotificationCenter`, or `BGTaskScheduler`.
- Confirm platform availability and version constraints before using APIs introduced in recent iOS, Swift, or Xcode releases.
- If docs conflict with examples found online, trust the official Apple docs or current release notes.
- State when a detail is inferred from code or docs rather than directly confirmed.

## Build And Test Workflow

- Before the first build/test/run in a session, inspect project structure and XcodeBuildMCP session defaults. Do not assume the scheme, project path, workspace path, or simulator.
- If no defaults exist, discover projects/workspaces/schemes and set session defaults for the active iOS target and simulator.
- Prefer simulator builds for ordinary validation. Use physical-device workflows only when the user asks or the issue requires hardware.
- After changing Swift, SwiftUI, package, asset, storyboard, entitlement, or project files, run the narrowest relevant build or test with XcodeBuildMCP.
- When debugging failures, use structured build errors, logs, Issue Navigator data, simulator screenshots, and UI hierarchy evidence before changing code.
- Do not declare iOS work done without build/test status. If a build cannot run, explain the missing prerequisite exactly.
- If an MCP tool call returns "Unauthorized tool call" or "not available", stop and report the exact tool name. Do not retry guessed variants such as colon syntax.

## Swift And SwiftUI Rules

- Preserve the app's architecture and state ownership patterns.
- Prefer simple SwiftUI data flow over broad rewrites.
- Keep UI code on the main actor when required by framework semantics.
- Avoid deprecated APIs unless the deployment target requires them and no better option exists.
- Do not invent SwiftUI modifiers, UIKit delegate methods, Info.plist keys, entitlements, or build settings.
- Verify concurrency, observation, navigation, and presentation APIs against current docs before using them.

## iOS Accessibility Rules

- Apply the accessibility skill for every user-facing screen.
- Prefer native SwiftUI/UIKit controls that expose roles and traits automatically.
- Verify custom controls, gestures, canvas views, charts, maps, and media controls with accessibility labels, values, hints only when useful, traits, focus order, Dynamic Type, Reduce Motion, Increase Contrast, and VoiceOver behavior.
- Use XcodeBuildMCP UI automation/screenshot tools for simulator evidence when UI changed.
