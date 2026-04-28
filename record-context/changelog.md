# record-context — Changelog

## 0.1.0 — 2026-04-27

- Initial skill: auto-records meaningful learnings from each turn into the `.context` companion repo.
- Ships with `hook.sh` — a `Stop`-event hook that:
  - Self-detaches (no added latency at end of turn)
  - Spawns a `claude -p` subprocess to scan the transcript and decide what to save
  - Single-flights via lock file
  - Recursion-guards via `CLAUDE_CONTEXT_RECORDER=1`
  - Unconditionally pushes any unpushed commits after the subprocess returns (safety net)
- Companion structure: `playbook.md`, `examples.md`, `evals.md`, `changelog.md`.
