---
key: DKT-30
title: A release is a tag
type: story
status: Done
status_category: done
priority: high
assignee: agent/claude
labels: ["[[git]]", "[[server]]"]
created: 2026-08-31T00:29:54Z
updated: 2026-08-31T00:30:13Z
aliases: []
tags: []
---

Jira models a release three times: a version object, a `fixVersion` on every issue pointing at
it, and a generator that turns the two into notes. Three records of one fact.

Git already has the fact. A tag is the release, and what went into it is `git log v1.1.0..v1.2.0`
with the task files parsed — read each time the page is opened, so it cannot be out of date, and
nothing to set on a task.

Two things this got wrong first, both found by using it. `for-each-ref` has its own format
language and does not expand the `%x1f` that `git log` does, so every tag parsed as nothing. And
tags were ordered by when somebody typed them — tagging is often retroactive, and three releases
labelled in one afternoon have an order that means nothing.

## Acceptance

- [x] Releases are the repository's tags, ordered by the commit each points at.
- [x] What shipped is computed, not stored, and cannot be stale.
- [x] A task that first appeared in a release is marked as new.
- [x] A repository with no tags says what a release is.

## Comments
