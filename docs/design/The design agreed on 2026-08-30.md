---
title: The design agreed on 2026-08-30
type: design
status: accepted
date: 2026-08-30
updated: 2026-08-30
---

# The design agreed on 2026-08-30

The design agreed on 2026-08-30, from which [[Vault format]], [[Workspace]] and
[[0001-vault-as-source-of-truth]] were written. Kept as the record of what was decided and
what was rejected.

**Partly superseded the same day by [[0003-a-vault-holds-several-projects]]**, which changed
keys from `ACME-12` to `ACME/12` and let one vault hold several projects. The sections below
are left as they were written: a design record that gets edited to match what happened later
records nothing.

## Problem

Agents do most of the work and are good at files, bad at web interfaces. People on the same
project want a board and a wiki. A tracker behind an API serves the second group and obstructs
the first; a folder of YAML does the reverse.

## Shape

A project is a git repository that is also an Obsidian vault. Markdown files with flat YAML
frontmatter are the data. Obsidian is the first client — Bases, a core plugin, renders boards
over frontmatter with nothing installed. A CLI, and later a server with a web UI, are further
clients to the same files.

Three artefacts:

1. **Project vault** — one repository, one project, one vault. Self-contained.
2. **Workspace** — a repository holding an Obsidian config and a manifest, which assembles
   several project repositories into one vault. See [[Workspace]].
3. **`docket` tool** — CLI and later server: `init`, `new`, `check`, `workspace sync`, `serve`,
   `import`. Lives in its own repository and ships no documentation of its own; this vault is
   the documentation.

## Decisions and their reasons

**File name is the key alone** — `ACME-12.md`, title in frontmatter. The path becomes a pure
function of the key: retitling never moves a file and never breaks a link. Cost: the graph
view shows bare keys. Boards display `title` instead of the file name, so the cost lands only
in the graph.

**Frontmatter is flat, always.** Obsidian's property editor handles only flat values and Bases
filters only on top-level properties. A nested field is invisible to the board and uneditable
by hand. Foreign fields get an `x_` prefix instead of a namespace object.

**Status is a pair, `status` + `status_category`.** Names belong to the project; the three
categories are what machines act on. Denormalised into every task so a card can be placed
without parsing `project.yaml`, and so a task file read alone still describes itself.

**No counter file for key allocation.** A counter is one line every task creation must touch —
a merge conflict generator. Scanning `tasks/` for the highest number instead turns a parallel
collision into a git add/add conflict: loud, and never a silent overwrite.

**History is git.** No parallel audit log for facts `git log -p` already records. Imported
tasks are the exception: their history predates the repository, so it is written to
`_history/<key>.jsonl`.

**Comments are a section in the task body.** Cheapest to append, easiest to read whole.
Accepted cost: parallel comments on one task conflict at the end of one file.

**Workspace uses a manifest, not submodules.** Submodules pin commits, so every task edit would
demand a pointer-bump commit in the parent and leave projects in detached HEAD. Submodules fit
dependencies that change deliberately; a tracker changes constantly.

## Rejected

- **A database with files exported on demand.** The export is always stale and the agent ends
  up on the API anyway.
- **Obsidian's Kanban plugin.** It stores a board as one file containing the cards, making the
  board authoritative and the tasks derived — inverted.
- **Requiring a drag-and-drop kanban plugin.** Bases is core, so boards render on a bare
  Obsidian. A kanban plugin over the same files stays an optional viewer.
- **Tool and vault in one repository.** Separated: `docket` is the tool, this repository is the
  vault and holds all documentation.
- **ULID identity with leased key ranges**, carried over from an earlier prototype. Real
  problems, disproportionate machinery for a tracker this size. Revisit only if collisions
  actually hurt.

## Stages

Format and vault, then CLI, then server and web UI, then import from Jira and Confluence.
Detail in [[Roadmap]].
