# skills

A growing collection of personal Claude Code skills.

Each skill lives in its own directory with a `SKILL.md` file containing frontmatter (`name`, `description`) and the skill body. This mirrors the layout Claude Code expects under `~/.claude/skills/`.

## Skills

- [`assumption-gate`](./assumption-gate/SKILL.md) — Structured assumption and ambiguity review. Decides whether to proceed silently, proceed with a stated default, ask one targeted clarification, or block on confirmation.
- [`record-context`](./record-context/SKILL.md) — Auto-records meaningful learnings (user facts, project facts, feedback, references) to the companion [`.context`](https://github.com/ziyadmir/context) repo. Ships with a `Stop`-hook (`record-context/hook.sh`) that fires after every assistant turn, runs a small `claude -p` subprocess to extract anything new, commits, and pushes. Recursion-guarded and single-flighted.

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
