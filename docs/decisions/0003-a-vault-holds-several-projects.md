---
title: A vault holds several projects, and a key is a path
type: decision
status: accepted
date: 2026-08-30
supersedes: "[[0001-vault-as-source-of-truth]]"
updated: 2026-08-31
---

# ADR-0003 — A vault holds several projects, and a key is a path

Supersedes the parts of [[Vault format]] and [[0001-vault-as-source-of-truth]] that said one
vault is one project.

**The identity half of this decision was itself superseded the same day** by
[[0005-a-file-is-named-after-its-task]], after the vault was opened in Obsidian and the cost
accepted below turned out to be unlivable. Projects remain folders; the key stops being the
path. What follows is left as written.

## Context

Two things turned out to be wrong in practice.

A board has to show several projects at once. Real work crosses projects constantly, and
[[Workspace]] only solved it for Obsidian — assembling repositories into one folder does nothing
for the web board, which served exactly one vault. Someone who does not run Obsidian could see
one project at a time, which is not a board.

And `ACME-12` spends a separator on something the filesystem already expresses. The project is
a container; a hyphen pretends it is part of a name.

## Decision

**A key is `PROJECT/NUMBER`, and it is the path.** `ACME/12` is the task whose file is
`ACME/12.md`, relative to the vault root.

**A vault holds one or more projects**, each a folder at the root:

```
vault/
  docket.yaml         the projects, and the vocabulary they share
  ACME/
    12.md
    _history/12.jsonl
  BETA/
    7.md
  docs/  boards/  templates/  attachments/
```

The gain is that `[[ACME/12]]` resolves in Obsidian with no help from us. Obsidian resolves a
wikilink containing a slash as a vault-relative path, so the key people type is the path the
link follows, and links between projects work because the projects are in one file tree. Under
the old layout the same link needed an alias on every task to be findable.

**The vocabulary is defined once per vault**, not per project. Statuses, types and priorities
are shared. This is what makes one board across projects mean anything: if two projects
disagreed about what their columns are, a combined board would either invent a merged set or
show ragged ones. A team that genuinely needs different workflows uses different vaults, and
[[Workspace]] still assembles those into one Obsidian view.

## What this costs

**The graph view shows bare numbers.** A note's display name is its file name, so `12` and `7`
appear where `ACME-12` and `BETA-7` used to. The board shows `title`, and the file explorer
groups by project folder, so the loss is confined to the graph. This follows directly from
choosing the key as the path and is accepted.

**Boards name their projects.** A Bases filter selects tasks with an `or` over
`file.inFolder("ACME")` for each project, so adding a project means regenerating the boards.
`docket project add` does that, and `docket check` reports a project no board mentions — a
project invisible on the board is worse than a rebuild.

## Alternatives considered

**Keep `ACME-12` and teach the server about workspaces.** Would have given the multi-project
board without touching the format. Rejected because it leaves two ways to group projects — a
manifest for the server, folders for Obsidian — and because it keeps the separator that the
directory already provides.

**`tasks/ACME/12.md`.** Tidier root, but the key `ACME/12` would no longer be the path and
wikilinks would need aliases again, which is the thing this decision buys.

**Per-project vocabulary with a merged board.** Closer to how Jira works, and rejected for the
reason above: a combined board over disagreeing status sets has to invent something, and
whatever it invents will be wrong for one of the projects.
