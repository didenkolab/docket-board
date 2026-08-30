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
columns, a backlog, a linked wiki and a graph. Neither view is a export of the other; there is
one set of files.

## Start here

- [[vault-format]] — what a vault is, normatively. One project, one repository, one vault.
- [[workspace]] — how several projects become one vault without merging their repositories.
- [[0001-vault-as-source-of-truth]] — why files and not a database.
- [[roadmap]] — what exists and what comes next.

## The shape of it

```
tasks/ACME-12.md      a task: flat YAML frontmatter, Markdown body, comments at the end
docs/                 a wiki: any tree of pages, connected by [[wikilinks]]
boards/board.base     a view: cards grouped by status, rendered by core Obsidian
project.yaml          the project's vocabulary: statuses, types, priorities
```

Git is the history. `git log -p tasks/ACME-12.md` is the audit trail. `git clone` is the
export.
