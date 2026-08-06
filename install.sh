#!/usr/bin/env bash
#
# install.sh — install skills from this repository into a Claude skills directory.
#
# Each skill lives in skills/<name>/ with a SKILL.md file. "Installing" a skill
# copies its directory into the target skills directory so Claude can discover
# and load it.
#
# Usage:
#   ./install.sh [SKILL_NAME ...]        # install named skills (default: all)
#   ./install.sh --list                  # list installable skills
#   ./install.sh --target DIR [SKILL...] # install into a custom directory
#
# Environment:
#   CLAUDE_SKILLS_DIR   Target skills directory.
#                       Default: $HOME/.claude/skills
#
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SRC="$REPO_DIR/skills"
TARGET="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"

usage() {
  sed -n '3,20p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'
}

list_skills() {
  local found=0
  for dir in "$SKILLS_SRC"/*/; do
    [ -f "${dir}SKILL.md" ] || continue
    printf '  %s\n' "$(basename "$dir")"
    found=1
  done
  [ "$found" -eq 1 ] || echo "  (no skills found in $SKILLS_SRC)"
}

# --- argument parsing ---------------------------------------------------------
declare -a NAMES=()
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help)   usage; exit 0 ;;
    --list)      echo "Installable skills:"; list_skills; exit 0 ;;
    --target)    shift; TARGET="${1:?--target requires a directory}" ;;
    --target=*)  TARGET="${1#--target=}" ;;
    -*)          echo "Unknown option: $1" >&2; usage >&2; exit 2 ;;
    *)           NAMES+=("$1") ;;
  esac
  shift
done

if [ ! -d "$SKILLS_SRC" ]; then
  echo "error: no skills/ directory found at $SKILLS_SRC" >&2
  exit 1
fi

# Default to every skill directory that contains a SKILL.md.
if [ "${#NAMES[@]}" -eq 0 ]; then
  for dir in "$SKILLS_SRC"/*/; do
    [ -f "${dir}SKILL.md" ] || continue
    NAMES+=("$(basename "$dir")")
  done
fi

if [ "${#NAMES[@]}" -eq 0 ]; then
  echo "error: no installable skills found in $SKILLS_SRC" >&2
  exit 1
fi

mkdir -p "$TARGET"

installed=0
for name in "${NAMES[@]}"; do
  src="$SKILLS_SRC/$name"
  if [ ! -f "$src/SKILL.md" ]; then
    echo "skip: '$name' is not a skill (no SKILL.md at $src)" >&2
    continue
  fi
  dest="$TARGET/$name"
  rm -rf "$dest"
  cp -R "$src" "$dest"
  echo "installed: $name -> $dest"
  installed=$((installed + 1))
done

echo
echo "Done. Installed $installed skill(s) into $TARGET"
