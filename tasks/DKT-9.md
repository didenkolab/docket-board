---
key: DKT-9
title: Import from Jira and Confluence
type: epic
status: Backlog
status_category: todo
priority: normal
assignee: 
labels: [import]
created: 2026-08-30T16:10:54Z
updated: 2026-08-30T16:10:54Z
aliases: []
---

A pipeline of `extract → plan → apply`: pull a cold snapshot of the source system, propose
mappings for fields, statuses, types and people, then write the vault in one reviewable commit.
Only `extract` touches the network, so a mapping can be redone any number of times without
going back to the source.

The constraints this places on the core are already honoured by [[vault-format]]: `aliases`
for keys that outlived their system, the `x_` prefix for foreign fields, status as a pair so
a cancelled-in-done workflow survives the trip, and `_history/` for a history git never saw.

An earlier private prototype has a working extractor, an ADF-to-Markdown converter and an
attachment store. Porting them means stripping every example, fixture and mapping that names
a real instance, project or person.

## Acceptance

- [ ] A snapshot is self-contained: `plan` and `apply` run offline against it.
- [ ] `apply` produces one commit that can be reviewed and reverted whole.
- [ ] Imported tasks pass [[DKT-6]].
- [ ] No fixture, test or document in the repository names a real instance, customer or person.

## Comments
