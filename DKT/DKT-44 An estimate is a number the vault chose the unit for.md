---
key: DKT-44
title: An estimate is a number the vault chose the unit for
type: story
status: Done
status_category: done
priority: normal
assignee: agent/claude
labels: ["[[vault-format]]"]
created: 2026-08-31T17:00:00Z
updated: 2026-08-31T18:30:00Z
aliases: []
relates: []
---

An estimate is a scalar, so it is a field. That needs saying, because
[[how-things-connect]] is strict about fields that should have been links — and the test it
gives ("would this be an edge in the graph?") is one an estimate is supposed to fail. Nobody
standing at a task needs to know what else was estimated at three. `priority` is the precedent:
a property of a task, not a relationship.

What the vault decides is the unit and the scale. `estimates: {unit: points, scale: [1, 2, 3,
5, 8, 13]}` in `docket.yaml`; a team that counts hours says `unit: hours` and no scale, and gets
a free number. A declared scale means the interface offers those values and `docket check`
refuses anything else — the same shape as statuses and priorities, which are also a list the
vault chose.

## The one thing that is computed

A container's estimate is the sum of its children. Never stored: an epic carrying `estimate: 8`
whose tasks add to thirteen is two records of one fact, which is what [[purpose]] §4 exists to
refuse. So `docket check` refuses an estimate on a task that has children, and the interface
adds them up on the way past.

## Acceptance

- [x] `estimates` in `docket.yaml`: a unit, and a scale when the vault wants one.
- [x] `estimate` on a task, absent when nobody has said.
- [x] Off-scale values, and an estimate on a container, are findings.
- [x] The board totals a column; a container shows what its children add to.
- [x] It reads in Obsidian without the tool: a number in the properties, a column in the board.

## Comments

**agent/claude · 2026-08-31 18:30** — Built, and one thing about the totals is worth keeping.

A total that adds up every task double-counts the moment a container and one of its children are
both in the same column or the same sprint — the container's size *is* the child's. So a total
adds up what each task says about itself and nothing else, which is exact because rule 12
guarantees a container carries no number. The cost is that a container whose children are
elsewhere contributes nothing, so every total is shown beside how many of its tasks nobody has
sized. A total on its own reads as the whole of the work, and it never is.

Found by putting real data in [[the-testbed]]: it has two non-epic parents — a task with
sub-tasks and a story with one — which is the case anybody assuming "container means epic" would
have got wrong.
