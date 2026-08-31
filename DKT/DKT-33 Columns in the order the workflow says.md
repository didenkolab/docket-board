---
key: DKT-33
title: Columns in the order the workflow says
type: bug
status: Backlog
status_category: todo
priority: high
assignee: agent/claude
labels: ["[[obsidian]]", "[[format]]"]
created: 2026-08-31T01:10:44Z
updated: 2026-08-31T01:10:44Z
aliases: []
tags: []
---

Obsidian drew the board's columns in alphabetical order. On the testbed that is Business
Review, then Discovery, then QA Stage — a pipeline shown in an order that means nothing.

Bases groups by a value and sorts the groups ASC or DESC. There is no third option and no way
to hand it an order, so the order has to be inside the value. The board now groups by a
formula that puts the stage number in front of the name, and the number is also the answer to
«which stage is this».

That made a third thing worth doing. A board is generated from `docket.yaml`, so a stale one is
not two things a person meant — it is our own output, out of date. `docket check` reports it and
`--fix` rewrites it; deleting the first line of a board is how a vault says the file is its own.
Without that, this fix would have reached no existing vault.

## Acceptance

- [x] Columns in the order `docket.yaml` lists the statuses, in Obsidian.
- [x] A generated board that has drifted is a finding, and `--fix` settles it.
- [x] A board somebody has taken over is left alone.
- [x] Verified in Obsidian 1.13.7, not in the documentation.

## Comments
