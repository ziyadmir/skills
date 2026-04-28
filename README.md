# skills

A growing collection of personal Claude Code skills, plus a feedback-driven improvement loop.

Each skill lives in its own directory:

```
<skill-id>/
  SKILL.md       # stable behavior — auto-loaded by Claude Code's harness
  playbook.md    # learned lessons — evolves more often
  examples.md    # calibration examples (good + bad)
  evals.md       # regression cases
  changelog.md   # version history
```

## Skills

- [`assumption-gate`](./assumption-gate/SKILL.md) — Structured assumption and ambiguity review. Decides whether to proceed silently, proceed with a stated default, ask one targeted clarification, or block on confirmation.
- [`record-context`](./record-context/SKILL.md) — Auto-records meaningful learnings (user facts, project facts, feedback, references) to the companion [`.context`](https://github.com/ziyadmir/context) repo. Ships with a `Stop`-hook (`record-context/hook.sh`) that fires after every assistant turn, runs a small `claude -p` subprocess to extract anything new, commits, and pushes. Recursion-guarded and single-flighted.

## Improvement loop

- `runs/` — captured executions worth learning from (gitignored — local only).
- `feedback/` — structured feedback attached to runs (gitignored — local only).
- `meta/routing.md` — what to load when.
- `meta/improve-skill.md` — the prompt that turns clustered feedback into reviewed patches.
- `meta/feedback-log.md` — append-only index of feedback events.
- `scripts/new-run.sh <skill>` — scaffold a run capture.
- `scripts/new-feedback.sh <run-id>` — attach feedback to a run.
- `scripts/new-skill.sh <id> "<purpose>"` — scaffold a new skill.

### Promotion rule

Lessons go in `playbook.md` first. Promote to `SKILL.md` only after repeated evidence across multiple runs/feedback. Prevents overfitting to one bad run.

### Why runs/feedback are gitignored

This repo is public. Run/feedback files contain real task content (work specifics, corrections). The `.gitignore` keeps them local-only — capture freely.

## Companion: `.context`

The [`.context`](https://github.com/ziyadmir/context) repo sits alongside this one as the organized collection of pointers and knowledge that skills and agents pull from. **This repo holds the *behaviors*; `.context` holds the *background*.**

```
ziyadmir/skills (this repo)         ziyadmir/context (companion)
├── assumption-gate/SKILL.md        ├── user.md              ← who I am
├── record-context/                 ├── work/roblox.md       ← what I'm working on
│   ├── SKILL.md                    ├── feedback.md          ← how I want Claude to behave
│   └── hook.sh   ─── Stop hook ──▶ └── ...                    (writes here)
└── ...
```

The `record-context` skill is the bridge: its hook reads the live transcript, decides what's worth keeping, and writes into `.context/`.

## Workflow

```bash
cd ~/skills
claude
```

Tell Claude what you're doing; it reads `CLAUDE.md` + `meta/routing.md` and loads the right skill + background. After a notable run:

```bash
scripts/new-run.sh <skill-id>
# fill in the file, then optionally:
scripts/new-feedback.sh <run-id>
```

Periodically (every ~10-20 runs):

> Use `meta/improve-skill.md` against `<skill-id>`. Look at recent runs and feedback. Propose a patch only — do not apply.
