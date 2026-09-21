---
key: DKT-40
title: A link is a relationship, not a route
type: story
status: Done
status_category: done
priority: high
assignee: agent/claude
labels: ["[[format]]", "[[obsidian]]"]
created: 2026-08-31T14:00:00Z
updated: 2026-08-31T14:00:00Z
aliases: []
relates: ["[[DKT-32 A vault whose words are its own]]"]
---

Two ways a vault quietly ruins its own graph, and a rule for each. The principle behind both is
[[How things connect]].

**A link is a relationship, not a route.** A page whose purpose is to list other pages connects
everything on it, so it lands in the middle of the graph and collapses the distance between
clusters that have nothing to do with each other. Measured on the testbed: an index of labels
and a front page listing the epics were the two most connected notes in the vault and
accounted for eighteen per cent of every edge, and the whole thing was one component of 43.
Without them the largest cluster is 30 of 42 — the graph finally has structure. Finding a page
is what the file explorer, the tag pane, the quick switcher and backlinks are for; none of them
draws an edge.

**A tag is a set somebody asks for.** A tag is not a node and has no page, so its whole value
is the list of what carries it. That gives one test — will anybody ask for this list? — and
rule 11 catches the two ways of failing it: a tag on one note and nothing else, and a label
said again as a tag. Both were in the vaults. The `area/*` axis said what the labels already
said, with pages; `#вики` and `#метка` were two folders. Thirteen tags became four.

The sharpest form of the label/tag line: **a label is about the product, a tag is about the
process.** Somebody can write a page about payments. Nobody needs a page explaining what a
regression is; they need the list.

## Acceptance

- [x] The rules are normative in [[Vault format]] §5.1 and §5.2.
- [x] `docket check` rule 11 catches a set of one and a label said twice.
- [x] Every new vault carries the rules in its `AGENTS.md`.
- [x] The three vaults comply, and the graph was measured before and after.
