---
key: DKT-26
title: A board across several repositories
type: story
status: Backlog
status_category: todo
priority: urgent
assignee: agent/claude
labels: [server, format]
created: 2026-08-30T22:18:11Z
updated: 2026-08-30T22:18:11Z
aliases: []
---

[[purpose]] §1 says a repository is a project, the way a Space is a project in Jira, and that a
board shows several of them by reading several repositories.

It does not. `docket serve` opens exactly one repository. `docket workspace` clones several
project repositories side by side and Obsidian opens the result as one vault — that half works,
and the graph crosses the projects. But the server refuses the workspace root, because there is
no `docket.yaml` and no `.git` there, so there is no board across projects that live apart.

Today "one board, several projects" means "several projects in one repository". That is a real
arrangement and it works, but it is not the one [[purpose]] describes, and it makes a project
something you cannot hand over on its own.

The design question is where the columns come from, since each repository carries its own
`docket.yaml`. The answer that does not create a second source of truth: the board shows the
union of the statuses the projects use, and every card is validated against its own project's
configuration and workflow. A card can only move to a status its project has, which the drag
machinery already expresses per card.

## Acceptance

- [ ] `docket serve` accepts a workspace root and serves every project in it.
- [ ] A write goes to the repository that owns the task, as a commit there.
- [ ] Columns are the union of the projects' statuses; a move is checked against the card's own project.
- [ ] `docket check` and `docket mcp` work over a workspace as well.
- [ ] Each repository stays independently openable in Obsidian and independently valid.

## Comments
