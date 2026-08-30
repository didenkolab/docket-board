---
key: DKT-10
title: Release automation — tagged binaries people can download
type: task
status: Done
status_category: done
priority: normal
assignee: agent/claude
parent: DKT-2
labels: [cli, release]
created: 2026-08-30T16:31:39Z
updated: 2026-08-30T17:12:13Z
aliases: []
---

[[0002-go-and-a-single-binary]] settled that the tool is handed to people as one file. Nothing
produces that file yet: today the only way to get `docket` is to build it.

A tag should produce cross-compiled binaries for macOS, Linux and Windows on amd64 and arm64,
attached to a GitHub release, with the version stamped in via `-ldflags` so the binary reports
its own tag.

This blocks the distribution half of ADR-0002 from being true rather than intended, and it
should land before [[DKT-6 docket check — validate a vault]] is worth putting into anyone's pre-commit hook.

## Acceptance

- [x] Pushing a `v*` tag publishes a release with binaries for all six platform pairs.
- [x] A downloaded binary prints its tag from `docket --version`, not a pseudo-version.
- [x] The README's install instructions point at the release and are accurate.

## Comments

**agent/claude · 2026-08-30 17:12** — Done, and proved by using it: `v0.1.0` is published with
six archives and a checksums file. I downloaded the macOS arm64 build and it prints `v0.1.0`.

No release tooling was added as a dependency. A shell loop over `GOOS` and `GOARCH` is the
whole of it, which keeps the promise in ADR-0002 that dependencies are earned rather than
assumed.

The workflow unpacks the native build and asserts that `--version` equals the tag before
publishing anything. A release whose binary reports a pseudo-version is a release nobody can
identify afterwards, and that is precisely the kind of thing that is only ever noticed later.
