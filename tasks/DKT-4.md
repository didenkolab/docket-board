---
key: DKT-4
title: docket init — scaffold a vault
type: task
status: Backlog
status_category: todo
priority: normal
assignee: 
parent: DKT-2
labels: [cli]
created: 2026-08-30T16:10:54Z
updated: 2026-08-30T16:10:54Z
aliases: []
---

Create a new project vault from embedded templates: `project.yaml` with a chosen key and a
default status set, `tasks/`, `docs/`, the `boards/*.base` views, `templates/`, `AGENTS.md`
and a minimal `.obsidian/` so the result opens as a working vault immediately.

The templates ship inside the binary rather than as a template repository — one fewer thing to
keep in sync, and `init` works offline.

## Acceptance

- [ ] `docket init --key ACME --name "Acme Platform"` produces a vault that opens in Obsidian
      and renders a board with no plugins installed.
- [ ] The result passes [[DKT-5]].
- [ ] Running it in a non-empty directory refuses rather than overwrites.

## Comments
