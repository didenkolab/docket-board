---
key: DKT-59
title: The time-in-status report cannot show a stuck card behind twenty containers
type: task
status: Backlog
status_category: todo
priority: normal
assignee: vadym
labels: ["[[reports]]"]
created: 2026-09-07T20:13:36Z
updated: 2026-09-07T20:13:36Z
aliases: []
tags: []
---

`docket report time-in-status` prints "Waiting longest" as the top twenty rows. In a vault of a quarter's work those twenty are the epics, objectives and key results that have been "In progress" all quarter by construction, so a story stuck in review for three weeks — the thing the report exists to show — never appears. Seen on the showcase, where a planted outlier (`In review` since 21 August) is invisible behind seven containers at "2 months".

Either leave containers out of the ranking (a parent's time in status is its children's), or rank per category with a limit each, or take `--limit`. The JSON already has it per column; the printed page is what people read.

## Acceptance

- [ ] On the showcase, the stuck story is on the printed page.
- [ ] A container never outranks a leaf in "Waiting longest", or the page says why it is there.

## Comments
