---
title: The testbed
type: design
updated: 2026-09-07
---

# The testbed

There are three vaults besides this one. They are not the same kind of thing, and keeping them
apart is the point.

**docket-demo** is a demonstration. Three columns, English words, five tasks, enough to open in
Obsidian and understand the format in a minute. It exists to be read.

**docket-showcase** is the whole of it on a team's worth of work: three products, six people,
twelve weeks and every app, all invented and built by a generator. Open it to see what a board
looks like after a quarter — 532 tasks, 1358 commits by six people who do not exist, sixty
scenarios run against seventeen real revisions of a code repository written for the purpose, and
three anomalies planted so that `docket anomalies` has something true to say. It is neither a
demonstration nor a fixture: it is the answer to "what does this look like when it is being
used", and it is rebuilt from a tag by `.showcase/build.py` rather than edited.

**docket-testbed** is a fixture. A fictional payments team's vault, modelled on the shape of a
real board: eight statuses in a deployment pipeline, a workflow that moves forward one stage
and back to one place when a stage fails, types and priorities in the team's own language, four
epics with sub-tasks under them, all seven relations, every label a page, and six weeks of
history by four authors with three tags and two proposals on branches. Everything in it is
invented; only the shape is taken from life.

It exists to disagree with us.

## Why a second vault

A vault we wrote agrees with us about everything. Its statuses are the ones the code was
written against, its types are the ones the defaults name, its words sort the way English
sorts. Every assumption we made without noticing is true in it.

The testbed was built in an afternoon and found two of those before the day was out.

**The board's columns came out alphabetically.** Bases groups by a value and sorts the groups
ASC or DESC — no third option, no way to hand it an order. On a three-column vault of Backlog,
Doing and Done that looks approximately right and nobody looks twice. On an eight-stage
pipeline it puts Business Review first and Discovery second, and the board is nonsense.
See [[DKT-33 Columns in the order the workflow says]].

**A new task got the lowest priority.** `DefaultPriority` returned the word `normal` when the
vault had it and otherwise the first priority in the list. Priorities are written in order, so
the first is an extreme — in the testbed, `низкий`. The English default vault has the word
`normal`, so the branch that was wrong never ran.

Neither was findable by reading the code. Both were obvious within a minute of looking at the
result.

## What it is for, going forward

Every change to a board, a status, a name or a link gets looked at here as well as in the demo,
because this is the vault where our assumptions are not true:

- **Non-ASCII in every position** — file names, wikilinks, tags, folders, branch refs, commit
  paths. Git escapes non-ASCII paths by default, and that has already cost us one bug in the
  history reader.
- **A deep board.** Eight columns do not fit on a screen. Anything that assumes they do —
  layout, drag targets, a column picker — shows up here first.
- **A real workflow.** Most moves are refused. A feature that assumes any status can follow any
  other works in the demo and not here.
- **Levels that matter.** Epics that contain, sub-tasks that are not scheduled, and a proposal
  branch that reparents things.
- **A history worth reading.** Releases, blame, branches and the log all have something in them,
  so a page about history can be judged rather than imagined.

## What it deliberately is not

It is not a performance test. Twenty-nine tasks is a small vault, and the cost of reading files
rather than querying a database — named honestly in [[Git as the database]] — is not what this
measures.

It is not a second demo either. Nobody should be pointed at it to learn the format: it is
denser than a newcomer needs and written in a language most readers of this repository do not
share. That is the feature.
