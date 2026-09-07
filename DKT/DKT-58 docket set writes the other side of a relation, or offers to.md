---
key: DKT-58
title: docket set writes the other side of a relation, or offers to
type: task
status: Backlog
status_category: todo
priority: normal
assignee: vadym
labels: ["[[apps]]"]
created: 2026-09-07T20:13:36Z
updated: 2026-09-07T20:13:36Z
aliases: []
tags: []
---

Core knows every relation's inverse (`internal/project/relations.go`) and `docket anomalies` reports a pair that disagrees as `one-sided` — but nothing writes the other side. So the same "read the export, append, `docket set` the target" is now hand-written five times: `import-cucumber.py`, `link-coverage.py`, and three places in the showcase's generator. The format's rule that nothing edits a task nobody asked to change is right for a person in Obsidian; for a script that creates both tasks it produces the one-sided finding it is trying to avoid.

Decide once: `docket set KEY runs=OTHER --both` writes `run_by` on OTHER (refusing across repositories in a workspace), or `docket check --fix` heals a missing inverse where both tasks are in this vault. Then the importers drop their copies.

## Acceptance

- [ ] One of the two commands writes the inverse, with a test for the refusal across repositories.
- [ ] `import-cucumber.py` and `link-coverage.py` use it and lose their own accumulation code.

## Comments
