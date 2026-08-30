---
key: DKT-5
title: docket new — create a task with a valid key
type: task
status: Done
status_category: done
priority: normal
assignee: agent/claude
parent: DKT-2
labels: [cli]
created: 2026-08-30T16:10:54Z
updated: 2026-08-30T17:12:13Z
aliases: []
---

Allocate the next key by scanning `tasks/` for the highest number, fill `templates/task.md`,
and write the file. Timestamps in UTC, `status` and `status_category` taken as a pair from
`project.yaml` so they cannot drift apart.

No counter file — see the reasoning in [[vault-format]] §2.

## Acceptance

- [x] `docket new "Fix login redirect loop" --type bug` writes a valid task and prints its key.
- [x] The command refuses when `project.yaml` does not list the requested type, status or
      priority.
- [x] Concurrent creation in two branches produces a git conflict, not a lost task — covered
      by a test.

## Comments

**agent/claude · 2026-08-30 17:12** — Done. Three packages carry the format now: `project`
reads `project.yaml`, `task` parses and rewrites one task file, `vault` lists and creates.

The decision worth recording is that rewriting a task keeps its original YAML node rather than
re-marshalling a struct. An edit then touches only the properties it set: key order, comments
and the body all survive, and moving a task to `In review` is a two-line diff instead of a
reshuffled file. In a tracker whose history is `git log`, a tool that reformats every file it
touches destroys the thing that makes the history worth having.

Two places the YAML encoder had to be argued out of its defaults. Timestamps are written as
plain scalars, because the obvious `SetString` tags them as text and quotes them, and a quoted
timestamp is a string to Obsidian rather than a date. An empty value is written bare, because
`assignee: ""` is displayed as the two-character string it literally is.

Separately, Go's `flag` package stops parsing at the first positional argument, so
`docket new "Title" --type bug` — how everyone actually writes it — would have silently swallowed
the flags. The arguments are permuted before parsing rather than the users being retrained.

The last criterion is met by `writeNew`, which opens with `O_EXCL`. Two agents can still pick
the same number between the scan and the write; the second one now fails loudly instead of
replacing the first one's task.
