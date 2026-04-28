---
name: assumption-gate
description: Structured assumption and ambiguity review. Use when a task has high-impact ambiguity, unclear intent/scope, risky defaults, destructive operations, schema/API/auth/security changes, migrations, broad refactors, policy/safety decisions, or decisions where the wrong assumption would materially change the result.
---

# Assumption Gate

## Purpose

Prevent wasted work and unsafe or incorrect execution by surfacing only the assumptions that materially affect the outcome.

This skill should not produce generic assumption lists. Its job is to decide whether the agent can proceed safely, should proceed with a stated default, or should ask one targeted clarification.

## Core principle

Always distinguish between:

- **Known facts**: directly provided by the user, repo, docs, tests, tool output, or other observed evidence.
- **Inferences**: logically derived from known facts.
- **Assumptions**: premises needed to proceed that are not directly verified.
- **Defaults**: conservative choices used when uncertainty exists but clarification is not required.

Only surface assumptions when doing so would materially improve correctness, safety, or user steering.

## When to use this skill

Use this skill before or during:

- Multi-step coding tasks
- Multi-file code edits
- Broad refactors
- Architecture or design decisions
- Database schema changes
- API contract changes
- Auth, permissions, security, privacy, payments, moderation, or safety-related changes
- Migrations
- Destructive or hard-to-reverse operations
- Production-impacting changes
- Ambiguous user requests
- Long-running agent work
- Tasks where a wrong assumption would cause significant wasted work

Do not use this skill for:

- Simple factual answers
- Typo fixes
- Small copy edits
- Obvious one-line changes
- Straightforward test additions
- Local behavior-preserving refactors
- Tasks where the safe default is obvious and reversible

## Decision rule

Before proceeding, silently check whether clarification is required.

Clarification is required only when all four are true:

1. **Uncertainty**: there are multiple plausible interpretations.
2. **Impact**: choosing the wrong interpretation materially changes the answer, implementation, risk profile, or user outcome.
3. **Cost**: the wrong path would waste meaningful time, create risky changes, or be hard to undo.
4. **No safe default**: there is no obvious conservative default that preserves user intent.

If all four are true, ask a targeted clarification.

If not, proceed silently or proceed with a brief stated default.

## Modes

Choose exactly one mode.

### Mode 0: Silent Proceed

Use when assumptions are obvious, low-impact, reversible, or handled by normal defaults.

Do not mention this skill.
Do not mention assumptions.
Proceed normally.

### Mode 1: Proceed With Stated Default

Use when there is mild ambiguity, but a conservative default is clear.

Output one short sentence before proceeding:

> I’ll assume [default] and avoid [risky action].

Examples:

> I’ll assume behavior should remain unchanged and keep this to a local refactor.

> I’ll assume backward compatibility is required and avoid API/schema changes.

Then proceed.

### Mode 2: Ask One Clarification

Use when the ambiguity is high-impact and no safe default exists.

Ask one focused question.

Preferred format:

> One thing to confirm before I proceed: [specific ambiguity]. Should I assume [A] or [B]?

Rules:
- Ask at most one question.
- Present at most two or three options.
- Recommend a default if possible.
- Do not dump a full assumption list.
- Do not ask vague questions like “Can you clarify?”
- Do not ask if the answer can be inferred safely from context.

### Mode 3: Block / Require Confirmation

Use when proceeding could be destructive, unsafe, policy-sensitive, security-sensitive, or hard to reverse.

Preferred format:

> I need confirmation before doing this because [specific risk]. Should I proceed with [specific action]?

Use this for:
- Deleting data/files
- Running destructive commands
- Changing auth/security semantics
- Schema migrations with compatibility risk
- Production-impacting changes
- Sending external communications
- Any action that could cause irreversible damage

## Assumption scoring

When deciding internally, score assumptions by:

- **Confidence**: high / medium / low
- **Impact if wrong**: high / medium / low
- **Recoverability**: easy / moderate / hard
- **Cost of delay**: low / medium / high

Only surface assumptions that are:
- low or medium confidence,
- high impact if wrong,
- hard or moderately hard to recover from,
- and not covered by a safe default.

## High-value assumption categories

Look for assumptions about:

### Intent

What does the user actually want?

Examples:
- Minimal patch vs broad refactor
- Explanation vs implementation
- Prototype vs production-ready solution
- Speed vs correctness
- Best-effort answer vs precise audited answer

### Scope

What should be included or excluded?

Examples:
- Single file vs multi-file
- Backend-only vs frontend + backend
- Local fix vs platform-level design
- MVP vs long-term architecture

### Compatibility

What behavior must remain stable?

Examples:
- Public API compatibility
- Backward-compatible database reads/writes
- Existing test behavior
- Existing user-visible UX
- Existing permissions model

### Environment

What tools, runtime, infra, or repo conventions are available?

Examples:
- Test framework
- Build system
- Deployment model
- Service ownership boundaries
- Local vs production constraints

### Source of truth

Which information should be trusted?

Examples:
- Tests vs docs
- Current code vs README
- User-provided context vs stale comments
- Product spec vs existing behavior

### Safety and risk

What could go badly if the assumption is wrong?

Examples:
- Security regression
- Data loss
- Privacy leak
- Policy violation
- Breaking production callers
- Incorrect moderation or safety decision

## Output patterns

### Good clarification

> One thing to confirm before I proceed: should this be a minimal bug fix, or is a broader refactor acceptable? I’d default to the minimal fix unless you want the refactor.

### Good stated default

> I’ll assume the public API must stay backward-compatible and avoid schema or response-shape changes.

### Good destructive-action confirmation

> I need confirmation before deleting these files because this may remove migration history. Should I delete only generated artifacts, or remove the full directory?

### Bad clarification

> Can you clarify your requirements?

Too vague.

### Bad assumption dump

> Here are my assumptions: A, B, C, D, E, F, G...

Too much friction.

### Bad over-asking

> Should I fix the typo?

The default is obvious and reversible.

## Coding-agent-specific policy

For code tasks, default to:

- Minimal safe change
- Preserve existing behavior unless the user asks to change it
- Preserve public API compatibility
- Add or run relevant tests when available
- Avoid destructive commands
- Avoid broad refactors unless requested
- Prefer repo conventions over generic best practices

Ask before:

- Broad refactors
- Public API changes
- Database schema changes
- Auth/security behavior changes
- Permission model changes
- Data deletion
- Migration deletion
- Large dependency changes
- Production-impacting config changes
- Reformatting many unrelated files
- Changing behavior not directly needed for the task

Do not ask before:

- Reading files
- Searching code
- Running safe tests
- Making small local fixes
- Adding focused tests
- Editing comments or docs
- Refactoring locally while preserving behavior

## During execution

If a new high-impact assumption appears during work, pause and apply the same decision rule.

Only interrupt if the new assumption satisfies all clarification criteria.

Use:

> New thing to confirm: [specific ambiguity]. Should I assume [A] or [B]?

If the new assumption has a safe default, state it briefly and continue.

## Final response

Only include assumptions in the final response if they remain material to interpreting the result.

Useful final format for complex tasks:

```text
Implemented:
- ...

Validated:
- ...

Assumptions/defaults used:
- Kept public API behavior unchanged.
- Treated existing tests as the source of truth.

Still uncertain:
- ...
```
