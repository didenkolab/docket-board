---
key: DKT-22
title: A container, so a board can run somewhere other than a laptop
type: task
status: Done
status_category: done
priority: high
assignee: agent/claude
labels: [server, release]
created: 2026-08-30T19:31:34Z
updated: 2026-08-30T22:00:04Z
aliases: []
---

`docket serve` ran wherever somebody had built it. Two stages onto Alpine rather than scratch:
every write shells out to git, and signing somebody in means asking a git host over TLS, so the
image carries git and certificates on purpose.

The vault is not in the image. It is a git repository belonging to whoever runs this, and baking
it in would make the image the source of truth — the opposite of
[[0001-vault-as-source-of-truth]]. It is mounted, and the container keeps no state of its own.

Two things a container gets wrong by default: a mounted repository is owned by a host user the
container has never heard of, which git refuses to touch until told the directory is safe; and
the listen address defaults to loopback, which inside a container means a server nobody can
reach.

`compose.yaml` **builds from the checkout** rather than pulling. Leading with the published
image made a private registry the first thing between somebody and a running board — a login
and a token scope to read an artifact they could have built in a minute. The published image is
still there for anyone who wants it; it is the second line in the file, not the first.

## Acceptance

- [x] `docker compose up` serves a vault with nothing installed but Docker — no registry, no
      login, no token.
- [x] `VAULT`, `PORT` and `AUTH` are the knobs; the vault is mounted, never baked in.
- [x] Writes from the container land in git on the host, attributed to the given author.
- [x] Runs as a non-root user, and does not trip over a repository it does not own.
- [x] Published to ghcr.io for amd64 and arm64 on every push and every tag, as an option.

## Comments
