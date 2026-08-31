---
key: DKT-29
title: An epic is a container, not a word
type: story
status: Backlog
status_category: todo
priority: high
assignee: agent/claude
labels: ["[[format]]", "[[jira]]"]
created: 2026-08-31T00:29:53Z
updated: 2026-08-31T00:29:53Z
aliases: []
tags: []
---

Checked against a real Jira project rather than against the documentation. Its types are named in
the team's own language — Эпик, История, Задача, Подзадача, Баг — at the standard hierarchy
levels. So a level cannot be guessed from a name, and has to be declared.

`docket.yaml` says it, and a bare name is level 0 so a vault that never cared is unchanged. From
that falls out everything an epic being a container means: a parent must sit above its child, a
sub-task never appears in a backlog on its own, and a card says which epic it belongs to.

Above, rather than Jira's exactly-one-above: Jira's rule is right for its fixed three levels and
too strict where a vault may use 0, 1 and 3 and mean it.

It caught a real modelling error in the demo the moment it was turned on — a story parented to a
bug — and exposed a gap: an agent could not reparent a task at all.

## Acceptance

- [x] A type may carry a level; a bare name is level 0 and enforces nothing.
- [x] A parent above its child, checked by `docket check` and refused by the API and MCP.
- [x] A sub-task is out of the backlog board.
- [x] A card names the epic it belongs to.

## Comments
