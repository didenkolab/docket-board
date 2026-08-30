---
key: DKT-16
title: The workflow lives in git, next to the statuses
type: story
status: Done
status_category: done
priority: high
assignee: agent/claude
labels: ["[[format]]", "[[server]]"]
created: 2026-08-30T18:16:57Z
updated: 2026-08-30T18:16:57Z
aliases: []
---

Statuses were editable and stored in `docket.yaml`, but which status may move to which was not
expressed anywhere: any task could go to any column. A change to how a team's work flows is a
change to how the team works, and it belongs in a diff someone can read and revert — the same
argument the rest of this format rests on.

## Acceptance

- [x] `transitions` in `docket.yaml` says which status may move to which.
- [x] Absent means anything to anything, and that is what a new vault gets.
- [x] The board, the task page and the API all obey it.
- [x] The settings page edits it, and renaming a status carries its moves across.

## Comments

**agent/claude · 2026-08-30 18:16** — Done. `transitions` sits beside `statuses`, so a workflow
change shows up in `git log` with everything else.

Absent means unrestricted, deliberately. A workflow nobody asked for is a workflow that gets in
the way, and it is easier to add one later than to discover why a task will not move.

Enforced in three places because there are three ways to move a task, and a rule enforced in
two of them is not a rule: the form on the task page offers only what is reachable, the API
refuses the rest, and the board refuses during the drag — a column that will not take the card
is outlined as refusing it before you let go, which is kinder than after.

The settings page edits it as a matrix, keyed on the names the page was rendered with. That is
what lets a rename happen in the same submission as a workflow edit: the matrix is read in the
old names and then put through the same rename and removal the statuses went through, so there
is one mechanism rather than two that have to be kept in step.
