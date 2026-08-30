---
title: Git as the database
type: design
updated: 2026-08-30
---

# Git as the database

[[purpose]] §4 says every change is a commit and there is no second record. This page is the
argument for why that is a better store for a tracker than a database, and — more usefully —
what it makes possible that a database-backed tracker cannot do at all.

It is written down because the advantages are not obvious until somebody lists them, and
because half of them are still unbuilt. What is unbuilt is named at the bottom.

## What a tracker normally is

A row in a table, an `updated_at`, and an activity log written by the application beside it. The
log is a second record of what the rows already say, kept in step by care. Access is a
permission table. A backup is a dump. Moving a project to another company is an export and an
import, and the export is lossy because the export format is not the storage format.

## What changes when the store is a repository

### The history is not a feature, it is the storage

`git log` is the audit trail because there is nothing else. A comment added through the web, a
status moved by an agent over MCP, and a title edited in Obsidian and committed by hand are the
same kind of event, and none of them can happen without being recorded. A tracker cannot
"forget" to write an activity entry, because writing the entry *is* the write.

`git blame` on a task says who wrote each line of it — the acceptance criterion, the sentence
that changed the scope — which no tracker offers, because a tracker stores a description as one
value and overwrites it.

### Branching is the part with no equivalent

This is the advantage that has no counterpart in a database-backed tracker, and it is worth
more than the rest together.

A branch is a proposal about the plan. Re-scoping a release, splitting an epic, re-prioritising
a quarter — do it on a branch, and the diff is exactly what changed: which tasks moved, what
their acceptance criteria became, which were dropped. Open it as a pull request and the plan is
reviewed the way code is reviewed, by the people it affects, with comments on the lines. Merge
it and the plan changes in one commit; close it and nothing happened.

No tracker can do this. In Jira, a plan change is applied immediately and irreversibly to the
one live instance, and the record of it is an activity feed nobody reads. There is no such thing
as a plan on a branch, a plan under review, or two candidate plans compared side by side.

The same mechanism gives:

- **A dry run.** Point the tool at a branch, look at the board, throw the branch away.
- **A revert.** `git revert` a change to the plan the way you revert a change to the code.
- **Bisect.** When did this task acquire that acceptance criterion, and which commit did it?
- **Cherry-pick.** Take one decision from an abandoned plan.

### The repository is the boundary of everything

Access is `git clone`, so there is no permission model to keep in step with a second one — which
is [[0004-access-comes-from-git]]. Handing a project to another team is handing over a
repository, and nothing is lost, because there is no export format distinct from the storage.
Backup is a clone. Offline is normal. Two people editing the same task on two branches is a
merge conflict in one file, which is loud, local and resolvable, rather than a last-write-wins
overwrite nobody sees.

### It is already integrated with the work

The tasks are in git and so is the code. A commit message can name a task and `git log` can find
it. A branch can carry both the change and the task that describes it, and the pull request
that merges the code merges the plan for it.

## What this costs, honestly

- **No transactions across files.** Two writers can produce a merge conflict. That is louder
  and more recoverable than a silent overwrite, but it is work a database would not ask for.
- **No query engine.** Answering "every task assigned to me across nine projects" means reading
  files. That is fine at the size a vault reaches and would not be at a hundred thousand issues.
- **No server-side push.** Nothing tells a board that a repository changed; something has to
  pull.
- **Merge conflicts are in YAML**, which is readable but not something everyone enjoys.

None of these is a reason to keep a database. They are the reason to keep the files small,
flat, one-thing-per-file and diff-friendly — which the format already does, and which
[[vault-format]] should keep doing every time it is extended.

## What is unbuilt

The history is read ([[DKT-23 What happened to this task]]). Nothing yet uses branching, which
is the largest single thing on this page:

- A board over a branch, and a way to switch which one.
- A plan change proposed as a branch and reviewed as a pull request, with the interface showing
  what it would do rather than a raw diff.
- `git blame` on a task, so a line of an acceptance criterion says who wrote it and when.
- Two branches compared as two boards.

These are not conveniences. They are the reason to keep the store in git rather than in a
table, and until they exist the argument on this page is mostly potential.
