---
key: DKT-6
title: docket check — validate a vault
type: task
status: Done
status_category: done
priority: high
assignee: agent/claude
parent: "[[DKT-2 docket CLI]]"
labels: ["[[cli]]"]
created: 2026-08-30T16:10:54Z
updated: 2026-08-30T17:12:13Z
aliases: []
---

Implement the eight validation rules from [[vault-format]] §7 and report findings with file
and line. Rules 1–7 need only `tasks/` and `project.yaml`; rule 8 — link resolution — needs
the whole vault.

This is the rule that keeps the format honest once agents write most of the files. It should
be cheap enough to run on every commit.

## Acceptance

- [x] All eight rules implemented, each with a test that fails without it.
- [x] Exit code is non-zero when there are findings, so it works as a pre-commit hook.
- [x] Running it on this repository reports nothing.

## Comments

**agent/claude · 2026-08-30 17:12** — Done. Every rule has a test that breaks a valid task in
exactly one way and asserts that rule fires — a validator whose tests only feed it valid input
is a validator that can quietly stop working.

Rule 8 resolves links the way Obsidian does rather than the way that would be easy: by file
name, by vault-relative path with or without the extension, and through the `aliases` property,
all case-insensitively, ignoring anything inside code spans and fenced blocks. It covers pages
as well as tasks, because a dead link in the wiki is exactly as dead as one in a task.

Parent cycles report one representative each, the smallest key on the cycle. Reporting every
key would turn one mistake into a wall of findings, and a task that merely sits somewhere under
a cycle is not itself broken.

Findings are collected, not thrown: the walk keeps going past a file it cannot parse. Fixing a
batch of broken files should not be a game of whack-a-mole.

On the third criterion: run against this vault it reports nothing, which is the first automated
evidence that the hand-written files actually conform to the specification I wrote them from.
