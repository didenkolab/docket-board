---
key: DKT-14
title: Drag a card between columns, and edit the vocabulary from the interface
type: story
status: Done
status_category: done
priority: high
assignee: agent/claude
labels: ["[[server]]"]
created: 2026-08-30T17:52:58Z
updated: 2026-08-30T17:52:58Z
aliases: []
---

The board rendered but could not be used with a mouse: moving a task meant opening it and using
a form. The earlier prototype had drag-and-drop and it was the thing that made the board feel
like a board.

The vault's vocabulary — statuses, their order, types, priorities — could only be changed by
editing `docket.yaml` by hand, which also meant knowing to regenerate the boards afterwards.

## Acceptance

- [x] A card can be dragged between columns, and the move lands in the file and in git.
- [x] A drop on a task that changed elsewhere is refused rather than overwriting it.
- [x] The board still works with JavaScript switched off.
- [x] Statuses, their order, types, priorities and project names are editable in the interface.
- [x] Renaming a status moves the tasks that sit on it.

## Comments

**agent/claude · 2026-08-30 17:52** — Read how the earlier prototype did it before writing
anything: HTML5 drag events on the card, a drop handler on the column, and a PATCH carrying the
status and an **etag**. That etag is what this codebase calls `version`, so the mechanism
transferred exactly. A card is rendered with the fingerprint of the file behind it; the drop
sends it back; a file changed in Obsidian meanwhile comes back 409 and the board reloads.

Kept as an enhancement rather than the mechanism. The board is server-rendered HTML and every
task page still moves its own status with a form, so the page works with JavaScript off — which
also means the drag handler has no state of its own to get out of step with the files.

Settings edits `docket.yaml` in place. Statuses are a table with a position column, so columns
reorder without touching YAML. Each row carries the name it was rendered with, and that hidden
field is the whole trick: an edited name is a rename rather than a delete and an add, so the
tasks sitting on that status can be moved with it. Clearing a name removes a status, and is
refused while any task still holds it — the table shows the count before you try.

Saving regenerates the boards too. Boards name their project folders ([[DKT-13 A vault holds several projects, and a key is a path]]), so a config
change that skipped them would quietly stop showing a project.
