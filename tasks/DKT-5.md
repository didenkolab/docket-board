---
key: DKT-5
title: docket new — create a task with a valid key
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

Allocate the next key by scanning `tasks/` for the highest number, fill `templates/task.md`,
and write the file. Timestamps in UTC, `status` and `status_category` taken as a pair from
`project.yaml` so they cannot drift apart.

No counter file — see the reasoning in [[vault-format]] §2.

## Acceptance

- [ ] `docket new "Fix login redirect loop" --type bug` writes a valid task and prints its key.
- [ ] The command refuses when `project.yaml` does not list the requested type, status or
      priority.
- [ ] Concurrent creation in two branches produces a git conflict, not a lost task — covered
      by a test.

## Comments
