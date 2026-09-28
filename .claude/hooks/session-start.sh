#!/bin/bash
# Prepares a Claude Code on the web container to render HyperFrames videos:
# ffmpeg/ffprobe for encoding, and Chrome Headless Shell for frame capture.
set -euo pipefail

if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

if ! command -v ffmpeg >/dev/null 2>&1; then
  export DEBIAN_FRONTEND=noninteractive
  apt-get install -y -qq ffmpeg >/dev/null 2>&1 \
    || { apt-get update -qq >/dev/null && apt-get install -y -qq ffmpeg >/dev/null; }
fi

# Pinned to match videos/package.json so renders stay reproducible.
npx --yes hyperframes@0.8.81 browser ensure >/dev/null

# Student kit: its own pinned HyperFrames (0.7.x) uses a different Chrome build.
if [ -f "$CLAUDE_PROJECT_DIR/student-kit/package.json" ]; then
  cd "$CLAUDE_PROJECT_DIR/student-kit"
  npm install --no-audit --no-fund --silent
  npx hyperframes browser ensure >/dev/null
  [ -f .env ] || cp .env.example .env
fi
