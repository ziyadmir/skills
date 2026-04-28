# record-context — Evals

Regression cases for the recorder subprocess. When changing the prompt or the hook script, mentally run through these and confirm the expected outcome.

## E1 — Empty conversation

**Setup:** transcript with only an assistant greeting and no user content.
**Expected:** subprocess exits without writing. Log shows `done` with no commit. Push step says `nothing to push`.

## E2 — User restates known fact

**Setup:** transcript where the user says "I work at Roblox" and `~/.context/user.md` already records this.
**Expected:** no commit. Conservative bias holds.

## E3 — User shares novel reference

**Setup:** transcript where the user says "we track ads-moderation incidents in the #ads-trust Slack channel."
**Expected:** subprocess updates or creates `~/.context/references.md`, adds index entry to `~/.context/MEMORY.md`, commits with `auto:`-prefixed message, push succeeds.

## E4 — User issues correction

**Setup:** transcript where the user says "stop summarizing what you just did at the end of every response."
**Expected:** subprocess appends a Feedback entry under `~/.context/feedback.md` with **Why** + **How to apply** lines. Commits and pushes.

## E5 — Simultaneous hook fires (single-flight)

**Setup:** two `Stop` events fire within a few seconds.
**Expected:** first acquires `~/.context/.recorder.lock`; second logs `another recorder running (pid X); skipping` and exits 0. No corrupted state.

## E6 — Subprocess crash mid-run

**Setup:** kill the spawned `claude -p` while it's running.
**Expected:** parent shell exits, `trap` removes the lock file, no partial commit. Log entry stops at the crash point but the next hook fire works normally.

## E7 — Manual commit waiting to push

**Setup:** user manually edits a file in `~/.context/` and commits but does not push. Then a Stop hook fires.
**Expected:** subprocess decides "nothing new" and doesn't commit. The post-subprocess push safety net detects the unpushed commit and pushes it. Log line: `pushing 1 commit(s) to origin/main`.

## E8 — Recursion guard

**Setup:** the spawned `claude -p` itself finishes and triggers a Stop event.
**Expected:** the second hook invocation sees `CLAUDE_CONTEXT_RECORDER=1` in env and exits 0 immediately. No infinite loop.

## E9 — Sensitive-info filter

**Setup:** transcript contains internal Roblox technical detail (e.g., model architecture, employee names).
**Expected:** subprocess skips it per the "DO NOT save sensitive Roblox-internal info" rule. No commit.

## E10 — Network failure during push

**Setup:** disable network mid-run.
**Expected:** subprocess's own push fails; safety-net push also fails; log records `push failed`. Local commit remains; next hook fire's safety net catches up and pushes.
