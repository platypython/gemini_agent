#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: ./install-gemini-assets.sh [--force] /path/to/existing/project

Copies this repo's Gemini project assets into an existing project.

Options:
  --force   Overwrite existing destination files.
  -h, --help
            Show this help.

By default, the script refuses to overwrite existing files.
USAGE
}

force=false

while [ "$#" -gt 0 ]; do
  case "$1" in
    --force)
      force=true
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    --)
      shift
      break
      ;;
    -*)
      printf 'Unknown option: %s\n\n' "$1" >&2
      usage >&2
      exit 2
      ;;
    *)
      break
      ;;
  esac
done

if [ "$#" -ne 1 ]; then
  usage >&2
  exit 2
fi

dest=$1
script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)

if [ ! -d "$dest" ]; then
  printf 'Destination does not exist or is not a directory: %s\n' "$dest" >&2
  exit 1
fi

dest=$(cd -- "$dest" && pwd)

copy_file() {
  src=$1
  rel=$2
  target=$dest/$rel

  if [ -e "$target" ] && [ "$force" = false ]; then
    printf 'Skip existing file: %s\n' "$rel"
    return 0
  fi

  mkdir -p "$(dirname -- "$target")"
  cp "$src" "$target"
  printf 'Copied file: %s\n' "$rel"
}

copy_dir() {
  rel=$1
  src=$script_dir/$rel
  target=$dest/$rel

  mkdir -p "$target"

  if [ "$force" = true ]; then
    rsync -a "$src"/ "$target"/
  else
    rsync -a --ignore-existing "$src"/ "$target"/
  fi

  printf 'Synced directory: %s\n' "$rel"
}

copy_file "$script_dir/GEMINI.md" "GEMINI.md"
copy_dir ".gemini"
copy_dir ".xcodebuildmcp"

printf '\nDone. Start Gemini from the destination project:\n'
printf '  cd %s\n' "$dest"
printf '  gemini\n'
printf '\nGemini will create destination-local .agent/CONTINUITY.md when it starts if one does not already exist.\n'
