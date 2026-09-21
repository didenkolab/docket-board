---
title: The rename, and the clean repositories
type: design
updated: 2026-09-21
---

# The rename, and the clean repositories

Two pieces of work done together on 2026-09-21, because the second made the first free.

## 1. Why the repositories had to be new

On 2026-09-06 the history of six repositories was rewritten with `git filter-repo` to remove a
client's name, an employer's address and a personal one, and force-pushed. That removed them from
the branches. It did not remove them from GitHub.

A force-push leaves the old objects on the server, still fetchable by SHA. Verified, from a
clone whose branches held none of it:

```
$ git fetch origin fb56646d54736b2c773137d90d68d36b7cc6ce43
 * branch fb56646d... -> FETCH_HEAD
$ git grep -c '<the client name>' fb56646d...
27 occurrences, author <a personal address>
```

All six served their old objects. Flipping any of them public would have published the history
the rewrite was for — SHAs leak through forks, the events API and the archives that mirror it.

There are two remedies. Ask GitHub Support to garbage-collect each repository, and wait. Or
create new repositories, push only the rewritten history, verify, and delete the old ones. The
second is certain and takes an afternoon, and the repositories were private with no issues, no
pull requests and no collaborators, so nothing was lost but the release objects for v0.1.0
through v0.4.0 — whose tags are in the history and whose binaries the release workflow rebuilds.

**A force-push is not a deletion.** That is the lesson worth keeping: the only reliable way to
un-publish something from a git host is to destroy the repository.

## 2. Why the name changed

The old name read as a misspelling of a methodology, could not be said aloud with confidence, and
promised a set of ceremonies this tool has nothing to do with. It also said nothing about either
of the two things that make the product what it is: that an agent runs it, and that git is the
only database.

`docket` is the register of matters to be dealt with, in order; the written note attached to a
document saying what it is and what is to be done with it; and the verb for entering one
officially. A tracker is a docket, a task is a docket, and committing is docketing. One word
carries all three.

Since every repository was being recreated anyway, the rename cost one extra replacement pass.

## 3. How it was done

The history was rewritten rather than a rename commit put on top of it. Not for tidiness: a vault
checked out at an old commit carries `igile.yaml`, which the new binary does not read, so a
history left alone would be a history that cannot be checked out and run. Rewriting made every
historical commit self-consistent.

The old name is recorded in `CHANGELOG.md` and in this page, so nothing pretends it never
happened.

Replacements, applied longest-first so `an igile` became `a docket` rather than `an docket`:
the bare word in three cases, the environment prefix, the request headers, the module path, the
agent's local address, and — in the board only — the project key `IGL-` to `DKT-`, with the
folder renamed to match.

### The gates, per repository

Before pushing: the binary builds; `go test ./...` passes with an **empty git identity**, which
is what a runner has; `docket check` is clean in every vault; the old name appears in zero
objects; the residue words appear in zero objects, checked with
`git cat-file --batch-all-objects --batch | grep` — **not** `git grep --stdin`, which fails
silently and returns a false clean.

After pushing: fetching a known pre-rewrite SHA from the new remote must fail.

Then, and only then, the old repositories were deleted.

## 4. What else went in

- **A skill for agents**, `skill/docket/SKILL.md` in the tool's repository: the loop an agent
  works in and the rules that break a vault when broken. It is the answer to "how does an agent
  learn this" that does not require the agent to read the whole specification.
- **A cookbook**, `docs/examples/`, twelve recipes. Every command was run before it was written
  down, which is how DKT-61 was found — a claim the skill was about to make turned out to be
  false.
- **The README leads with the agent**, then git as the database, then what it replaces. In that
  order, because that is the order in which a reader decides.

## 5. Left open

- Only `docket-template` is public, because `docket init` clones it over the network and nothing
  works without it. Everything else waits on a decision to launch.
- `v0.5.0` is not cut. There is little point in a release while the repository is private.
- The client boards in the other workspace still carry `igile.yaml` and will not open with this
  binary until each is migrated — one `git mv` per vault, and theirs to make.
- DKT-61 and DKT-62, both found during this work and both real.
