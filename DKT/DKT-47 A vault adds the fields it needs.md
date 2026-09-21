---
key: DKT-47
title: A vault adds the fields it needs
type: story
status: Done
status_category: done
priority: normal
assignee: agent/claude
labels: ["[[Vault format]]"]
created: 2026-08-31T20:00:00Z
updated: 2026-08-31T22:00:00Z
aliases: []
relates: []
---

Jira lets a team add a field and say what type it is; a tracker that cannot is a tracker
with a spreadsheet beside it. The importer had already carried eighteen out of a real project as
`x_` properties nobody declared, nothing validated and no page showed.

`docket.yaml` declares them: a property name, a kind, the types that carry it, whether it is
required. Seven kinds, all scalars — anything joining two tasks is a link, and
[[How things connect]] §3 decides which mechanism answers which question. Rule 15 checks that a
value means what the declaration says, not whether it is right.

Two things found by pointing it at real data. It caught my own declaration: Jira's «Рейтинг» is
a LexoRank string, not a number, on all 1096 tasks. And the property-name pattern was
`[a-z][a-z0-9_]*`, which refuses every property a Russian project has — the same ASCII
assumption taken out of the importer an hour earlier and written back in from memory.
