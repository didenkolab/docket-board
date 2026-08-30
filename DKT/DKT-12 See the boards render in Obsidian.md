---
key: DKT-12
title: See the boards render in Obsidian
type: task
status: Ready
status_category: todo
priority: high
assignee: 
labels: [format, obsidian]
created: 2026-08-30T17:12:13Z
updated: 2026-08-30T17:12:13Z
aliases: []
---

Every board in this vault and in the templates was written from the published Bases syntax and
has never been opened in Obsidian. The whole premise of [[0001-vault-as-source-of-truth]] is
that a person opens the folder and sees a board — and that half has been assumed, not observed.

The specific things to look at: does `boards/board.base` group into columns by `status`; does
the card show `title` rather than the file name, which is the trade [[vault-format]] §2 makes
when it names files after keys alone; does `file.inFolder("tasks")` do what the filter assumes;
do `[[DKT-4 docket init — scaffold a vault]]` and the `aliases` property resolve; and does a workspace folder holding several
project repositories open as one vault with nested `.obsidian` directories ignored.

Anything that turns out wrong is a fix in one `.base` file and in the template beside it, which
[[DKT-11 Stop the embedded templates from drifting away from this vault]] now keeps in step.

## Acceptance

- [ ] The three boards render, with columns and cards as intended.
- [ ] Findings, if any, are fixed in both the vault and the templates.
- [ ] [[vault-format]] §6 is corrected wherever the documented syntax turns out to be wrong.

## Comments
