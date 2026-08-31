---
key: DKT-48
title: The graph is configured, and measured
type: story
status: Done
status_category: done
priority: normal
assignee: agent/claude
labels: ["[[design]]"]
created: 2026-08-31T20:00:00Z
updated: 2026-08-31T22:00:00Z
aliases: []
relates: []
---

Opened on a real vault the graph was forty-six identical grey dots — a task, an epic, a label
and a sprint indistinguishable, which is not what [[purpose]] §3 promises.

The colours are generated from `docket.yaml`, in the vault's own words, and shipped: they are as
much vault content as a board is, and `.obsidian/graph.json` was in `.gitignore` for the sake of
the zoom.

What configuration cannot fix is that a force layout of a whole project is a hairball. Five
rounds of tuning established that. So the questions a picture cannot answer got a command:
`docket graph` reports clusters, hubs with their share of every edge, and islands. Run against
this vault it immediately found [[roadmap]] holding twenty-four per cent of every link.
