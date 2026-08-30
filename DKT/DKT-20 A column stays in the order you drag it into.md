---
key: DKT-20
title: A column stays in the order you drag it into
type: story
status: Backlog
status_category: todo
priority: high
assignee: agent/claude
labels: [board, format]
created: 2026-08-30T19:31:33Z
updated: 2026-08-30T19:31:33Z
aliases: []
---

The board had drag-and-drop and no order. A card dropped above another moved on screen and
snapped back on reload, because a column was sorted by key and nothing else. That is not a
board — it is a list with an animation.

`order` is now a property on the task, described in [[vault-format]] §3.2. A task without one
sorts after every task that has one, so a vault nobody has arranged is a vault sorted by key,
which is what a board looks like until somebody drags a card. Nothing has to migrate.

The alternative — a list of keys per column, in `docket.yaml` or beside it — was rejected for the
reason [[0001-vault-as-source-of-truth]] gives about everything else: it is a second source of
truth. A rename, a merge, or a task moved in Obsidian puts it out of step with the tasks it
orders, and nothing says so. A number travels with the task it describes.

The API takes the neighbour by key — `after: "ACME-4"`, or `""` for the top — rather than an
index, because between drawing the board and letting go of a card the column may have changed,
and "after ACME-4" survives that where "third from the top" quietly means something else.

## Acceptance

- [x] Dragging a card within a column persists, and survives a reload.
- [x] Dragging into another column carries the position, in one commit with the status.
- [x] A column nobody has touched reads oldest first.
- [x] Numbers are spaced, so one drag normally rewrites one file.
- [x] When a gap runs out the column is renumbered, in the same commit.
- [x] Placing after a task that is not in the column is refused with a reason.

## Comments
