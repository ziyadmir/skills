# record-context — Calibration examples

Examples that pin down what counts as "meaningful learning" worth saving vs. what should be skipped. The hook's subprocess should err conservative.

## SAVE — these are durable, surprising, or specific

### User identity / role
> "I work at Roblox as an engineer on the ads team working on ads moderation AI."

→ Update `~/.context/user.md` and `~/.context/work/roblox.md`. Role + employer + team + domain.

### Stated priorities
> "I care about my work and money the most! and how to think about these things."

→ Update `~/.context/user.md` with framing preference. Reason: explicit redirect from a generic question to a personal-leverage frame.

### Validated approach (quiet confirmation)
> *(after I delivered a "what's in it for you" framing)* "yes that lands, keep going."

→ Append to `~/.context/feedback.md` with **Why** (user explicitly validated) + **How to apply** (default to this framing).

### External reference
> "Bugs for the ad pipeline are tracked in Linear project INGEST."

→ `~/.context/references.md`. Pointer that future-Claude needs to know exists.

### Constraint or deadline
> "We have a freeze on shipping new ML models after May 1 because of the kids-safety audit."

→ `~/.context/projects/<project>.md`. Convert relative dates to absolute. Include **Why** (audit) so future-Claude can reason about edge cases.

## SKIP — these are ephemeral, derivable, or noise

### Code/architecture details
> "The classifier is in `services/ads/moderation/v2/classifier.py`."

→ Skip. Read the repo. File paths rot.

### In-progress task state
> "I'm currently debugging the latency regression."

→ Skip. Ephemeral. By next conversation, this is stale.

### Generic preferences without specificity
> "Be helpful."

→ Skip. Not actionable.

### Information already captured
> User says "I'm a Roblox engineer" but `~/.context/user.md` already records this.

→ Skip. Read first; don't duplicate.

### Pleasantries / acknowledgments
> "thanks!", "sounds good", "ok cool"

→ Skip. Not learning.

### Sensitive Roblox-internal info
> Internal model architecture details, undisclosed product plans, employee names.

→ Skip even if technically "new." Repo is private but treat as if it could leak.

## Borderline — when in doubt, do not save

If you're 50/50 on whether something is durable or material, skip it. Future runs of the hook will catch it again if it matters. False negatives are cheap; false positives clutter `.context/` and dilute signal.
