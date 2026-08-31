---
title: How things connect
type: design
updated: 2026-08-31
---

# How things connect

Four mechanisms link things in a vault: `parent`, relations, `labels`, `tags`. Which to use is
not a matter of taste, and getting it wrong does not produce a slightly worse graph — it
produces a graph nobody opens, which costs the product its whole premise.

This page is the principle. The rules it produces are normative in
[[vault-format]] §5.1 and §5.2; `docket check` enforces the mechanical parts.

## What the graph is for

Not decoration. A graph earns its place by answering four questions a list cannot:

- **What else moves if this moves?** The blast radius of a change.
- **What is this actually part of?** Context, without reading a description.
- **Where does work pile up?** Clusters, visible before a word is read.
- **What is nobody looking after?** An island is usually an owner who left.

Every rule below comes from keeping those four answerable.

## 1. An edge is a claim somebody will act on

A link says: *these two things affect each other*. The test is not "are they related" —
everything in a project is related to everything else, and a graph that says so says nothing.
The test is:

> **Standing at A, would somebody need to know about B?**

That is answerable and it is strict. A blocking task passes it. The theme a task belongs to
passes it. The list of other themes does not: standing at one label, nobody needs the names of
the eight others.

## 2. Ask the question from both ends

An edge in Obsidian's graph is undirected. It does not matter who typed the link — writing
`[[X]]` in A puts A in X's backlinks and puts them next to each other on the canvas. So before
writing a link, ask it the other way round as well:

> **Standing at X, is A worth having in the backlinks?**

This is the rule that separates two cases that look identical in the source. A runbook citing
four bugs is right: each of those bugs benefits from "the reconciliation runbook is about me".
A front page listing four epics is wrong: no epic benefits from "the front page mentions me",
and the four of them are now two hops apart for no reason.

Most bad links are bad in one direction only, which is why they get written.

## 3. Each mechanism answers one question

They exist separately because the questions differ — and so do the lifetimes and the authors,
which is the practical reason not to collapse them.

| Question | Mechanism | How many | Decided |
|---|---|---|---|
| What is this part of? | `parent` | exactly one | once, when the work is scoped |
| What does this do to that? | relations | as many as are true | while doing the work |
| What is this about? | `labels` | one or two | by what the thing is, rarely changes |
| Which list does this fall into? | `tags` | as needed — **no edge** | by whoever will ask later |

Using one for another is the most common mistake and the most expensive. A label doing a
parent's job loses the hierarchy. A tag doing a status's job goes stale the moment the work
moves and nothing ever corrects it — **anything that changes as the work progresses is a
status**, because the workflow moves a status and nobody goes back for a tag.

## 4. Hierarchy makes the clusters, relations make the surprises, labels make the bridges

This is the structural answer to *what should work gather around*.

**`parent` produces the clusters, for free.** An epic with eight tasks under it *is* a cluster
on the canvas. Nothing else has to be done to get one, because the parent was going to be
recorded anyway. This is the cheapest structure in the vault and the most reliable: it comes
from how the work was scoped rather than from anybody's diligence afterwards.

**Relations produce the edges worth looking at.** Within a cluster everything is obviously
connected. The interesting edge is the one *between* clusters: a bug in payments that blocks a
task in the migration epic. That edge is a surprise, and a surprise is the only kind of edge
worth drawing by hand.

**Labels produce the bridges of theme.** They connect work across epics that share a subject —
and a label is a hub *on purpose*. It is the one legitimate hub in the vault, because it has
something to say: a page that explains what the theme means here, what bit everybody last time,
and what the rules are.

From which: **a label is about the product, not about the process.** `payments` is a subject
somebody can write a page about. `regression` is a property of a task — there is nothing to
explain and the value is the list, so it is a tag. That line is sharper than "important things
get labels", and it is the one to use when in doubt.

## 5. A hub is legitimate only if opening it teaches you something

Stated as a test:

> **If this page were deleted, would any knowledge be lost?**

A label page: yes. An index of labels: no — everything in it is in the folder, the tag pane and
the quick switcher, and those draw no edges. So the index is a hub that costs the graph its
structure and returns nothing.

This was measured on a vault of forty-two notes. With an index of labels and a front page
listing the epics, those two navigation pages were the two most connected notes in the whole
vault, they accounted for eighteen per cent of every edge, and the vault was one component of
forty-three — every note within a few hops of every other, which is the same as no structure at
all. Removing them left the largest cluster at thirty of forty-two, and the most connected notes
became a task and a label. The graph started answering question three.

## 6. Density has a budget

A task ends up with about four edges: one parent, one or two labels, nought to two relations.
A label ends up with as many as carry it — that is its job. **Anything else with more than about
five outgoing links is worth a second look**, and it is almost always one of two things: a page
that is really an index, or a task whose labels each mean too little.

Tags cost nothing, because a tag is not a node. That asymmetry is the whole reason to have both:
**a tag is cheap and may be liberal; a link is an edge and is spent deliberately.**

## Which document carries what

| | `parent` | relations | `labels` | `tags` |
|---|---|---|---|---|
| Story, task, bug | its epic | as true | one or two | the cross-cutting lists |
| Sub-task | its task | rarely | usually none — it is inside a task that has them | none |
| Epic | an initiative, or none | rarely | one | the cross-cutting lists |
| Label page | — | — | **never** | none — it *is* the theme |
| Wiki page | — | — | — | usually none: its set is its folder |

A tag on a page earns its place only when pages will be filtered by it *across* folders. If the
answer is the folder, the folder is the answer.

## What this costs

Discipline at the moment of writing, which is the moment nobody feels like being disciplined.
Two of the four mistakes are mechanical and `docket check` catches them: a tag on one note and
nothing else, and a label said again as a tag. The other two are judgement, and this page is
what judgement is supposed to consult.

The alternative is not "a slightly messier graph". It is [[purpose]] §3 quietly becoming false:
open the repository in Obsidian and see the graph — of what.
