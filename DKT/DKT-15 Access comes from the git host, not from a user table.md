---
key: DKT-15
title: Access comes from the git host, not from a user table
type: story
status: Done
status_category: done
priority: high
assignee: agent/claude
labels: ["[[server]]", "[[access]]"]
created: 2026-08-30T18:16:57Z
updated: 2026-08-30T18:16:57Z
aliases: []
---

[[DKT-8 Server and web UI]] closed with no accounts at all: whoever could reach the server could write, and every
commit was attributed to the one author it was started with. That is not a tracker a team can
use — nobody can tell who did what, and there is no way to let someone read without letting
them write.

The obvious answer is a user table. [[0004-access-comes-from-git]] says why it is the wrong one
here, and what replaced it.

## Acceptance

- [x] People sign in with a token for the git host that holds the repository.
- [x] What they may do is what the host says they may do.
- [x] Commits are authored by the person who made them.
- [x] GitHub, GitLab and Bitbucket, hosted or self-hosted.
- [x] The interface offers only what the role may do, and refuses the rest with a reason.

## Comments

**agent/claude · 2026-08-30 18:16** — Done. Signing in means presenting a token; the server
asks the host two questions with it — who are you, and what may you do with this repository —
and the answers are the session. Three roles, mapped from the host's own permissions rather
than invented: read becomes viewer, write becomes member, administer becomes admin.

The token lives in the server's memory for the length of a session and is written nowhere: not
to the cookie, which holds only an opaque id, and not to disk. A restart signs everyone out,
which is the honest consequence of not storing secrets.

Permissions are re-asked on a timer rather than cached for the session, so access removed on
the host stops working here within minutes. The interval is shown on the access page instead of
being a number only the code knows.

Three hosts, behind one small interface. A self-hosted server has to be named with `--host`,
because a hostname alone does not say what API is behind it and guessing wrong would show
someone a sign-in page that could never work.

Bitbucket needed one concession: an app password is used with a username, so a token containing
a colon is sent as Basic and anything else as Bearer.

The access page lists who has access and where it is granted, and grants nothing. A button
there would appear to hand out something it cannot — what actually matters is who can clone,
and that is the host's to give.

Still true, and still written down rather than implied: `--auth none` exists for a vault whose
remote nobody hosts, and it prints that anyone who can reach it can write.
