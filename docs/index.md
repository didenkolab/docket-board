---
title: docket
type: page
updated: 2026-08-30
---

# docket

A task tracker and a knowledge base that live in a git repository as Markdown files, and open
in Obsidian as a board and a wiki.

Built for agents first. An agent creates a task by writing a file and moves it by editing two
lines — no API, no schema it cannot read — or drives the same files over MCP when it would
rather one call did the validating and the committing. The same folder, opened in Obsidian, is
a board with columns, a backlog, a linked wiki and a graph. Neither view is an export of the
other; there is one set of files.

## Start here

- [[purpose]] — what this is for. Everything else is checked against it.
- [[git-as-the-database]] — why the store is a repository, and what that makes possible.
- [[vault-format]] — what a vault is, normatively.
- [[0001-vault-as-source-of-truth]] — why files and not a database.
- [[0003-a-vault-holds-several-projects]] — why one vault holds many projects.
- [[0004-access-comes-from-git]] — why there is no user table.
- [[0005-a-file-is-named-after-its-task]] — why a file is named after its task.
- [[workspace]] — how several repositories become one Obsidian vault.
- [[roadmap]] — what exists and what comes next.

To see a vault rather than read about one, clone
[docket-demo](https://github.com/vadymdidenkolab/docket-demo) and open it in Obsidian: two
projects, a board, a backlog and a wiki, with nothing installed.

## The shape of it

```
docket.yaml                              the projects, and the vocabulary they share
ACME/ACME-12 Fix login redirect loop.md a task: flat frontmatter, Markdown body, comments
BETA/BETA-7 Ship the widget.md          another project, same tree, links cross freely
docs/                                   a wiki: any tree of pages, connected by wikilinks
boards/board.base                       a view: cards by status, rendered by core Obsidian
```

A file is named after its task, so the graph and the file explorer say what everything is, and
`[[ACME-12 Fix login redirect loop]]` opens it with no tool involved. Git is the history:
`git log --follow -p` on the file is the audit trail, and `git clone` is the export.
