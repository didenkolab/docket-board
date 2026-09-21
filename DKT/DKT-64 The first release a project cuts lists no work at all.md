---
key: DKT-64
title: The first release a project cuts lists no work at all
type: bug
status: Done
status_category: done
priority: high
assignee:
labels: ["[[server]]"]
created: 2026-09-21T11:35:00Z
updated: 2026-09-21T11:40:00Z
aliases: []
tags: []
---

A project's very first release page said **"No task changed in this release"** under a heading
promising **"the work up to here"**. Every new project met that once, at the moment it first
shipped something.

`Shipped(from, to)` builds a range. With a tag before it that is `from..to`, which is right. With
nothing before it — the first tag — it passed the tag on its own:

```
git diff --name-only --diff-filter=ACMR v1.0.0
```

`git diff <commit>` compares the **working tree** against that commit, not that commit against
the beginning of the repository. On a clean checkout the answer is nothing, so the release listed
nothing. On a dirty one it listed whatever happened to be uncommitted, which is worse.

Found by building a clean vault from the template and walking the whole loop in `skill/docket`
end to end, the way somebody new would. Nothing in the existing tests caught it, and one of them
was passing *because* of it — see below.

## The fix

Diff the empty tree against the tag, which is the question the page is actually asking. The empty
tree is asked of git rather than written down: a repository on SHA-256 has a different one from a
repository on SHA-1, and a hard-coded hash works on some machines only.

Afterwards the first release reads `3 tasks · 2 finished by the tag · 20 other files` and names
them, and a vault with a single tag shows its single task.

## What it broke, and why that matters

`TestAReleaseReadsEachTagOnce` went red on the fix. It asserted that the task shipped in `v1.0.0`
does not appear twice on the page — and it had been passing because `v1.0.0` listed nothing at
all, so the key appeared zero times. A test green for the reason under test being broken.

Two things were wrong with the measure. It counted a key over the whole page, and a release row
renders its key twice — once in the link and once as the text — so one correct listing already
counted as two. It now checks the sections: releases are newest first, so everything above the
`v1.0.0` heading is `v1.1.0`, and the task must be in the second and not the first.

## Acceptance

- [x] The first tag in a repository lists the work that went into it.
- [x] A repository with exactly one tag shows that tag's tasks.
- [x] A test covers it, and fails on the old behaviour.
- [x] `TestAReleaseReadsEachTagOnce` measures what it means and passes.
- [x] The whole suite is green with no network and no git identity.

## Comments

**vadym · 2026-09-21 11:40** — The lesson is not the one-line range bug. It is that the loop a new
project walks — init, some work, the first tag — had never been walked end to end by anything.
The tests all started from a vault that already had history.
