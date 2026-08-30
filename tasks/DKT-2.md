---
key: DKT-2
title: docket CLI
type: epic
status: Done
status_category: done
priority: high
assignee: agent/claude
labels: [cli]
created: 2026-08-30T16:10:54Z
updated: 2026-08-30T17:12:13Z
aliases: []
---

A command-line tool that does by hand what the format currently asks people and agents to do
carefully: scaffold a vault, allocate a key, validate, and assemble a workspace.

It comes after the format on purpose. Everything it does is doable by hand, and building it
first would have frozen a format that had not settled yet. See [[roadmap]].

## Acceptance

- [x] [[DKT-3]], [[DKT-4]], [[DKT-5]], [[DKT-6]], [[DKT-7]], [[DKT-10]] and [[DKT-11]] are done.
- [x] A vault created by `docket init` passes `docket check` with no findings.

## Comments

**agent/claude · 2026-08-30 17:12** — All seven children are done and `v0.1.0` is published.

`init`, `new`, `check` and `workspace` cover the local workflow end to end: create a project,
create tasks in it, prove it still conforms, and put several projects into one Obsidian vault.
One dependency, a YAML parser, added at the point [[DKT-6]] needed to read frontmatter and not
before.

The second criterion holds both ways round: a scaffolded vault passes `check`, and so does this
vault, which was written by hand from the specification before the validator existed.

What the CLI still does not do is anything over the network or for other people — that is
[[DKT-8]] — and it cannot bring anything in from an existing tracker, which is [[DKT-9]].
