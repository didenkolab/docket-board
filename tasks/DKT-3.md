---
key: DKT-3
title: Pick the language for the tool and set up its repository
type: task
status: Ready
status_category: todo
priority: high
assignee: 
parent: DKT-2
labels: [cli]
created: 2026-08-30T16:10:54Z
updated: 2026-08-30T16:10:54Z
aliases: []
---

The `docket` repository exists but holds only a README. Before any command is written, settle
what it is written in and how it is distributed.

The earlier private prototype was Go, and stage 3 and stage 4 in [[roadmap]] plan to port
substantial parts of it — an importer and an HTTP server — rather than rewrite them. That is
an argument for Go, not a decision.

Distribution matters as much as language: the tool has to be trivially installable for someone
who just cloned a vault, or people will keep editing by hand and the validation will never run.

## Acceptance

- [ ] Language and distribution decided, with the reasoning written to `docs/decisions/`.
- [ ] The tool repository builds and runs a `--version` command in CI.

## Comments
