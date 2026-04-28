#!/usr/bin/env bash
# Scaffold a new skill directory with the standard 5 files.
# Usage: scripts/new-skill.sh <skill-id> "<one-line purpose>"
set -euo pipefail

if [[ $# -lt 2 ]]; then
  echo "Usage: $0 <skill-id> \"<one-line purpose>\"" >&2
  exit 1
fi

SKILL="$1"
PURPOSE="$2"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DIR="$ROOT/skills/${SKILL}"

if [[ -d "$DIR" ]]; then
  echo "Skill already exists: $DIR" >&2
  exit 1
fi

mkdir -p "$DIR"
STAMP=$(date +"%Y-%m-%d")

cat > "$DIR/SKILL.md" <<EOF
# ${SKILL}

## Purpose

${PURPOSE}

## When to use

- TODO

## When NOT to use

- TODO

## Behavior

- TODO

## Output style

- TODO
EOF

cat > "$DIR/playbook.md" <<EOF
# ${SKILL} — Playbook

Lessons learned from usage. Promote to SKILL.md only after repeated evidence.

## Lessons

- (none yet)
EOF

cat > "$DIR/examples.md" <<EOF
# ${SKILL} — Examples

Calibration examples. Prefer real ones from runs/ over invented ones.

## Good examples

<!-- pattern:
### <short title>

**Input:** ...
**Output:** ...
**Why good:** ...
-->

## Bad examples

<!-- pattern:
### <short title>

**Input:** ...
**Bad output:** ...
**Why bad:** ...
**Better output:** ...
-->
EOF

cat > "$DIR/changelog.md" <<EOF
# ${SKILL} — Changelog

## 0.1.0 — ${STAMP}

- Initial skill scaffolding.
EOF

cat > "$DIR/evals.md" <<EOF
# ${SKILL} — Evals

Regression cases. Run periodically to detect skill drift.

## Format

\`\`\`
## Case NNN — <short title>

**Input:** ...
**Expected behavior:** ...
**Checks:**
- check 1
- check 2
\`\`\`

## Cases

<!-- (none yet) -->
EOF

echo "Created skill: $DIR"
echo "Files:"
ls "$DIR"
