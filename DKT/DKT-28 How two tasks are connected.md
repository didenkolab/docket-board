---
key: DKT-28
title: How two tasks are connected
type: story
status: Done
status_category: done
priority: high
assignee: agent/claude
labels: ["[[format]]", "[[jira]]"]
created: 2026-08-30T23:33:04Z
updated: 2026-08-30T23:33:22Z
aliases: []
tags: []
relates: ["[[DKT-25 Relationships are links, not fields]]"]
---

[[what-jira-models]] set Jira's model beside ours, and the largest gap was this: we could say two
tasks were connected and not **how**.

Jira ships five link types in a table with an admin screen over it. Here the property name is the
verb and the value is a link — `blocked_by: ["[[ACME-4 Session model]]"]` — so a relation is a
line of frontmatter that is already an edge in the graph and already shows in backlinks.

Seven, in inverse pairs, which is Jira's set minus `clones`: that describes how a task came into
existence rather than how it relates to the work, and git records it anyway.

They carry no structure, and the line is deliberate. `parent` decides what a board does; a
relation is an annotation a person acts on. Atlassian warns about this exact confusion because
several marketplace apps ship a link type called "Parent-Child" that is not the parent field.
`parent` is refused as a relation and there is a test that says so.

One exception: a card waiting on unfinished work is marked **blocked** on the board, because that
is the relation that changes what somebody picks up next.

## Acceptance

- [x] Seven relations, in inverse pairs, written as links.
- [x] Shown on the task page as a sentence, and offered through the API and MCP.
- [x] A card blocked by unfinished work says so; blocked by done work does not.
- [x] A relation to a task that does not exist is refused, and `docket check` reports one that
      points at nothing.
- [x] `parent` is not a relation.

## Comments
