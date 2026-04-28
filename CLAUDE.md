# Working in ~/skills/

This repo holds **behaviors** (skills) plus a feedback-driven improvement loop. **Background** about projects/people lives in `~/.context/` (separate repo, auto-maintained by the `record-context.sh` Stop hook).

See `README.md` for the full mental model.

## What to do when a task starts

1. Read `meta/routing.md` to decide which skill files (here) and which background files (`~/.context/`) to load.
2. Load the minimum needed — do not bulk-load.
3. **Background** tells you what is true. **Skill** tells you how to behave.

## When to capture a run

After a meaningful skill execution worth learning from (good or bad):
- `runs/YYYY-MM-DD-<skill>-NNN.md` — prompt, output, user reaction, accepted output, lessons.
- Optionally `feedback/YYYY-MM-DD-<skill>-NNN.feedback.md` if there is a concrete correction.

Use `scripts/new-run.sh <skill>` to create one with the right name.

**Privacy note:** `runs/` and `feedback/` are gitignored — this repo is public. Capture freely; nothing leaks.

## When to update a skill

**Do not auto-mutate skills after every run.** Lessons go to `playbook.md` first. Promote to `SKILL.md` only after repeated evidence across multiple runs/feedback.

To improve a skill:
1. Read `meta/improve-skill.md`.
2. Read recent local files in `feedback/` and `runs/` for that skill.
3. Cluster recurring failures — ignore one-offs.
4. Propose a minimal patch as a git diff.
5. **Do not apply until the user approves.**

## Style

- Direct, concrete, low fluff.
- Preserve the user's actual thesis when summarizing or rewriting — do not over-clean.
- Avoid corporate filler.
