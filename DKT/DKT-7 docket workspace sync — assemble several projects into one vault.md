---
key: DKT-7
title: docket workspace sync — assemble several projects into one vault
type: task
status: Done
status_category: done
priority: normal
assignee: agent/claude
parent: DKT-2
labels: [cli, workspace]
created: 2026-08-30T16:10:54Z
updated: 2026-08-30T17:12:13Z
aliases: []
---

Read `workspace.yaml`, clone the projects that are missing and pull the ones that are present,
per [[workspace]]. Also `docket workspace init`, which creates the manifest, the `.obsidian/`
config and a `.gitignore` that excludes every project folder.

Deliberately not submodules — the reasoning is in [[workspace]].

## Acceptance

- [x] `docket workspace sync` is idempotent and safe to run over a workspace with local changes:
      it refuses to touch a project with a dirty tree rather than stashing or resetting.
- [x] The generated `.gitignore` keeps project folders out of the workspace repository.
- [x] Opening the workspace folder in Obsidian resolves `[[wikilinks]]` across projects.

## Comments

**agent/claude · 2026-08-30 17:12** — Done: `init`, `add` and `sync`. `add` was not asked for,
but a manifest nobody can fill by anything except hand-editing YAML is a manifest that stays
empty.

All four outcomes were exercised end to end against real local repositories — cloned, up to
date, updated, skipped — and again as unit tests against a fake git, so CI needs no network.

On the dirty-tree criterion: sync reports the project and moves on. Stashing or resetting work
in progress to make a sync succeed is not a service, and a tool that does it once is trusted
with nothing afterwards. One project failing likewise does not stop the others.

The `.gitignore` block is regenerated from the manifest between markers, so lines someone added
by hand survive. Verified by initialising a git repository in a synced workspace: only the five
workspace files are staged, and the project folders are invisible to it.

A test caught a real defect while writing this: paths were tidied before being validated, which
turned an absolute `/etc` into a relative `etc` and accepted what it should have refused. The
check now looks at the path as written.

The third criterion is structural rather than observed — the projects sit in one file tree, so
Obsidian resolves across them by construction — but I have no Obsidian on this machine and have
not seen it. That caveat applies to every board in this vault and is tracked in [[DKT-12 See the boards render in Obsidian]].
