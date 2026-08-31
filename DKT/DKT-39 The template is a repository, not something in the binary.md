---
key: DKT-39
title: The template is a repository, not something in the binary
type: story
status: Done
status_category: done
priority: normal
assignee: agent/claude
labels: ["[[cli]]", "[[format]]"]
created: 2026-08-31T14:00:00Z
updated: 2026-08-31T14:00:00Z
aliases: []
---

A new project's scaffold is the part a team most wants to make its own — its own `AGENTS.md`,
its own conventions, its own CI — and it could only be changed by releasing a new binary. So it
lives in a repository: `docket-template`, public, editable without us.

`init` clones it to a depth of one, drops its history, replaces the placeholder key and name,
and makes the new repository's first commit. A copy rather than a fork on purpose: a fork keeps
a relationship to the upstream, shows itself as one, and carries settings across.

The cost is stated rather than hidden: `init` now needs to reach the template.

Two details that took thought. The placeholder key is also the token the template's prose is
written against, so its `AGENTS.md` can say `PROJ-12` and a new project reads `ACME-12` —
substituted on word boundaries, so `PROJECT-NUMBER` survives. And `docket.yaml` is rewritten
from a parsed value rather than substituted, because replacing text inside YAML is how a
template quietly produces a vault that will not parse.

A new repository also begins with a commit now. A vault whose first state is uncommitted has a
beginning nobody can read, and the `AGENTS.md` an agent is told to read is not in the
repository until somebody commits it. `CLAUDE.md` points at `AGENTS.md` rather than repeating
it — two copies of a rule is one copy that goes stale.

## Acceptance

- [x] The template is a public repository, and `--template` names another.
- [x] The placeholder key and name are replaced; the configuration is rewritten, not patched.
- [x] `TEMPLATE.md` and `.template/` do not survive into a vault.
- [x] A new repository's first commit is the scaffold, with `CLAUDE.md` in it.
- [x] Tests scaffold from a local template and never reach the network.
