---
key: DKT-4
title: docket init — scaffold a vault
type: task
status: Done
status_category: done
priority: normal
assignee: agent/claude
parent: DKT-2
labels: [cli]
created: 2026-08-30T16:10:54Z
updated: 2026-08-30T16:42:41Z
aliases: []
---

Create a new project vault from embedded templates: `project.yaml` with a chosen key and a
default status set, `tasks/`, `docs/`, the `boards/*.base` views, `templates/`, `AGENTS.md`
and a minimal `.obsidian/` so the result opens as a working vault immediately.

The templates ship inside the binary rather than as a template repository — one fewer thing to
keep in sync, and `init` works offline.

## Acceptance

- [x] `docket init --key ACME --name "Acme Platform"` produces a vault that opens in Obsidian
      and renders a board with no plugins installed.
- [x] The result passes [[DKT-6]].
- [x] Running it in a non-empty directory refuses rather than overwrites.

## Comments

**agent/claude · 2026-08-30 16:42** — Done. `internal/vault` embeds a 14-file template tree
and renders it through `text/template`, stamped with the key and the name.

Three judgement calls worth recording. A directory holding only `.git` is treated as empty,
because `git clone` of an empty repository then `docket init` is the normal way to start and
refusing it would be pedantry; anything else in the directory is refused outright rather than
merged. Project keys are validated against a shape — two to ten characters, upper-case,
starting with a letter — since the key becomes the head of every task file name and is
permanent, so a bad one is expensive later. The vault's `.gitignore` is stored in the source
tree as `gitignore` and renamed on write, because a real one there would apply to this
repository instead of to the vaults we generate.

On the second acceptance criterion: [[DKT-6]] does not exist yet, so "passes" means I ran its
eight rules by hand against the generated vault — all `.base` and `project.yaml` files parse as
YAML, both `.obsidian` files as JSON, statuses and categories agree, and no template
placeholder survives rendering, which is a test. The criterion originally pointed at [[DKT-5]];
that was a mistake in the task, since DKT-5 is `docket new`.

Not verified: that Obsidian actually renders the boards. There is no Obsidian on this machine,
so the Bases syntax follows the official documentation but has not been seen working.

The embedded templates and this vault's own files are now two copies of nearly the same
content, which will drift. That became [[DKT-11]].
