---
key: DKT-60
title: docket people --from-git cannot read a repository beside the vault
type: task
status: Backlog
status_category: todo
priority: normal
assignee: vadym
labels: []
created: 2026-09-07T20:13:36Z
updated: 2026-09-07T20:13:36Z
aliases: []
tags: []
---

`docket people --from-git` reads the git log of the vault it runs in. The people a project already has are the ones who committed to its code, which is a repository beside the vault, not the vault — so the flag cannot do what its own help text promises for a team whose board and code are two repositories (which is every team). The showcase had to compare `git log --format=%an` by hand.

Add `--repo PATH` (repeatable) and read those logs too.

## Acceptance

- [ ] `docket people --from-git --repo ../northlight .` in the showcase writes no new page (the six already exist) and lists the same six handles.
- [ ] The help text says where the names come from.

## Comments
