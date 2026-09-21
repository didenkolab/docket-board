---
key: DKT-66
title: The showcase release tags do not survive a rebuild
type: task
status: Backlog
status_category: todo
priority: normal
assignee:
labels: []
created: 2026-09-21T11:54:16Z
updated: 2026-09-21T11:54:16Z
aliases: []
tags: []
---
`docket-showcase` now carries `v0.1.0` through `v1.0.0`, tagged onto story commits so that the
release page has something to show. They were added by hand, after the fact.

`.showcase/build.py` resets to the `scaffold` tag and replays the story, which gives every commit
a new SHA. The release tags point at the old SHAs, so a rebuild leaves them dangling or pointing
at unrelated commits — and nobody will notice until the release page is empty again.

The story knows its own sprints, so the generator can cut the tags as part of the replay: at the
last commit of each sprint, annotated, authored by the person who would have cut it. Then a
rebuild produces them rather than losing them.

Related: [[DKT-63 The showcase README is fixed on main and stale at the scaffold tag]] — the same
class of drift, and the same rebuild pass should settle both.

## Acceptance

- [ ] `.showcase/build.py` creates the release tags as part of the replay.
- [ ] A rebuild produces the same five releases, at the same points in the story.
- [ ] The release page after a rebuild shows them, checked rather than assumed.

## Comments
