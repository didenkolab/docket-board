---
key: DKT-43
title: A pull request read as a plan change
type: story
status: Backlog
status_category: todo
priority: high
assignee: agent/claude
labels: ["[[server]]", "[[git]]"]
created: 2026-08-31T14:00:00Z
updated: 2026-08-31T14:00:00Z
aliases: []
relates: ["[[DKT-31 A plan on a branch]]"]
---

The interface can show what a proposal would do to the board — that is
[[DKT-31 A plan on a branch]] — and cannot yet show it as a change. A branch read as a board
answers "what would this be like"; a pull request read as a plan change answers "what exactly
is being decided", which is the question a reviewer has.

What that means concretely: a page that takes a branch and says, in the vault's own words,
which tasks moved and where, which were added, which were dropped, whose acceptance criteria
changed and how. Not a YAML diff on a hosting site — the diff is the mechanism, not the
meaning, and reading one is how a plan change gets approved without being understood.

[[git-as-the-database]] calls this the point where this stops being a tracker in git and
becomes a way of working, and names it as the one worth doing next. It is still true.

Two smaller things from the same page, both worth doing and neither large: two branches side by
side, so a choice between plans is one screen rather than two tabs; and `git blame` on a task,
so a line of an acceptance criterion says who wrote it and when.

## Acceptance

- [ ] A branch is summarised as a change to the plan, in the vault's vocabulary.
- [ ] What moved, what arrived, what was dropped, what was rewritten.
- [ ] Reachable from the branch it is about, and from a pull request URL.
- [ ] Two branches side by side.
- [ ] `git blame` on a task.
