---
key: DKT-35
title: Sign in without pasting a token
type: story
status: Done
status_category: done
priority: high
assignee: agent/claude
labels: ["[[server]]"]
created: 2026-08-31T14:00:00Z
updated: 2026-08-31T19:10:00Z
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
- [x] An OAuth application registered, so the button appears without configuring one.

## Comments

**agent/claude · 2026-08-31 18:45** — Registered and driven end to end against the real GitHub.
The application id is in `docket.yaml`, set from the Access page rather than by editing the file,
so it travelled to the remote in its own commit and anybody who clones this vault has the button
already.

Three things the live run confirmed that a stub could not.

GitHub needs Device Flow enabled explicitly, as a separate checkbox after the application exists.
Until it is ticked the endpoint answers `device_flow_disabled` for a client id that is otherwise
perfectly valid — and the failure is indistinguishable from a wrong id unless the body is read.
That is now the first thing to check when the button does not work.

The token reaches nothing but memory. After signing in the browser holds two cookies,
`docket_session` and `docket_csrf`, thirty-two characters each and both HttpOnly, and nothing in
local or session storage. Nothing matching a GitHub token appears in the server's log, under
`~/.docket`, or in the vault. The device code never reaches the browser either: it redeems the
token, so a page holding one could finish somebody else's sign-in.

Access came back as GitHub says it: `didenkolab`, admin, granted on GitHub, re-asked every
five minutes.

The same is not yet true on GitLab. The application registered on the private instance answered
`access_denied` to every scope, including none, which is what a confidential client does — device
flow has no secret to authenticate with. The instance itself is fine: `device_code` is in its
`grant_types_supported`. It needs an application with Confidential unticked, and that is a
registration rather than code.

**agent/claude · 2026-08-31 19:10** — The private GitLab works too, and what it took is worth
writing down because its own documentation for this grant mentions neither part.

An application there needs **Confidential unticked** — a confidential client with no secret gets
`invalid_client` — and a per-application **Device authorization grant** setting turned on, which
is off by default. With that second one off the endpoint answers `access_denied` to every scope,
including none at all, *and* it keeps answering access_denied when the client authenticates
correctly with its secret. That is what made the two failures look like one problem for a while:
without a secret the answer is invalid_client, with a secret it is access_denied, and neither
names the toggle.

The instance itself needed nothing: `device_code` was already in its `grant_types_supported`.

Both hosts are now driven by a test rather than by hand — `TestLiveDeviceFlow` in
`internal/access`, off unless a client id is passed in. It starts a flow and authorises nothing.
GitHub answers with fifteen minutes and GitLab with five, and it checks the wait page counts down
from the host's own number rather than from the fallback.

