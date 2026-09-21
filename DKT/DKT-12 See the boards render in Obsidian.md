---
key: DKT-12
title: See the boards render in Obsidian
type: task
status: Done
status_category: done
priority: high
assignee: agent/claude
labels: ["[[format]]", "[[obsidian]]"]
created: 2026-08-30T17:12:13Z
updated: 2026-08-30T20:24:57Z
aliases: []
---

Every board in this vault and in the templates was written from the published Bases syntax and
had never been opened in Obsidian. The whole premise of [[0001-vault-as-source-of-truth]] is
that a person opens the folder and sees a board — and that half was assumed, not observed.

It was wrong. Opened in Obsidian 1.13.7, `boards/board.base` rendered nothing at all:

> Не удаётся обработать файл базы данных: в представлении "Board" "groupBy" должны быть типа object

`groupBy` was a mapping, so the message is not the reason. Obsidian's parser requires
`property` **and** `direction` together and names neither when one is missing. Adding
`direction: ASC` makes the board render.

The second finding came from the same session: a display name written the documented way —
`title:` under `properties:` — is accepted and silently ignored. The key is matched against the
qualified identifier that `order` uses, so it has to be `note.title`. Every column header read
as a raw property name until this was fixed, and nothing said why.

Both are recorded in [[Vault format]] §6, because the published reference is wrong about both
and the next person to write one of these files will hit them again.

The tables gained display names too, now that there is a form known to work.

## Acceptance

- [x] The three boards render, with columns and cards as intended.
- [x] Findings, if any, are fixed in both the vault and the templates.
- [x] [[Vault format]] §6 is corrected wherever the documented syntax turns out to be wrong.

## Comments
