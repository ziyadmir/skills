#!/usr/bin/env bash
# Stop hook: after each Claude Code turn, scan the transcript for any new
# meaningful learnings and append them to ~/.context/, then commit + push.
#
# Runs the extraction in the background so the user gets no added latency.
# The spawned `claude -p` subprocess decides whether anything is worth saving;
# if not, it exits without modifying the repo.

set -u

# Guard: don't recurse. The spawned subprocess sets this var.
if [[ "${CLAUDE_CONTEXT_RECORDER:-0}" = "1" ]]; then
  exit 0
fi

# Read the hook input (JSON on stdin) — Claude Code passes session_id, transcript_path, etc.
INPUT="$(cat)"
TRANSCRIPT_PATH="$(printf '%s' "$INPUT" | /usr/bin/python3 -c 'import json,sys; d=json.load(sys.stdin); print(d.get("transcript_path",""))' 2>/dev/null || true)"

if [[ -z "$TRANSCRIPT_PATH" || ! -f "$TRANSCRIPT_PATH" ]]; then
  exit 0
fi

CONTEXT_DIR="$HOME/.context"
LOG="$CONTEXT_DIR/.recorder.log"
LOCK="$CONTEXT_DIR/.recorder.lock"

mkdir -p "$CONTEXT_DIR"

# Detach so the user doesn't wait. Single-flight via lock file.
(
  exec >>"$LOG" 2>&1
  echo "=== $(date -Iseconds) hook fired for $TRANSCRIPT_PATH ==="

  # Single-flight: skip if another recorder is already running.
  if ! ( set -o noclobber; echo "$$" > "$LOCK" ) 2>/dev/null; then
    echo "another recorder running (pid $(cat "$LOCK" 2>/dev/null)); skipping"
    exit 0
  fi
  trap 'rm -f "$LOCK"' EXIT

  PROMPT='You are an automated context recorder. The user is Ziyad (Roblox ads-moderation AI engineer).

Read the transcript file at: '"$TRANSCRIPT_PATH"'

Compare against the current ~/.context/ knowledge base. Identify any NEW meaningful learnings from the most recent assistant + user turns that are worth keeping for future conversations:
- User facts (role, preferences, tools, expertise)
- Project facts (initiatives, deadlines, stakeholders, constraints)
- Feedback (corrections, validated approaches)
- External references (Slack channels, dashboards, repos)

DO NOT save:
- Anything already in ~/.context/
- Ephemeral conversation state
- Code/architecture details derivable from the repo
- Sensitive Roblox-internal info that should not leave the company
- Trivial back-and-forth, summaries, or pleasantries

If there is NOTHING meaningful to save, exit silently without writing anything.

If there IS something worth saving:
1. Read ~/.context/MEMORY.md and the relevant file first
2. Update the existing file or create a new one under ~/.context/
3. Update ~/.context/MEMORY.md if you added a new file
4. Commit and push:
   cd ~/.context && git add -A && git commit -m "auto: <short summary>" && git push

Be conservative. When in doubt, do not save. Quality over coverage.'

  CLAUDE_CONTEXT_RECORDER=1 /opt/homebrew/bin/claude -p "$PROMPT" \
    --permission-mode acceptEdits \
    >/dev/null 2>&1 || echo "claude subprocess exited non-zero"

  # Guaranteed push: always sync to origin after the subprocess finishes.
  # Catches the case where the subprocess committed but didn't push, or where
  # the user made manual edits/commits between hook runs.
  cd "$CONTEXT_DIR" || exit 0
  if git rev-parse --git-dir >/dev/null 2>&1; then
    UPSTREAM="$(git rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null || true)"
    if [[ -n "$UPSTREAM" ]]; then
      AHEAD="$(git rev-list --count "$UPSTREAM"..HEAD 2>/dev/null || echo 0)"
      if [[ "$AHEAD" -gt 0 ]]; then
        echo "pushing $AHEAD commit(s) to $UPSTREAM"
        git push 2>&1 || echo "push failed"
      else
        echo "nothing to push (up to date with $UPSTREAM)"
      fi
    else
      echo "no upstream configured; skipping push"
    fi
  fi

  echo "=== done $(date -Iseconds) ==="
) </dev/null >/dev/null 2>&1 &

disown 2>/dev/null || true
exit 0
