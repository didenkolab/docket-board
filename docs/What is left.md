---
title: What is left
type: page
updated: 2026-09-21
---

# What is left

Everything is public, [v0.6.0](https://github.com/didenkolab/docket/releases/tag/v0.6.0) is out,
CI is green, and nothing has been announced to anybody. The tool is finished in the sense that a
stranger can install it and use it; this page is only what is not done.

What it is for is [[What docket is for]]; the order things happened in is [[Roadmap]].

## 1. Signing on macOS — started, waiting on four clicks

The macOS binaries are ad-hoc signed — `flags=0x20002(adhoc,linker-signed)` — which is to say
not signed at all as far as Gatekeeper is concerned. A copy downloaded with a **browser** carries
`com.apple.quarantine`, and macOS refuses to run it: *"Apple could not verify docket is free of
malware"*, with one button, Move to Trash.

This was nearly missed, and the reason is worth keeping: every test run used `curl`, **and curl
does not set the quarantine flag**. Only reading the signature showed it.

The developer account is paid — an Apple Distribution certificate is not issued without
membership — and the keychain holds two certificates: an **Apple Development** one, for running
on your own machines, and an **Apple Distribution** one, for the App Store. Signing with the
first was tried: it succeeds, hardened runtime applies, and then
`spctl -a -vvv -t install docket` says **rejected**.

What is missing is a third kind, **Developer ID Application** — the only one that distributes a
binary outside the App Store. It costs nothing on top of the membership.

A private key and a certificate request are ready on the release machine, outside every
repository, and the request verifies. **The key is the half that cannot be replaced: without a
backup of it, a certificate issued against it is worthless.**

**The steps that need a person:**

1. developer.apple.com → Certificates → add
2. Under **Software**, choose **Developer ID Application** — not Development, not Distribution
3. Upload the certificate request
4. Download the certificate and install it into the keychain

Only the account holder can create this kind.

5. Choose credentials for notarization: an **App Store Connect API key** (better for CI — the
   `.p8` is downloadable exactly once, and its key id and issuer id must be written down), or an
   **app-specific password** tied to the Apple ID.

**Then:** sign with `codesign --options runtime --timestamp`, notarize with
`xcrun notarytool submit --wait`, add a **macos-latest** job to `release.yml` — signing only
works on macOS and everything is built on ubuntu today — keep the certificate and the notary
credentials as repository secrets, and delete the Gatekeeper warning from the README, which will
by then be untrue. It is done when `spctl` says *accepted* and a browser download runs without a
dialog.

One limit to know in advance: a notarization ticket **cannot be stapled to a bare executable**,
only to a `.dmg`, a `.pkg` or a bundle. For a command-line tool in an archive, Gatekeeper checks
online on first run. That is what every other CLI does, and it means a machine with no network at
all still stops on first run. Closing that too means shipping a `.pkg` with the ticket stapled
into it.

## 2. Three things only a person can do on GitHub

1. **Make the container package public.** An anonymous `docker pull ghcr.io/didenkolab/docket`
   returns **403 DENIED**: GitHub keeps a new package private however public the repository that
   built it is. The README says so, but the promise is still broken, and this is the only broken
   promise on a public page.
2. **Add the `PACKAGING_TOKEN` secret** to the docket repository — a token that may write to
   `homebrew-tap` and `scoop-bucket`. Without it the release step is skipped rather than failed,
   and `script/packaging.sh` has to be run by hand after a tag.
3. **Pin the repositories** on the profile. GitHub has no API for it — there is `pinIssue` and
   `pinEnvironment`, and nothing for repositories.

## 3. What to build next, in order

### A merge driver, before anything else

Two people, one task, measured rather than assumed: one appends a comment on a branch, the other
moves the same task to another column. The comment and the move **both merge cleanly**. The only
conflict is this:

```yaml
<<<<<<< HEAD
updated: 2026-09-21T18:00:00Z
=======
updated: 2026-09-21T18:05:00Z
>>>>>>> bob
```

So every concurrent edit conflicts, and every one of those conflicts is on a field the tool
writes itself, that carries nobody's intent, and that git already knows from `git log`.
[Contributing](https://github.com/didenkolab/docket/blob/main/CONTRIBUTING.md) calls that grounds for turning a change down — *a second record of a fact the
repository already holds* — so the rule is being broken by the tool that enforces it, and the
price is that it looks unusable by a team.

`docket merge` as a git merge driver, and `*.md merge=docket` in a `.gitattributes` the template
does not yet have. The driver settles the frontmatter by rule: `updated` is the later of the two,
comments are the union, and a disagreement about `status` is a real conflict a person should see.

This goes first because the README now says out loud that two people editing one task is a merge.
The first pair who test that should meet the design, not a timestamp.

### A digest, which needs no change to the tool at all

A cron job and a program that reads `docket export --format json` and
`docket report time-in-status --json` and posts: what was created, what moved, what has sat in a
column for more than N days, what is blocked. `docket report` was written to be used this way —
its help says so. It closes most of *nobody noticed the task* while real notifications do not
exist, and it is the thirteenth pack.

### Notifications: one new event, one new field, one generalisation

The mechanism exists — `task.moved`, `task.created`, `task.edited`, filtered by status and
project, delivered as JSON on stdin with no shell. Three things make a notifier written on it
bad today, and all three are small:

- **`task.edited` does not say what changed.** From and to exist only for a move, so being
  assigned, being reworded and being reprioritised are one event, and the program has to diff git
  itself. Add `Changed []string` and the old and new assignee. Additive; the vault format does
  not move.
- **There is no event for a comment** — the single best reason to notify anyone. It arrives as
  `task.edited`, indistinguishable from a typo fix. Add `task.commented`; there is exactly one
  call site to raise it from.
- **A reaction runs inside the request, with a twenty second timeout.** Its own documentation
  admits the problem: *a reaction that talks to a slow service should write a file and let
  something else do the talking*. As it stands, a naive notifier hangs Slack's latency off
  dragging a card. The queue does not need designing: pushing already solved this — in the
  background, visibly, with the error reported and no endless retry — and those three principles
  are written down where it was solved. Generalise it so pushing and notifying share it.

Who to notify needs no change: people have pages, vault fields are open, and `slack: U123` in a
person's frontmatter is enough.

### An Obsidian plugin — a channel, not a feature

The whole pitch leans on Obsidian and there is nothing of ours in the community plugin
directory, where the exact audience already is: people who have installed Obsidian and already
keep notes in Markdown. For adoption this is worth more than the notifications above.

### Comments on pages

Tasks have comments; pages in `docs/` do not, which means decisions are the one thing with
nowhere to discuss them. The mechanism is complete and needs extending, not designing.

### A board that can be opened without installing anything

Seeing the product currently requires putting a binary on a machine. A public read-only
`docket serve` over the showcase is the cheapest thing that turns a reader into a user, and it is
already written — it needs somewhere to run. The repository's homepage currently points at the
showcase repository, which is a repository rather than a board.

### A promise about the format

`docket.yaml` carries no version. Nobody moves a team's tracker into a format that might change
under them, so: a version in the file, a written compatibility promise, and `docket migrate`. For
the people we most want — the ones leaving Jira — this blocks adoption harder than any feature.

### Supply chain

No `dependabot.yml` and no CodeQL. Two files. It is the first thing anyone deciding whether to
bring a tool into a company looks at.

### Small things that are already wrong

- The reaction package's own documentation promises a `--reactions` flag; the flag is
  `--programs`. The first person to enable reactions by reading the code gets *unknown flag*.
- Fifteen hundred cards render as one page of 727 KB with no paging. Unnoticeable to two or three
  thousand, heavy after. Render the first N in a column with a *show more*; the filters that
  narrow it already exist. Not urgent, but it should be written down before it surfaces on
  somebody else's large vault.
- The Confluence import is a thing to verify, not to build: the code exists, and the
  documentation admits nobody has pointed it at a real space. Point it at one and fix what comes
  out. Doing that to Jira found four defects nothing else did.
- The GitLab OAuth application is not registered.

## 4. What was decided against

- **Permissions inside a vault** — a hidden field, a private page. Roles already belong to
  projects and are checked on every action. The boundary of access is the repository, and an ACL
  over git becomes the button that pretends to control what it does not. What is worth building
  instead is the view of what already works: a settings page saying *here you are a member, here
  a viewer, here you are not* — the data is already gathered — and a paragraph in the
  documentation about where the boundary runs.
- **A WYSIWYG editor.** A separate product, and it would destroy the one property everything
  rests on: that the file reads the same to all three readers.

## 5. Nothing has been announced

The order agreed: r/ObsidianMD, then r/selfhosted, r/commandline, r/golang, and Show HN last.
r/ObsidianMD first because a vault being a board needs no explaining there.

§2.1 must be done before any of it, and §1 should be. An announcement happens once, and somebody
who meets a Gatekeeper dialog or a 403 on the day of the post does not come back for the second
one.
