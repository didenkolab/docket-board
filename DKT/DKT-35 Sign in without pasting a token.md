---
key: DKT-35
title: Sign in without pasting a token
type: story
status: In review
status_category: doing
priority: high
assignee: agent/claude
labels: ["[[server]]"]
created: 2026-08-31T14:00:00Z
updated: 2026-08-31T14:00:00Z
aliases: []
relates: ["[[DKT-34 A token belongs to a host; a role belongs to a repository]]"]
---

Asking for a personal access token works and is ugly: leave the page, find the right settings
screen, choose scopes nobody wants to think about, paste a secret into a form. The device
authorization grant (RFC 8628) is the same thing done properly — press a button, confirm a
short code on the host's own site, and the host hands this server a token.

That flow rather than the usual redirect because docket is run by whoever wants it, on whatever
address they like. A redirect needs a client secret and a callback URL registered per instance;
a device code needs a public client id and nothing else, so it works the same on localhost,
behind NAT and on a server. It is what `gh` does, for the same reasons.

The device code never reaches the browser — it redeems the token, so a browser holding one
could finish somebody else's sign-in. The browser gets an opaque id in an HttpOnly cookie.

The waiting page reloads itself with a meta tag rather than a script: everything else here
works with scripting off, and a sign-in screen is the last place to start requiring it.

GitLab's scope grew to `read_api write_repository` when the board learned to push — `read_api`
answers who somebody is and cannot push. Still narrower than GitHub's `repo`.

## Acceptance

- [x] A button, a code on the host's site, and the page lets you in by itself.
- [x] The device code is in neither the page nor the cookie.
- [x] The host is not asked faster than it said it may be.
- [x] Declined, expired and cancelled are three different sentences.
- [x] A host with no device flow keeps the token field.
- [ ] An OAuth application registered, so the button appears without configuring one.
