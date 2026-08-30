---
key: DKT-11
title: Stop the embedded templates from drifting away from this vault
type: task
status: Ready
status_category: todo
priority: normal
assignee: 
parent: DKT-2
labels: [cli, format]
created: 2026-08-30T16:42:41Z
updated: 2026-08-30T16:42:41Z
aliases: []
---

[[DKT-4]] baked a template tree into the binary: `boards/*.base`, `templates/task.md`,
`AGENTS.md`, `.obsidian/*`, `project.yaml`. This vault has its own copies of all of them, and
they were copied by hand.

They will drift. The first time a board gains a column here and the template does not, every
vault created afterwards is subtly wrong, and nothing says so.

Two ways out, and the choice is part of the task. Generate this vault's files from the same
templates, which makes the tool a build dependency of its own board. Or leave both and add a
test that compares them and fails on divergence, which is cheaper and keeps the vault usable
without the binary — likely the right one, given [[0001-vault-as-source-of-truth]] insists the
tool never becomes a gate.

## Acceptance

- [ ] Changing a shared file in one place and not the other fails CI.
- [ ] The failure message says which file diverged and where the two versions are.
- [ ] This vault still works with no binary installed.

## Comments
