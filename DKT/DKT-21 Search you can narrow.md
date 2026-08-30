---
key: DKT-21
title: Search you can narrow
type: story
status: Backlog
status_category: todo
priority: high
assignee: agent/claude
labels: [server]
created: 2026-08-30T19:31:34Z
updated: 2026-08-30T19:31:34Z
aliases: []
---

Search answered "which files contain these words", which is not a question anybody brings to a
tracker. "What is on me", "what is in review", "what is labelled auth" — none of those is a
word in a file.

Six filters, and with no words at all the form lists work rather than reading it. The
vocabulary comes from two places because it lives in two places: statuses, types and priorities
are configured, so they come from `docket.yaml`; assignees and labels are not configured
anywhere, so the only honest source is the tasks.

A search narrowed by a task field stops searching pages. A page has no assignee, and returning
every page containing the word alongside three matching tasks answers a question nobody asked.

The excerpt was cut on byte offsets, which turns a Cyrillic or Japanese title into replacement
characters at both ends — a real bug in a format whose whole point is that a title may be
written in any script. See [[0005-a-file-is-named-after-its-task]].

## Acceptance

- [x] Narrow by project, status, type, priority, assignee or label.
- [x] Filters and words together; either alone.
- [x] The menus offer what the vault actually uses.
- [x] Excerpts clip on character boundaries and carry no Markdown marks.
- [x] The page works at a phone's width.

## Comments
