---
key: DKT-6
title: docket check — validate a vault
type: task
status: Backlog
status_category: todo
priority: high
assignee: 
parent: DKT-2
labels: [cli]
created: 2026-08-30T16:10:54Z
updated: 2026-08-30T16:10:54Z
aliases: []
---

Implement the eight validation rules from [[vault-format]] §7 and report findings with file
and line. Rules 1–7 need only `tasks/` and `project.yaml`; rule 8 — link resolution — needs
the whole vault.

This is the rule that keeps the format honest once agents write most of the files. It should
be cheap enough to run on every commit.

## Acceptance

- [ ] All eight rules implemented, each with a test that fails without it.
- [ ] Exit code is non-zero when there are findings, so it works as a pre-commit hook.
- [ ] Running it on this repository reports nothing.

## Comments
