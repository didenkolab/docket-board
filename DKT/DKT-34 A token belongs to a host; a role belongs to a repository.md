---
key: DKT-34
title: A token belongs to a host; a role belongs to a repository
type: story
status: Done
status_category: done
priority: urgent
assignee: agent/claude
labels: ["[[server]]", "[[git]]"]
created: 2026-08-31T14:00:00Z
updated: 2026-08-31T14:00:00Z
aliases: []
---

ADR-0004 says the repository is the trust boundary. The server did not implement it: it built
one authority from one host — whichever repository happened to be first in the space — and
checked permissions by URL path. In a workspace of a GitHub repository and a private GitLab
one that means somebody with write access to the first may write to the second, where they may
have no access at all, and somebody with access only to the second cannot get in.

So: **a token belongs to a host, a role belongs to a repository.** One token identifies a
person everywhere on a host, and what they may do is asked per repository, because that is
where the host draws the line. A session holds a token per host and adds to itself, so signing
into the second host does not sign you out of the first. Each repository is re-asked on its own
timer, so a cached answer from one host cannot mask a revocation on another.

A repository says which host vouches for it in its own `docket.yaml` — `kind` and `api` for a
self-hosted one. Nothing keeps a central list, for the same reason nothing keeps a central
vocabulary: a project has to be a repository you can hand over whole.

A repository nobody can vouch for is readable and never writable. Treating "cannot ask" as
"anyone may" is how one repository in a workspace ends up unguarded.

## Two bugs this turned up

The guard runs as middleware, **before** the mux has matched a pattern, so `r.PathValue` was
always empty there and a check keyed on it never fired. The project now comes out of the path
itself, which no route can escape by not being listed.

And a member could change how everybody signs in, because only `/settings` was held to
administrator access.

## Acceptance

- [x] Signing in is per host; a session holds a token for each and adds to itself.
- [x] What somebody may do is asked per repository and re-asked per repository.
- [x] Reads are filtered by what may be seen — board, search and API alike.
- [x] A repository nobody vouches for is readable and never writable.
- [x] A refusal says which of the two problems it is: no access, or no sign-in yet.
