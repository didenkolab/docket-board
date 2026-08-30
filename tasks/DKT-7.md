---
key: DKT-7
title: docket workspace sync — assemble several projects into one vault
type: task
status: Backlog
status_category: todo
priority: normal
assignee: 
parent: DKT-2
labels: [cli, workspace]
created: 2026-08-30T16:10:54Z
updated: 2026-08-30T16:10:54Z
aliases: []
---

Read `workspace.yaml`, clone the projects that are missing and pull the ones that are present,
per [[workspace]]. Also `docket workspace init`, which creates the manifest, the `.obsidian/`
config and a `.gitignore` that excludes every project folder.

Deliberately not submodules — the reasoning is in [[workspace]].

## Acceptance

- [ ] `docket workspace sync` is idempotent and safe to run over a workspace with local changes:
      it refuses to touch a project with a dirty tree rather than stashing or resetting.
- [ ] The generated `.gitignore` keeps project folders out of the workspace repository.
- [ ] Opening the workspace folder in Obsidian resolves `[[wikilinks]]` across projects.

## Comments
