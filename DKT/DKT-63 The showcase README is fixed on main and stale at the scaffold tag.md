---
key: DKT-63
title: The showcase README is fixed on main and stale at the scaffold tag
type: task
status: Backlog
status_category: todo
priority: normal
assignee:
labels: ["[[showcase]]"]
created: 2026-09-21T11:20:00Z
updated: 2026-09-21T11:20:00Z
aliases: []
tags: []
---

`docket-showcase/README.md` says `A [docket] vault` on `main` and `An [docket] vault` at the tag
`scaffold`. The generator resets to `scaffold` before replaying the story, so the next rebuild
reverts the fix.

```
$ git show scaffold:README.md | sed -n 3p
An [docket](...) vault for a software company that does not exist.
$ sed -n 3p README.md
A [docket](...) vault for a software company that does not exist.
```

The fix was committed on `main` because the alternative — the full scaffold procedure — replays
1359 story commits and changes every SHA in the repository, which is not a proportionate answer
to an article. This task is the record that it has to be folded in the next time the showcase is
rebuilt for any other reason.

The procedure is in [[Public release and the showcase]]: `git reset --hard scaffold`, edit, commit as
the owner, `git tag -f scaffold`, replay, then force-with-lease both `main` and `scaffold`.

Anything else above the story that has drifted goes in the same pass — `hooks/`, `docket.yaml`
and `.showcase/` are the other files that live at the scaffold rather than in the story.

## Acceptance

- [ ] `git show scaffold:README.md` and `README.md` on `main` agree.
- [ ] The story replays and `docket check` is clean afterwards.
- [ ] `northlight` is regenerated alongside if `codebase.py` changed, and both are pushed with
      `--force-with-lease`.

## Comments
