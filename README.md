# Gemini Project Assets

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

Inside Gemini CLI, run:

```text
/memory show
```

Confirm that the destination project's `GEMINI.md` is loaded. Then ask Gemini to use `code7` for a library lookup to verify Context7 starts automatically.

Also confirm Gemini creates or reads the destination project's own `.agent/CONTINUITY.md`. It should not contain this repo's build history.

## Notes

- Context7 is configured to install/run on demand with `npx -y @upstash/context7-mcp@latest`.
- Node.js/npm must be available for the MCP servers that use `npx`.
- Do not commit real API keys. Use `.gemini/.env.example` only as a template.
- Keep any copied files project-local and adapt the instructions when the destination is not an iOS project.
