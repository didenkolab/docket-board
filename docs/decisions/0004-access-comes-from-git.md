---
title: Access comes from git
type: decision
status: accepted
date: 2026-08-30
updated: 2026-08-31
---

# ADR-0004 — Access comes from git

## Context

The server had no accounts. Whoever could reach it could write, and every commit was attributed
to the one author the server was started with. That is not a tracker a team can use: nobody can
tell who did what, and there is no way to let someone read without letting them write.

The obvious answer is a user table: people, passwords, roles, an admin screen to grant them.
[[0001-vault-as-source-of-truth]] says why that answer is wrong here.

**The repository is the trust boundary.** Anyone who can clone the vault has every task, every
page and the whole history, and no check inside this program changes that. A parallel account
system would claim to protect what git already hands over, and it would need password hashes
living next to — or worse, inside — the repository it pretends to guard.

## Decision

**docket keeps no users of its own. Identity and permission come from the git host that already
holds the repository.**

Signing in means proving to the git host that you are you. The server asks it two questions
with the token you present — who are you, and what may you do with this repository — and the
answers are the session.

Permissions are the host's, mapped onto three roles rather than invented:

| The host says | Role | May |
|---|---|---|
| read, triage | **viewer** | Read tasks and pages. Nothing else. |
| write | **member** | Create tasks, move them, comment, edit. |
| maintain, admin | **admin** | Everything, plus the vault's vocabulary in settings. |

Three roles, because every extra one is a question — *can they do X?* — that nobody remembers
the answer to. The line that matters is read / write / configure, and the host already draws
the first two.

**Commits are authored by the person who made them**, using the name and email the host
reports. `git log` becomes a truthful record of who moved what, which is the whole reason the
history is worth keeping.

**Granting access is not something docket does.** The admin page lists who has access and what
they may do, and says where that is granted — on the host, next to the code. A button here that
appeared to grant access would be a lie, because the thing it granted would not be the thing
that matters: a clone.

## What this costs

**Revocation is not instant.** Permissions are re-checked with the host on a timer, so someone
removed there keeps their session until it next refreshes. The window is minutes, and it is
stated in the interface rather than hidden.

**One host at a time.** The server reads the vault's `origin` remote and talks to that host.
GitHub first; another host is a new implementation of one small interface, not a redesign.

**No sign-in, no server.** A vault on a remote nobody hosts — a bare repository on a disk, a
private clone — has no authority to ask, so `--auth none` stays: one person, no sign-in, writes
attributed to the author the server was started with. It prints what it is rather than
pretending, because a tracker that looks authenticated and is not is worse than one that says
it is open.

## Alternatives considered

**Users and passwords in the vault, secrets beside it.** Where an earlier prototype landed:
`people.yaml` and `access.yaml` in git, hashes in an ignored file. It has one real virtue —
a permission change shows up in `git log` — and one fatal problem: it is a second list of who
exists, which drifts from the first the day someone joins. And the honest sentence in its own
design document was that the repository is the trust boundary anyway.

**OAuth against the host instead of a token.** Better on ergonomics, and worth having later. It
needs a registered application and a public callback URL, which is a deployment story this does
not have yet. The token path works today and needs nothing but the host.

**Signed commits as identity.** Elegant, and useless for a web session: it proves who wrote a
commit, not who is asking for a page.
