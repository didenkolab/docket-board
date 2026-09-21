---
key: DKT-67
title: check --fix renames a file by case and git quietly keeps the old name
type: bug
status: Backlog
status_category: todo
priority: high
assignee:
labels: ["[[check]]"]
created: 2026-09-21T16:30:00Z
updated: 2026-09-21T16:30:00Z
aliases: []
tags: []
---

`docket check --fix` renames `documents.md` to `Documents.md` on disk, says it did, and reports
the vault clean. Then the commit that follows does not contain the rename, and neither does the
push — because on a case-insensitive file system, which macOS and Windows both are by default,
git's index keeps the old spelling and sees nothing to record.

The result is the worst shape a fix can take: the tool says it fixed something, the local vault
agrees, and the repository everybody else clones still has the old name. Found by running the
README's three commands as a stranger would, against the published template — a freshly
scaffolded vault reported a finding in a file the tool had just created, because the template on
GitHub still had `docs/spec/documents.md` while the clone it was built from had `Documents.md`.

Nine files across three repositories were in that state.

## What works

Two commits through a name that differs by more than case:

```bash
git mv docs/spec/documents.md docs/spec/documents--renaming.md
git commit -m "Renaming through an intermediate name"
git mv docs/spec/documents--renaming.md docs/spec/Documents.md
git commit -m "Pages carry the case their titles have"
```

`git mv -f` in one step does not: it moves the file and leaves the index with the old entry.

## What the tool should do

It renames files and then tells the person to commit, which is right — it does not touch git, and
it should not start. But it knows it has just made a change git cannot see on this platform, and
saying nothing is the part that fails.

Two candidates, and the choice is the task:

1. **Say so.** After a rename that differs only in case, print the two commands above. The tool
   stays out of git and the person is not misled.
2. **Do the git move.** `check --fix` already writes files; staging a rename it just made is a
   smaller step than it looks, and it is the only way the fix is actually complete.

The first is honest and leaves work for a person to get wrong. The second couples `check` to git,
which every other part of the tool avoids on purpose.

## Acceptance

- [ ] A case-only rename made by `--fix` cannot end up committed as nothing.
- [ ] A test covers it, and fails on the current behaviour — on a case-insensitive file system,
      which is where the bug lives and where CI does not run.
- [ ] `vault.Rename`'s two-step is kept: it is what makes the rename possible on disk at all,
      and it is separately tested.

## Comments

**vadym · 2026-09-21 16:30** — Underneath this sits the fix from [[DKT-46 A page is named after its title, like a task is]]: `vault.Rename`
used to refuse a case-only rename outright, because Stat reports the target as existing. That is
now handled by renaming through a temporary name on disk. This task is the half of the problem
that lives in git rather than in the file system.
