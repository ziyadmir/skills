# Routing

Tells Claude which skill files and which background context to load for a given task.

## Where things live

- **Behaviors** → `~/skills/<skill-id>/` (this repo). `SKILL.md` is loaded automatically by Claude Code's harness; `playbook.md`, `examples.md`, `evals.md`, `changelog.md` are loaded on demand by routing.
- **Background** → `~/.context/` (separate repo, auto-maintained by `record-context.sh` Stop hook). Holds `user.md`, `feedback.md`, `work/*.md`, `MEMORY.md`.
- **Improvement loop** → `runs/`, `feedback/`, `meta/improve-skill.md` here. Run/feedback files are gitignored on this public repo — they stay local.

## Rule

- **Background** tells the assistant what is true.
- **Skill** tells the assistant how to think/write/review.
- Load the minimum needed.

## Composition

Most non-trivial tasks are:

```
Task + Background (~/.context) + Skill (~/skills/<id>) + recent local Feedback
```

## Skill routes

Add a route per skill as you create it. Template:

```markdown
### <task type, e.g. "Reviewing a system design">

Load:
- ~/skills/<skill-id>/SKILL.md
- ~/skills/<skill-id>/playbook.md
- ~/skills/<skill-id>/examples.md   (if calibration matters)
```

<!-- skills:start -->

### Decisions with high-impact ambiguity, risky defaults, or destructive operations

Load:
- `~/skills/assumption-gate/SKILL.md`
- `~/skills/assumption-gate/playbook.md`

<!-- skills:end -->
