---
key: DKT-65
title: A tag that is not a version is shown as a release
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
The showcase's release page opens with `scaffold` — the marker the generator replays the story on
top of — presented as a release, dated, with "No task changed in this release" under it. It is
the first thing anyone sees on the page that is supposed to be the strongest argument the product
has.

Every tag is treated as a release. That is defensible and it is also how the page came to lead
with a build marker. Repositories carry tags that are not releases: build markers, `latest`,
`nightly`, a bookmark somebody left.

Three ways out, and the choice is the task:

1. **A release is a version.** List tags matching `v?MAJOR.MINOR.PATCH` and say so in the page's
   own words. Simple, and wrong for a team that tags `release-2026-09`.
2. **The vault says which tags are releases** — a glob in `docket.yaml`, defaulting to everything,
   which keeps today's behaviour for anybody who likes it.
3. **Leave it.** A tag is a release, and a repository with a stray tag has a stray release. Honest,
   and it costs the showcase its front page.

Found while taking the screenshots the README had never had.

## Acceptance

- [ ] A decision is written down — this is a fork worth a decision page, not a patch.
- [ ] Whatever is chosen, the showcase's release page opens on `v1.0.0`.

## Comments
