---
key: DKT-13
title: A vault holds several projects, and a key is a path
type: story
status: Done
status_category: done
priority: high
assignee: agent/claude
labels: ["[[format]]", "[[server]]"]
created: 2026-08-30T17:52:58Z
updated: 2026-08-30T17:52:58Z
aliases: []
---

Two things were wrong once the board was real.

A board has to show several projects at once — work crosses them constantly — and [[workspace]]
only solved that for Obsidian. The web board served exactly one vault, which is not a board.

And `ACME-12` spent a separator on something the filesystem already expresses. The project is a
container; a hyphen pretends it is part of a name.

Reasoning and rejected alternatives: [[0003-a-vault-holds-several-projects]].

## Acceptance

- [x] A key is `PROJECT/NUMBER` and it is the path: `ACME/12` lives in `ACME/12.md`.
- [x] One vault holds many projects, each a folder listed in `docket.yaml`.
- [x] The web board shows every project at once and narrows to one on demand.
- [x] This vault is migrated and still passes `docket check`.

## Comments

**agent/claude · 2026-08-30 17:52** — Done, and it touched everything: `project` now reads
`docket.yaml` rather than `project.yaml`, `vault` walks project folders, `check` grew a ninth
rule, the server routes on two path segments, and the importer writes the new layout.

The gain that justified the churn: `[[ACME/12]]` resolves in Obsidian with no help from us,
because Obsidian reads a wikilink containing a slash as a vault-relative path. Under the old
layout the same link needed an alias on every task, which is machinery to make a link work that
the filesystem was willing to make work for free.

The vocabulary is shared by every project in a vault rather than defined per project. A
combined board over disagreeing status sets would have to invent a merged one, and whatever it
invented would be wrong for one of them.

Rule 9 is new and exists because this layout has two new ways to lose work quietly: a folder
full of tasks that `docket.yaml` never declared, and a project no board mentions. Both are
invisible rather than broken, which is worse.

The cost is real and accepted: Obsidian's graph shows bare numbers, since a note's display name
is its file name. The board and the file explorer both show more.

This vault migrated in one commit — 12 tasks moved from `tasks/DKT-N.md` to `DKT/N.md`, every
`DKT-N` reference rewritten. The closed tasks were left describing the world as it was when
they closed; a record edited to match what happened later records nothing.
