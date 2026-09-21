---
title: Workspace
type: spec
status: normative
updated: 2026-08-30
---

# Workspace

A vault is one project ([[Vault format]]). A workspace is how several projects become one
Obsidian vault without giving up their separate repositories.

## Layout

```
workspace/
  .obsidian/          config of the combined vault — plugins, theme, hotkeys
  workspace.yaml      manifest: which projects, and where they come from
  .gitignore          ignores every project folder
  acme/               a clone of the acme project repository
  docket-board/        a clone of this repository
```

The workspace itself is a git repository, and it tracks two things: the Obsidian config and
the manifest. The project folders inside it are separate repositories with their own remotes,
their own history and their own access, and the workspace's `.gitignore` excludes them
entirely.

```yaml
# workspace.yaml
projects:
  - key: ACME
    path: acme
    remote: git@github.com:example/acme.git
  - key: DKT
    path: docket-board
    remote: git@github.com:example/docket-board.git
```

`docket workspace sync` reads the manifest, clones what is missing and pulls what is there.

## Why this and not submodules

Submodules pin each project to an exact commit. Every task edit inside a project would then
need a second commit in the workspace to move the pointer, and projects would sit permanently
in detached HEAD. Submodules are built for dependencies that change rarely and deliberately;
a tracker changes constantly and by design. The pinning they provide — a reproducible snapshot
of all projects at one moment — is not something a board needs.

## What the combined vault buys

Obsidian reads its config only from the vault root, so opening the workspace folder gives one
vault over all projects at once: `[[wikilinks]]`, search, backlinks and the graph work across
project boundaries, because to Obsidian it is one file tree.

The `.obsidian/` folders inside individual projects are ignored while the workspace is open.
They exist so that a project can also be opened on its own and still be a working vault.

## Boundaries

The repository is the unit of access. A person or an agent that should not see a project does
not clone it, and no configuration inside the workspace can grant or revoke that. The workspace
is a convenience for whoever already has all the clones; it is not a permission layer.
