#!/usr/bin/env bash
# Create a new run file for a skill execution worth capturing.
# Usage: scripts/new-run.sh <skill-id>
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <skill-id>" >&2
  exit 1
fi

SKILL="$1"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
STAMP=$(date +"%Y-%m-%d")
COUNT=$(ls "$ROOT/runs/${STAMP}-${SKILL}-"*.md 2>/dev/null | wc -l | tr -d ' ')
NEXT=$(printf "%03d" $((COUNT + 1)))
FILE="$ROOT/runs/${STAMP}-${SKILL}-${NEXT}.md"

GIT_SHA=$(git -C "$ROOT" rev-parse --short HEAD 2>/dev/null || echo "uncommitted")

cat > "$FILE" <<EOF
# Run: ${STAMP}-${SKILL}-${NEXT}

## Skill

${SKILL}

## Skill version (git)

${GIT_SHA}

## Prompt

TODO

## Output

TODO

## User reaction

TODO

## Final accepted output

TODO

## Lessons

TODO
EOF

echo "$FILE"
