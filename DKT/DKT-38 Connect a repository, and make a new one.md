---
key: DKT-38
title: Connect a repository, and make a new one
type: story
status: Done
status_category: done
priority: high
assignee: agent/claude
labels: ["[[server]]", "[[workspace]]"]
created: 2026-08-31T14:00:00Z
updated: 2026-08-31T14:00:00Z
aliases: []
relates: ["[[DKT-34 A token belongs to a host; a role belongs to a repository]]"]
---

A team's projects are not all in one place: one on GitHub, a private one on their own GitLab.
Adding the second meant editing `workspace.yaml` by hand and cloning in a terminal, which is a
strange thing to ask of an interface that otherwise writes git for you.

**Connecting one that exists.** Paste the remote; it is cloned, checked and added. Clone first,
look at what arrived, then touch the manifest — a manifest naming a project that failed to
clone is a workspace that reports itself broken every time it is opened. A repository that is
not a docket vault is refused with the command that would make it one, and the clone removed:
it is somebody else's repository. A path on the server is refused too — git would clone one
happily, and it would let whoever can reach the page copy any directory the server can read.

**Making one that does not.** Ask the host for an empty repository, scaffold from the template,
commit, push, record. The host first, because that is the cheapest place to fail. GitHub can
generate a repository from a template in one call, which was tempting and wrong: the
placeholder key would arrive verbatim and stamping it means a local commit and a push anyway.
One code path, and a project made here is the same thing as one made by `docket init`.

Scope is not widened. When the host says it is not enough, the page says so in the host's own
words and names the scope it would take. GitLab needs `api` to create, wider than signing in
asks for; that is a fact about the token, not something to route around.

The project appears without a restart, which is why the space is held atomically and the
authority's repository list is replaceable — both, because standing is worked out per
repository, so a project nobody has been asked about is a project nobody may see.

## What this cost

The repository list deadlocked the server twice: `close()` and then `adopt()` each read it
through an accessor while holding the same mutex. Being careful is not a fix for a class of
bug, so the list is now atomic and the accessor lock-free.

And the key was upper-cased before being validated, so `acme` sailed through as `ACME` — the
same trap already removed from `vault.Init`.

## Acceptance

- [x] Paste a URL and the project is in the workspace, without a restart.
- [x] A non-vault, a taken key and a path on the server are each refused, cleanly.
- [x] A new project is created on a chosen host, scaffolded and pushed.
- [x] A refusal shows the host's own reason and names the scope.
