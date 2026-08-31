---
key: DKT-31
title: A plan on a branch
type: story
status: Backlog
status_category: todo
priority: high
assignee: agent/claude
labels: ["[[git]]", "[[server]]"]
created: 2026-08-31T00:29:54Z
updated: 2026-08-31T00:29:54Z
aliases: []
tags: []
---

The largest thing in [[git-as-the-database]], and the one with no counterpart in any tracker.

A branch is a proposal about the plan — a release re-scoped, an epic split, a quarter dropped.
The Branches page lists them and opening one draws the board as it would be, read out of the
object database so that looking at a proposal cannot disturb whoever is working in the tree.

A separate route rather than a `?ref=` on every page. Reading a proposal and working in one are
different activities, and a separate way in is one that cannot be forgotten — the alternative
was threading a ref through seventy-odd read paths, any one of which could miss it and quietly
write to the tree.

Which is what this nearly got wrong: the board drawn from a branch still had its cards wired to
the API, so a drag would have written to the working tree. Checked by dragging one.

## Acceptance

- [x] Branches are listed, and a board can be drawn at any of them.
- [x] Reading a branch does not touch the working tree or check anything out.
- [x] Nothing can be written while looking at a proposal.
- [x] The board says which branch it is showing.

## Comments
