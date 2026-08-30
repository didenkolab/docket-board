---
key: DKT-24
title: The first minute with a new vault
type: story
status: Backlog
status_category: todo
priority: high
assignee: agent/claude
labels: [server, cli]
created: 2026-08-30T21:40:48Z
updated: 2026-08-30T21:40:48Z
aliases: []
---

`docket init` told people to copy a template into `tasks/`, a directory that stopped existing
when a file started being named after its task, and never mentioned `docket new`.

A vault with nothing in it rendered six columns each saying "Nothing here". That is true and
useless: somebody's first minute with this should end with a task in it.

And six columns did not fit a 1280-wide window, so the last one was sliced down the middle with
nothing to say it was scrollable — which reads as a rendering fault. The floor is lower now, and
a board with more statuses than the window holds fades at the edge. The fade is measured by the
board script, so without JavaScript the board still scrolls and simply does not advertise it.

## Acceptance

- [x] `docket init` prints steps that work.
- [x] An empty board says what a first task would be called and offers to write one.
- [x] Six statuses fit a 1280-wide window; more than fit, fade at the edge.

## Comments
