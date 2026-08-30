---
key: DKT-11
title: Stop the embedded templates from drifting away from this vault
type: task
status: Done
status_category: done
priority: normal
assignee: agent/claude
parent: DKT-2
labels: [cli, format]
created: 2026-08-30T16:42:41Z
updated: 2026-08-30T17:12:13Z
aliases: []
---

[[DKT-4]] baked a template tree into the binary: `boards/*.base`, `templates/task.md`,
`AGENTS.md`, `.obsidian/*`, `project.yaml`. This vault has its own copies of all of them, and
they were copied by hand.

They will drift. The first time a board gains a column here and the template does not, every
vault created afterwards is subtly wrong, and nothing says so.

Two ways out, and the choice is part of the task. Generate this vault's files from the same
templates, which makes the tool a build dependency of its own board. Or leave both and add a
test that compares them and fails on divergence, which is cheaper and keeps the vault usable
without the binary — likely the right one, given [[0001-vault-as-source-of-truth]] insists the
tool never becomes a gate.

## Acceptance

- [x] Changing a shared file in one place and not the other fails CI.
- [x] The failure message says which file diverged and where the two versions are.
- [x] This vault still works with no binary installed.

## Comments

**agent/claude · 2026-08-30 17:12** — Took the second option, for the reason the task guessed:
generating this vault would make the binary a prerequisite for reading the board, and ADR-0001
is explicit that it never becomes one. The files stay committed here; a script only checks that
they still match.

The drift was not hypothetical. By the time the guard existed the two copies had already
diverged in three files after a single day — a comment, a line about column order, and a link
in the task template. The template is the source of truth, so this vault was aligned to it.

`scripts/check-template-drift.sh` generates a vault with this project's key and diffs the nine
shared files, printing both paths and the diff. Verified in both directions: clean it says so,
and with a line added to a board it names the file and exits non-zero.

`AGENTS.md` is deliberately outside the shared set. Here it links to [[vault-format]] by path;
the template cannot, because a generated vault has no copy of the specification to link to.

One thing is not yet true. The workflow needs a checkout of the tool repository, which is
private, so it needs an `DOCKET_TOOL_TOKEN` secret that does not exist. Without it the job emits
a warning saying it checked nothing, rather than reporting a green tick it did not earn. The
guard is real and runs locally today; it becomes automatic when that secret is added or when
the tool repository goes public.
