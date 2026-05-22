---
name: record-context
description: Use proactively whenever the user shares a fact, preference, constraint, or correction about themselves, their work, their projects, or how they want me to behave that is worth keeping for future conversations. Writes structured entries to ~/.context/, commits them to git, and pushes them to the configured remote. Also use when the user explicitly says "remember", "save this", "note that", or "/record-context".
---

# record-context

`~/.context/` is a git-tracked, user-curated knowledge base separate from the auto-memory system. It's the durable, portable record of who Ziyad is, what he's working on, and how he wants to collaborate.

## When to write

Save when the user shares any of:
- **User facts** — role, employer, team, expertise, tools, preferences
- **Project facts** — current initiatives, deadlines, stakeholders, constraints
- **Feedback** — corrections ("don't do X"), validated approaches ("yes that was right")
- **References** — Slack channels, dashboards, internal docs, external systems

Skip:
- Anything derivable from reading code or running `git log`
- Ephemeral conversation state ("I'm debugging this right now")
- Repetition of facts already in `~/.context/`

## How to write

1. **Check first:** Read `~/.context/MEMORY.md` and the relevant file before writing — update existing entries instead of duplicating.
2. **Pick the right file:**
   - User identity / priorities → `~/.context/user.md`
   - Work / employer / domain → `~/.context/work/<topic>.md`
   - How to behave → `~/.context/feedback.md`
   - External pointers → `~/.context/references.md`
   - New ongoing project → `~/.context/projects/<name>.md` (create if needed)
3. **Frontmatter:**
   ```
   ---
   name: <short title>
   type: <user|project|feedback|reference>
   ---
   ```
4. **For feedback/project entries**, use this body shape:
   ```
   <rule or fact>

   **Why:** <reason the user gave>
   **How to apply:** <when this kicks in>
   ```
5. **Update `MEMORY.md`** with a one-line index entry if you create a new file.
6. **Commit and push every update:**
   ```bash
   cd ~/.context && git add -A && git commit -m "record: <short summary>" && git push
   ```
   Pushing is required for every context update. After pushing, verify `git status --short --branch` shows the local branch is not ahead of the remote, or report the push failure explicitly.

## What NOT to save

Same exclusions as the auto-memory system:
- Code patterns, file paths, architecture — these are in the repo.
- Git history — `git log` is authoritative.
- Debugging fix recipes — the fix is in the diff.
- Anything sensitive: API keys, internal Roblox details that shouldn't leave the company. The repo is private but treat it as if it could leak.

## Removing memories

When the user says "forget X" or you find a stale entry: delete or correct, then commit with `record: remove <topic>` or `record: correct <topic>`.

## Relationship to the auto-memory system

The auto-memory at `~/.claude/projects/-Users-ziyadmir/memory/` continues to operate. `.context/` is the user-owned, git-backed surface. When information is durable enough to keep across machines and worth versioning, prefer `.context/`.

## Companion hook

This skill ships with `hook.sh` in the same directory. It runs as a Claude Code `Stop` hook, after each assistant turn, to scan the transcript and append any new meaningful learnings to `~/.context/` automatically (then commit + push).

### Install (one-time per machine)

```bash
# Symlink so the hook is invocable from a stable path:
ln -sf ~/.claude/skills/record-context/hook.sh ~/.claude/hooks/record-context.sh

# Register the Stop hook in ~/.claude/settings.json:
#   "hooks": {
#     "Stop": [{
#       "matcher": "",
#       "hooks": [{ "type": "command", "command": "$HOME/.claude/hooks/record-context.sh", "timeout": 10 }]
#     }]
#   }

# Make sure ~/.context exists and has a git remote configured:
git -C ~/.context remote -v   # should show origin
```

The hook self-detaches (runs in background), self-locks (single-flight), and self-guards against recursion via `CLAUDE_CONTEXT_RECORDER=1`. After the spawned `claude -p` subprocess finishes, the hook unconditionally pushes any unpushed commits — so manual edits in `~/.context/` get pushed too.
