#!/usr/bin/env bash
# Create a feedback file attached to a run.
# Usage: scripts/new-feedback.sh <run-id>
#   where <run-id> is the basename of a run file, e.g. 2026-04-27-writing-style-001
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <run-id>" >&2
  echo "  e.g. $0 2026-04-27-writing-style-001" >&2
  exit 1
fi

RUN_ID="$1"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
RUN_FILE="$ROOT/runs/${RUN_ID}.md"
FEEDBACK_FILE="$ROOT/feedback/${RUN_ID}.feedback.md"

if [[ ! -f "$RUN_FILE" ]]; then
  echo "Run file not found: $RUN_FILE" >&2
  exit 1
fi

# Extract skill from run id: strip date prefix + numeric suffix
SKILL=$(echo "$RUN_ID" | sed -E 's/^[0-9]{4}-[0-9]{2}-[0-9]{2}-//; s/-[0-9]+$//')

cat > "$FEEDBACK_FILE" <<EOF
# Feedback: ${RUN_ID}

## Skill

${SKILL}

## Run

runs/${RUN_ID}.md

## Feedback type

<!-- one of: style_mismatch, missed_point, overcomplicated, lost_nuance, good_keep, regression -->
TODO

## Severity

<!-- low | medium | high -->
TODO

## What was wrong (or what was right)

TODO

## Better behavior

TODO

## Patch candidate

<!-- propose a concrete edit to skills/${SKILL}/playbook.md or examples.md or evals.md -->
TODO
EOF

echo "$FEEDBACK_FILE"
