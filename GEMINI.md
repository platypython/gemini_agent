# Gemini Operating Instructions

These instructions are mandatory for Gemini CLI sessions started in this project.

## Recency And Source Discipline

- Treat memory as untrusted for library APIs, framework APIs, SDKs, CLI flags, cloud services, browser/platform behavior, accessibility standards, security-sensitive behavior, and anything described as latest/current/today/as of now.
- Before answering or editing code that depends on an external API, first fetch current documentation with Context7. In prompts, "code7" means Context7.
- Use this lookup flow:
  1. Resolve the library with the Context7 MCP tool `mcp_context7_resolve-library-id`.
  2. Fetch targeted docs with `mcp_context7_query-docs`.
  3. Pin the library/version in the answer or implementation notes when the docs expose a version.
  4. If Context7 lacks the needed docs, use official upstream documentation or release notes before relying on model memory.
- If a task needs Context7 and the `context7` MCP server is unavailable, automatically install/run it on demand with the repo-local MCP command from `.gemini/settings.json`: `npx -y @upstash/context7-mcp@latest`. Do not ask the user first unless Node.js/npm is missing or the command fails.
- Do not invent APIs, options, parameters, event names, environment variables, package names, CSS properties, or command flags. If documentation does not confirm a detail, say it is unconfirmed and choose a documented alternative.
- Prefer primary sources: official docs, standards, release notes, source repositories, and package metadata. Use blogs, forums, or examples only as secondary evidence.
- For requests involving "latest", "current", "today", or other recency-sensitive wording, establish the current timestamp first with `date -Iseconds` and state it in ISO format.

## Frontend Source Gate

For any request that may create or change UI, frontend code, content structure, forms, navigation, visual design, media, generated assets, HTML, CSS, JavaScript, SwiftUI/UIKit screens, or web-facing copy, complete this gate before editing files:

1. Run `date -Iseconds` and keep the timestamp for notes.
2. Read `.agent/CONTINUITY.md`.
3. Perform an accessibility standards lookup from primary sources:
   - Fetch the W3C/WAI WCAG overview: `https://www.w3.org/WAI/standards-guidelines/wcag/`.
   - Fetch the relevant WCAG Understanding page, WAI-ARIA Authoring Practices Guide page, or W3C/WAI resource for any specific pattern used, especially ARIA roles, status messages, custom controls, dialogs, menus, forms, focus management, keyboard behavior, reduced motion, contrast, or target size.
   - If external lookup is unavailable, stop and report the blocker instead of silently relying on memory.
4. Perform a docs lookup for every frontend library, framework, browser/platform API, CSS feature, build tool, or UI component API that materially affects the change:
   - Use Context7 first with `resolve-library-id` and `query-docs`.
   - If Context7 has no suitable source for a web platform feature, fetch the official upstream source instead, such as W3C, WHATWG, MDN Web Docs, React, Next.js, Vite, Tailwind, or the package maintainer docs.
   - Do not satisfy this step by saying "no external libraries" when editing HTML, CSS, JavaScript, or platform UI. Vanilla frontend work still requires official docs lookup for the specific HTML elements, ARIA/status behavior, CSS media features, browser APIs, or platform behavior used.
   - For one-file HTML/CSS pages, fetch at least one official web platform source for the relevant features, such as MDN or W3C documentation for semantic HTML/landmarks, `prefers-color-scheme`, `prefers-reduced-motion`, viewport behavior, forms, images, or links.
5. Record the lookup sources in the final answer, and update `.agent/CONTINUITY.md` when the lookup changes task state, decisions, or verification.

Do not write or modify frontend/user-facing files until this gate has either succeeded or a blocker has been reported to the user. Creating or updating `.agent/CONTINUITY.md` is allowed as part of the gate.

## Tooling Rules

- Do not delegate required source-gate, documentation lookup, build, simulator, or verification work to subagents. Project settings disable built-in subagents because their isolated tool permissions can hide required MCP and shell tools.
- Use Gemini's exact MCP fully qualified tool names, not colon syntax:
  - Context7: `mcp_context7_resolve-library-id`, `mcp_context7_query-docs`
  - Apple docs: `mcp_apple-docs_search_apple_docs`, `mcp_apple-docs_expand_result`, `mcp_apple-docs_list_frameworks`
  - XcodeBuildMCP: tools exposed as `mcp_xcodebuildmcp_<tool-name>`; use `/tools` to inspect exact names when unsure.
- If an MCP tool is unavailable or unauthorized, stop and report the exact tool name and error. Do not keep trying alternate guessed names.
- In headless, temp-directory, or CI-style runs, start Gemini with `GEMINI_CLI_TRUST_WORKSPACE=true gemini --skip-trust ...`; otherwise Gemini may suppress project MCP servers even though core tools still work.

## Work Discipline

- At the start of every session, read `.agent/CONTINUITY.md` before acting. If it does not exist, create it.
- When creating `.agent/CONTINUITY.md`, create the five required section headers once and leave empty sections empty. Do not use placeholder timestamps; run `date -Iseconds` and use the actual result.
- Start by inspecting the project before changing files.
- Make the smallest safe change that satisfies the task.
- Preserve local style and conventions.
- Do not modify unrelated files.
- Never print secrets. Do not ask the user to paste secrets.
- Treat remote API write operations as unsafe unless explicitly requested; prefer read-only calls and dry runs.
- Prefer containerized tooling when a project workflow exists. Do not install system packages on the host unless explicitly asked.
- After changing source code, run the relevant format, lint, typecheck, test, or build commands when feasible. If a check cannot run, report why.

## Continuity File

Maintain `.agent/CONTINUITY.md` as a bounded, factual briefing for future sessions.

- Use these sections exactly: `[PLANS]`, `[DECISIONS]`, `[PROGRESS]`, `[DISCOVERIES]`, `[OUTCOMES]`.
- Do not duplicate section headers.
- Every entry must include an ISO timestamp from `date -Iseconds` and one provenance tag: `[USER]`, `[CODE]`, `[TOOL]`, or `[ASSUMPTION]`.
- Update it only for meaningful changes in task plan, decisions, progress, discoveries, or outcomes.
- Keep entries short and high-signal. Do not paste transcripts, raw logs, secrets, or verbose command output.
- If something is unknown, write `UNCONFIRMED`. If a fact changes, supersede it explicitly instead of silently rewriting history.
- Before finishing a task that changed files, update `[OUTCOMES]` with what changed and what verification ran.

## Hallucination Guardrails

- Separate facts from assumptions. Label assumptions explicitly.
- If requirements are ambiguous and a wrong guess could cause data loss, security exposure, inaccessible UI, or a large rewrite, ask a concise clarification before proceeding.
- Cite or name the docs used for external APIs in final answers when those APIs shaped the work.
- When a tool or command fails, inspect the actual error and adjust from evidence instead of retrying variants blindly.

## Accessibility Skill

@.gemini/skills/accessibility.md

## iOS Development Skill

@.gemini/skills/ios-development.md
