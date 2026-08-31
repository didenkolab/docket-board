---
key: DKT-43
title: A pull request read as a plan change
type: story
status: Done
status_category: done
priority: high
assignee: agent/claude
labels: ["[[server]]", "[[git]]"]
created: 2026-08-31T14:00:00Z
updated: 2026-08-31T16:20:00Z
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

- [x] A branch is summarised as a change to the plan, in the vault's vocabulary.
- [x] What moved, what arrived, what was dropped, what was rewritten.
- [x] Reachable from the branch list and from the board drawn at a branch.
- [x] Reachable from a pull request URL, by resolving it to a branch.
- [x] Two branches side by side.
- [x] `git blame` on a task.

## Comments

**agent/claude · 2026-08-31 14:50** — The summary is built. Three decisions worth recording.

Compared against the merge base rather than the working tree: a proposal made a week ago has
not undone everything that happened since, and saying it did is worse than saying nothing.

A body change is counted in criteria rather than lines — "eleven lines changed" is the diff
again, and criteria are the part of a body that is a commitment. A body that changed without
touching any still reports that it was rewritten, because the wording of a task is its scope.

The vocabulary is reported apart and first: a proposal that adds a status is a proposal about
how the team works, and it is the thing most likely to be skimmed past in a diff.

On the testbed's real proposal it is five lines where the diff is about a hundred and twenty.

**agent/claude · 2026-08-31 15:00** — The two smaller things are done, and one detail is worth
keeping. Blame follows renames with `-C`: retitling a task moves its file, and a blame that
stopped at the rename would credit the whole task to whoever renamed it. On the first real task
I opened, the blame put the `updated:` line on a different commit from the rest — which is "who
moved this and when", answered by the storage rather than by an activity feed.

**agent/claude · 2026-08-31 16:20** — Done, and this task's own pull request is what it was
tested on: the address goes in the box on the branch list, the host is asked which branch, the
branch is fetched, and the change page opens on it.

Two things fell out of it. A proposal you are asked to review is somebody else's, so it is on
the remote and not in this clone — the branch list used to show only local branches, which
meant it showed your own proposals and none of the ones you were being asked about. It now
lists remote-tracking branches too, marked as being on the remote only, and fetches a single
ref rather than checking anything out, because somebody is working in the tree.

The other was found by looking at the page: git shortens `refs/remotes/origin/HEAD` to
`origin`, so the remote's symbolic HEAD arrived in the list looking exactly like a branch
called "origin". A ref with no slash in it is not a proposal.

A URL is somebody else's string, so it is checked before it is used: one for another host or
another repository names a branch that means nothing here, and a board drawn from it would be
another project's plan in this project's words.
