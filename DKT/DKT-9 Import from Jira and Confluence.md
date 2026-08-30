---
key: DKT-9
title: Import from Jira and Confluence
type: epic
status: Done
status_category: done
priority: normal
assignee: agent/claude
labels: [import]
created: 2026-08-30T16:10:54Z
updated: 2026-08-30T17:52:58Z
aliases: []
---

A pipeline of `extract → plan → apply`: pull a cold snapshot of the source system, propose
mappings for fields, statuses, types and people, then write the vault in one reviewable commit.
Only `extract` touches the network, so a mapping can be redone any number of times without
going back to the source.

The constraints this places on the core are already honoured by [[vault-format]]: `aliases`
for keys that outlived their system, the `x_` prefix for foreign fields, status as a pair so
a cancelled-in-done workflow survives the trip, and `_history/` for a history git never saw.

## Acceptance

- [x] A snapshot is self-contained: `plan` and `apply` run offline against it.
- [x] `apply` produces one commit that can be reviewed and reverted whole.
- [x] Imported tasks pass [[DKT-6 docket check — validate a vault]].
- [x] No fixture, test or document in the repository names a real instance, customer or person.

## Comments

**agent/claude · 2026-08-30 17:52** — Done. Nothing is interpreted on the way in: objects are
stored as the API returned them, so a decision made at mapping time cannot be blocked by a
field that looked uninteresting during extraction. An interrupted run resumes by project.

`plan` proposes and never decides. Statuses keep the team's own names, because those are worth
more than a tidy set; the category comes from the source's own three-way grouping, which is
what carries a cancelled-in-done workflow across intact. Custom fields with no values anywhere
are proposed for dropping and the rest land on `x_` properties. The people section says in the
file that it is personal data and wants a human eye.

Two converters, and neither loses text silently. An unknown ADF node becomes a visible marker
naming its type — a silent hole in an imported description is worse than an ugly one, because
nobody goes looking for text they were never told went missing. Confluence query macros
(`children`, `pagetree`, `recently-updated`) become a note saying what stood there: a space's
whole navigation can hang off one, and it is a query rather than text, so it cannot be carried.

The third criterion is met by a test that imports a synthetic snapshot and runs [[DKT-6 docket check — validate a vault]] over
the result.

**Not verified against a live instance.** There is none to point it at, and pointing it at a
real one is exactly what this repository must not do. Extraction is exercised against a stub
server covering pagination, resume and rate limiting; everything downstream runs against
snapshots built in tests. The REST shapes follow the published API, and the first real run
should be treated as the first real test.
