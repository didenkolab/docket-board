---
key: DKT-37
title: Every change goes on to where everybody else reads it
type: story
status: Done
status_category: done
priority: urgent
assignee: agent/claude
labels: ["[[server]]", "[[git]]"]
created: 2026-08-31T14:00:00Z
updated: 2026-08-31T14:00:00Z
aliases: []
relates: ["[[DKT-34 A token belongs to a host; a role belongs to a repository]]"]
---

Every write is a commit, and that used to be where it stopped: the commits sat in whichever
clone the server happened to be running over. Somebody who took the project as a clone got
everything except what the board did, which undoes the premise.

Three decisions, and the reasoning is the substance.

**After every write, not on a button** — forgetting to press it is the failure being fixed.
**In the background, not in the request** — a card drag should not wait on the network.
**Visible** — a background push that fails silently is the same bug again, so the header says
how many commits are waiting and what went wrong. It says nothing when everything is sent,
because a badge that is always there is a badge nobody reads.

Somebody else having pushed first is reported, not repaired. Recovering means a rebase, and
rebasing a working tree a human may have open in Obsidian is how work gets lost.

The credential is the careful part. A token must not be in the URL or in a helper that echoes
it, because argv is readable by every process on the machine, and it must not be in a file,
because the sign-in page promises it never touches disk. So the helper is a snippet that reads
an environment variable and only the variable's **name** is an argument; the configured helpers
are cleared first, so nothing can store the token for us.

The push is made as whoever made the change, with their token for that repository's host — so
the remote's history says who did what.

## Acceptance

- [x] A change on the board reaches the remote without anybody asking.
- [x] What cannot be sent is said out loud, with a way to try again.
- [x] The token is in neither the command line nor the error text.
- [x] A repository with no remote is not a repository with a problem.
