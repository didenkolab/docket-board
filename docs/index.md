---
title: docket
type: page
updated: 2026-08-30
---

# docket

A task tracker and a knowledge base that live in a git repository as Markdown files, and open
in Obsidian as a board and a wiki.

Built for agents first. An agent creates a task by writing a file and moves it by editing two
lines — no API, no schema it cannot read. The same folder, opened in Obsidian, is a board with
columns, a backlog, a linked wiki and a graph. Neither view is an export of the other; there
is one set of files.

## Start here

- [[vault-format]] — what a vault is, normatively.
- [[0001-vault-as-source-of-truth]] — why files and not a database.
- [[0003-a-vault-holds-several-projects]] — why a key is `PROJECT/NUMBER` and why one vault
  holds many projects.
- [[workspace]] — how several repositories become one Obsidian vault.
- [[roadmap]] — what exists and what comes next.

## The shape of it

```
docket.yaml            the projects, and the vocabulary they share
ACME/12.md            a task: flat YAML frontmatter, Markdown body, comments at the end
BETA/7.md             another project, same tree, links cross freely
docs/                 a wiki: any tree of pages, connected by [[wikilinks]]
boards/board.base     a view: cards grouped by status, rendered by core Obsidian
```

A key is the path, so `[[ACME/12]]` opens the task with no tool involved. Git is the history:
`git log -p ACME/12.md` is the audit trail, and `git clone` is the export.
