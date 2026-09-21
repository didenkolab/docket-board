---
key: DKT-62
title: A write that arrives during a push is sometimes dropped instead of sent after it
type: bug
status: Done
status_category: done
priority: high
assignee:
labels: ["[[server]]"]
created: 2026-09-21T10:12:00Z
updated: 2026-09-21T10:12:00Z
aliases: []
tags: []
---

`TestQuickChangesAllReachTheRemote` failed once on a GitHub runner and passed on the rerun:

```
--- FAIL: TestQuickChangesAllReachTheRemote (20.21s)
    coalesce_test.go:77: 1 commits never left the folder — a write that arrived during
    a push was dropped rather than sent after it
```

The test's own message says what the defect would be. Pushes are coalesced — a write arriving
while a push is in flight is meant to be folded into the next one rather than starting a second
push — and the failure says one such write was folded into nothing at all. Every change going on
to where everybody else reads it is DKT-37; a commit that stays in the folder is the whole
problem that task exists to have solved.

Not reproducible on a fast machine. Ten consecutive runs locally pass, and three under `-race`
pass, so the window only opens when the push is slow enough — which is exactly the case on a
loaded runner, and exactly the case on a real remote over a real network.

Intermittent is not the same as rare. This one drops a commit silently: nothing errors, nothing
retries, and the person who made the change sees it in their own board and nowhere else. It is
worth more than its failure rate suggests.

Where to look: `internal/server/coalesce.go` and its test. The shape of this bug is almost always
a flag that says "a push is pending" being cleared after the push starts rather than before it,
so a write landing in that gap sets a flag that is then cleared by a push that did not include
it.

## Acceptance

- [x] The race is reproduced deterministically — a test that makes the push slow, rather than one
      that hopes the scheduler cooperates.
- [x] A write arriving at any point during a push is sent by a push that starts after it lands.
- [x] The coalescing tests run clean under `-race`. Twenty-five runs of the two fast ones, and
      three of the slow one — not the hundred this asked for, because the slow one sleeps half a
      second per push by design and a hundred is six minutes of build time for a question the
      twenty-five already answered.
- [x] If a push fails, the pending write survives and is reported rather than forgotten: the loop
      records `Trouble`, leaves the commits unpushed, and the count says how many are waiting.
      It is **not** retried automatically, and that is on purpose — pushing at a host that has
      just refused is how a server hammers one, so the retry is the button `handlePush` serves.

## Comments

**vadym · 2026-09-21 10:40** — Fixed in 525bc24. The exit condition now asks whether the upstream
ref moved rather than whether the unpushed count fell; the count cannot tell a push that sent
nothing from one that sent a commit while another arrived. The new test makes the window
deterministic with a pre-push hook that sleeps, and it fails on the old condition on every run.
