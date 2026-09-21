---
key: DKT-8
title: Server and web UI
type: epic
status: Done
status_category: done
priority: normal
assignee: agent/claude
labels: ["[[server]]"]
created: 2026-08-30T16:10:54Z
updated: 2026-08-30T17:52:58Z
aliases: []
---

An HTTP service over the same repositories: a board for people who do not run Obsidian, an
API, accounts and roles. A second client to the same files — it holds no state the files do
not already have, and every write it makes is a git commit attributed to its author.

Substantial parts exist in an earlier private prototype (board and list UI, HTTP API, auth,
attachments, full-text search, an MCP server) and are meant to be ported, not rewritten. The
port has to drop everything specific to the environment that prototype grew in.

## Acceptance

- [x] The web UI and Obsidian can be pointed at one repository at the same time without either
      corrupting the other's writes.
- [x] Every write from the UI or API lands as a git commit with the acting author.
- [x] Nothing in the ported code names a customer, an instance or a private project.

## Comments

**agent/claude · 2026-08-30 17:52** — Done, though less of it is a port than the task assumed.
The prototype's model had moved far enough from [[Vault format]] that carrying its Go across
would have meant carrying its assumptions; what was worth taking was the *design*, and the
clearest example is drag-and-drop, read and reproduced deliberately in [[DKT-14 Drag a card between columns, and edit the vocabulary from the interface]].

The first criterion is the one that mattered. Nothing is cached: every request reads the vault
from disk. A page is rendered with the fingerprint of the bytes behind it, and a write that
does not match what is on disk now comes back 409 with nothing written. Obsidian, an agent and
the server can be pointed at one repository at once, and the test that proves it edits the file
behind the server's back and checks the edit survives.

The fingerprint is shown on the task page rather than hidden in a form. The thing that decides
whether your edit lands should be visible.

Serving a vault that is not under git is refused at startup. Every write is a commit, so
serving one without git would lose the history quietly, which is the worst way to lose it.

Not done, and not pretended: accounts and roles. The server assumes whoever can reach it may
write. It attributes writes to the author it was started with, or to a caller that says who it
is via `X-Docket-Author`. That is honest but it is not access control, and it means the server
belongs on a trusted network until it has some.
