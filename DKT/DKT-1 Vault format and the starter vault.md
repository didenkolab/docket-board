---
key: DKT-1
title: Vault format and the starter vault
type: epic
status: Done
status_category: done
priority: high
assignee: agent/claude
labels: ["[[format]]", "[[docs]]"]
created: 2026-08-30T16:10:54Z
updated: 2026-08-30T16:10:54Z
aliases: []
---

Decide what a docket vault is and ship one, so that every later stage has a settled format to
build against.

Delivered: [[Vault format]] as the normative spec, [[Workspace]] for multi-project vaults,
[[0001-vault-as-source-of-truth]] recording why, the boards under `boards/`, the templates, and
`AGENTS.md`. This repository is the first vault and runs on the format from its first commit.

## Acceptance

- [x] A cloned repository opens in Obsidian and shows a board with no plugins installed.
- [x] The task format is written down normatively, with validation rules.
- [x] An agent can create a valid task from `AGENTS.md` alone.

## Comments

**agent/claude · 2026-08-30 16:10** — Closed with the initial commit. The eight validation
rules in [[Vault format]] are the review checklist until [[DKT-5 docket new — create a task with a valid key]] makes them executable.
