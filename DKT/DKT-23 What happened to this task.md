---
key: DKT-23
title: What happened to this task
type: story
status: Backlog
status_category: todo
priority: high
assignee: agent/claude
labels: [server, git]
created: 2026-08-30T21:40:48Z
updated: 2026-08-30T21:40:48Z
aliases: []
---

Every change has been a commit since the first version, and nothing in the product ever showed
one. [[0001-vault-as-source-of-truth]] argues that git is the audit trail; a tracker that makes
you leave it to read that trail has not finished making the argument.

The history says what a tracker says rather than what git says — who, when, and which fields
moved: `status Backlog → In review`, `added 1 comment`, `edited the description`. It is computed
by comparing consecutive versions of the file, so a change made in Obsidian or by an agent
appears beside one made on the page. There is no activity table, because a second record is a
record that can disagree with the first.

A task's history is found by its key, not by following one file. Git follows a rename by
guessing from how similar two versions look, and a retitle that also rewrites the body falls
under the threshold — at which point the history stops at the rename and the task looks as if it
were created the day somebody reworded it. `ACME/ACME-12 *.md` is the whole life of ACME-12,
decided by [[0005-a-file-is-named-after-its-task]] rather than by a heuristic. The demo has a
retitle git scores at 49% similar, which is exactly the case that would have been lost.

Deleting a task turned out to be implemented and unreachable: the route existed and no page
offered it. It is on the task page now, behind a confirmation, and still refuses a task that has
children.

## Acceptance

- [x] A task page links to its history, and the history reads as events rather than as a diff.
- [x] The history crosses a retitle and reaches the task's creation.
- [x] `updated` is not reported, because it moves on every write and would bury the rest.
- [x] A task can be deleted from its page, and a parent with children still cannot.

## Comments
