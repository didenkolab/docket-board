---
key: DKT-19
title: An agent drives the vault over MCP
type: story
status: Done
status_category: done
priority: high
assignee: agent/claude
labels: [agents, server]
created: 2026-08-30T19:07:04Z
updated: 2026-08-30T19:07:04Z
aliases: []
---

An agent can already do everything by editing files, and that is the point of the format —
[[0001-vault-as-source-of-truth]] says the files are the product. But every write has four ways
to go subtly wrong: pick a key another branch already took, change `status` without
`status_category`, make a move the workflow forbids, forget that retitling renames the file.
Each is a corruption that `docket check` finds afterwards rather than a mistake the vault
prevents.

`docket mcp` makes each of those one call that either succeeds or explains itself, over JSON-RPC
on stdin and stdout. It is a second client to the same files, like the server in
[[DKT-8 Server and web UI]] — nothing is cached, every write is a git commit attributed to the
agent that made it, and the workflow from [[DKT-16 The workflow lives in git, next to the statuses]]
applies unchanged.

Optimistic concurrency is the part that matters. `get_task` hands back the same fingerprint the
board draws its cards from, and `update_task` refuses a write whose fingerprint no longer
matches. An agent that read a task, thought for a minute and wrote it back cannot silently
discard the edit somebody made in Obsidian meanwhile.

## Acceptance

- [x] `docket mcp --author "Name <email>"` speaks the protocol on stdin and stdout.
- [x] Eight tools: list_tasks, get_task, create_task, update_task, search, read_page,
      write_page, check.
- [x] Every write is a git commit authored by `--author`, which is required.
- [x] A stale `version` is refused and nothing is written.
- [x] A move the workflow forbids is refused, and the refusal names the moves it allows.
- [x] Renaming on a title change goes into the same commit, so `git log --follow` works.
- [x] A round trip is covered by tests: initialize, tools/list, tools/call.

## Comments
