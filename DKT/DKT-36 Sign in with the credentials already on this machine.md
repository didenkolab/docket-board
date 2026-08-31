---
key: DKT-36
title: Sign in with the credentials already on this machine
type: story
status: Done
status_category: done
priority: high
assignee: agent/claude
labels: ["[[server]]"]
created: 2026-08-31T14:00:00Z
updated: 2026-08-31T14:00:00Z
aliases: []
relates: ["[[DKT-35 Sign in without pasting a token]]"]
---

A board run on a laptop, over a repository cloned from the host it is asking about, asked
somebody to paste a token for that host. The token is in the keychain — git uses it on every
push. Asking for it again is asking somebody to look up something they already have.

So it asks git. `git credential fill` is the same question git asks itself before a push,
answered by whatever helper is configured: the macOS keychain, libsecret, the gh helper, a
file. Nothing here knows which. `gh auth token` is tried after it, for somebody who
authenticated with gh and never made it a git helper. Neither may prompt — a helper that
decided to ask a human would hang the request, and there is no human at the other end of a
handler.

This is authentication by "you can reach this port", so it is offered under two conditions,
both necessary and the second easy to miss:

- the listener is on loopback, so reaching it means being on this machine;
- **nothing is proxying to it** — a reverse proxy binds loopback and is reachable from the
  world, and then reaching the port means anybody at all.

Which is why it cannot be inferred from the address. A hostname is not resolved either: a name
that points at loopback today may not tomorrow. Two hosts means no button, because which one
would it mean.

It needs no OAuth application, which was the point: [[DKT-35 Sign in without pasting a token]]
is built and waiting on an application id, and this works now.

## Acceptance

- [x] One button signs you in with what the machine already has.
- [x] Never offered behind a proxy, and never off the loopback.
- [x] Whose the token is remains the host's answer, verified the same way.
- [x] The token field stays for a host the machine has nothing for.
