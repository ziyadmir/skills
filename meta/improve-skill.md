# Improve Skill Prompt

You are improving a local Claude Skill. Skills should improve through reviewed patches, not automatic mutation.

## Inputs

- `skills/{{skill_id}}/SKILL.md`
- `skills/{{skill_id}}/playbook.md`
- `skills/{{skill_id}}/examples.md`
- `skills/{{skill_id}}/evals.md`
- All files in `feedback/` matching the skill
- Recent files in `runs/` matching the skill

## Task

1. Read recent feedback and runs for this skill.
2. Cluster recurring failures. Separate one-off feedback from stable lessons.
3. Propose **minimal** patches.
4. Prefer `playbook.md` changes before `SKILL.md` changes. Only promote to `SKILL.md` after repeated evidence.
5. Add to `examples.md` only when an example improves calibration (i.e. it disambiguates a real failure mode).
6. Add eval cases to `evals.md` for any regression worth catching next time.
7. Do not overfit to a single run.
8. Produce a **git-style diff** for each file you propose to change.
9. Bump `changelog.md` with a one-line summary per change.
10. **Do not apply changes until the user approves.**

## Anti-patterns to avoid

- Making the skill more verbose unless feedback clearly requires it.
- Rewriting `SKILL.md` based on a single piece of feedback.
- Adding hedging or generic advice ("consider context", "use judgment").
- Drift from the user's actual preferences. Preserve voice.
- Inventing examples that didn't actually happen — pull from `runs/`.

## Output format

```
## Summary
<2-3 lines: what feedback was clustered, what changed>

## Proposed diffs

### skills/{{skill_id}}/playbook.md
```diff
<diff>
```

### skills/{{skill_id}}/examples.md
```diff
<diff>
```

### skills/{{skill_id}}/evals.md
```diff
<diff>
```

## New eval cases to add
<list>

## Awaiting approval before applying.
```
