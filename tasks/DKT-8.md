---
key: DKT-8
title: Server and web UI
type: epic
status: Backlog
status_category: todo
priority: normal
assignee: 
labels: [server]
created: 2026-08-30T16:10:54Z
updated: 2026-08-30T16:10:54Z
aliases: []
---

An HTTP service over the same repositories: a board for people who do not run Obsidian, an
API, accounts and roles. A second client to the same files — it holds no state the files do
not already have, and every write it makes is a git commit attributed to its author.

Substantial parts exist in an earlier private prototype (board and list UI, HTTP API, auth,
attachments, full-text search, an MCP server) and are meant to be ported, not rewritten. The
port has to drop everything specific to the environment that prototype grew in.

Blocked on [[DKT-3]]: the language decision governs whether a port is even the cheaper path.

## Acceptance

- [ ] The web UI and Obsidian can be pointed at one repository at the same time without either
      corrupting the other's writes.
- [ ] Every write from the UI or API lands as a git commit with the acting author.
- [ ] Nothing in the ported code names a customer, an instance or a private project.

## Comments
