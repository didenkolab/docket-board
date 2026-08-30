---
key: DKT-10
title: Release automation — tagged binaries people can download
type: task
status: Backlog
status_category: todo
priority: normal
assignee: 
parent: DKT-2
labels: [cli, release]
created: 2026-08-30T16:31:39Z
updated: 2026-08-30T16:31:39Z
aliases: []
---

[[0002-go-and-a-single-binary]] settled that the tool is handed to people as one file. Nothing
produces that file yet: today the only way to get `docket` is to build it.

A tag should produce cross-compiled binaries for macOS, Linux and Windows on amd64 and arm64,
attached to a GitHub release, with the version stamped in via `-ldflags` so the binary reports
its own tag.

This blocks the distribution half of ADR-0002 from being true rather than intended, and it
should land before [[DKT-6]] is worth putting into anyone's pre-commit hook.

## Acceptance

- [ ] Pushing a `v*` tag publishes a release with binaries for all six platform pairs.
- [ ] A downloaded binary prints its tag from `docket --version`, not a pseudo-version.
- [ ] The README's install instructions point at the release and are accurate.

## Comments
