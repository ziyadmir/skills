# skills

A growing collection of personal Claude Code skills.

Each skill lives in its own directory with a `SKILL.md` file containing frontmatter (`name`, `description`) and the skill body. This mirrors the layout Claude Code expects under `~/.claude/skills/`.

## Skills

- [`assumption-gate`](./assumption-gate/SKILL.md) — Structured assumption and ambiguity review. Decides whether to proceed silently, proceed with a stated default, ask one targeted clarification, or block on confirmation.

## Companion: `.context`

A separate `.context` repo will sit alongside this one as an organized collection of pointers to context I recurringly grow — links, references, and notes that skills and agents can pull from. This repo holds the *behaviors*; `.context` will hold the *background*.
