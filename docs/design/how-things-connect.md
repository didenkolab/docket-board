---
title: How things connect
type: design
updated: 2026-08-31
---

# How things connect

Five mechanisms link things in a vault: `parent`, relations, `labels`, `sprint`, `tags`. Which
to use is not a matter of taste, and getting it wrong does not produce a slightly worse graph —
it produces a graph nobody opens, which costs the product its whole premise.

This page is the principle. The rules it produces are normative in
[[vault-format]] §5.1, §5.2 and §5.3; `docket check` enforces the mechanical parts.

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

A sprint is the newest thing to pass it, and it passes from both ends (§2). Standing at a task,
the fortnight it was planned into is what answers "is anybody expecting this now" — the single
question a backlog cannot answer about itself. Standing at the sprint, the tasks are the only
record of what the plan actually contained, which is why its backlinks are its contents and
nothing on the page has to list them. An estimate, by contrast, is meant to fail the test:
standing at a task, nobody needs to know what else was estimated at three, so an estimate is a
field and stays one.

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
| When was this meant to happen? | `sprint` | one at a time | at planning, and again if the plan changes |
| Which list does this fall into? | `tags` | as needed — **no edge** | by whoever will ask later |

Using one for another is the most common mistake and the most expensive. A label doing a
parent's job loses the hierarchy. A tag doing a status's job goes stale the moment the work
moves and nothing ever corrects it — **anything that changes as the work progresses is a
status**, because the workflow moves a status and nobody goes back for a tag.

A sprint changes as work is carried over, and it is still not a status. A status answers where in
the workflow the work is, and the work moves it: every hand that touches the task has a reason to
set it. A sprint answers which fortnight the work was planned into, and finishing the work does
not change that answer — only re-planning does, which is a separate act with its own moment and
its own commit. And the thing that would have gone stale is the part we refused: the sprint has no
state, so the only field that can be left behind is a task still pointing at a sprint whose dates
have passed. That is not stale data. It is a true statement that the work was planned for that
fortnight and did not get done, and the passed dates are what make it visible instead of hiding
it.

## 4. Hierarchy makes the clusters, relations make the surprises, labels and sprints make the bridges

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
and a label is a hub *on purpose*. It is a legitimate hub because it has something to say: a page
that explains what the theme means here, what bit everybody last time, and what the rules are.

From which: **a label is about the product, not about the process.** `payments` is a subject
somebody can write a page about. `regression` is a property of a task — there is nothing to
explain and the value is the list, so it is a tag. That line is sharper than "important things
get labels", and it is the one to use when in doubt.

**A sprint produces the bridges of time, and it is the second legitimate hub.** A label gathers
work around a subject; a sprint gathers it around a fortnight, and it has the same thing to say
for itself — a goal, what was cut and why, what the team learned. It sits on the process side of
the line just drawn and is the exception to it: process becomes a tag when there is nothing to
explain, and a sprint is the case where there is.

The honest caveat, and it is a real cost: **a sprint bridges work that is otherwise unrelated.**
Two tasks in the same fortnight are not thereby connected in any other sense — no shared subject,
no shared cause, nothing either of them tells you about the other. So a sprint's cluster is a
picture of a plan and not of the product, and reading the graph means knowing which kind of
cluster is on the screen: edges through a `parent` or a relation answer "what else moves if this
moves", and edges through a sprint answer only "what were we doing in August". Ask the first
question of a sprint cluster and it will give you a confident wrong answer. This is also why one
sprint at a time and why the field is not a list: a task in four sprints has quietly joined four
unrelated bodies of work together.

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

A sprint page passes the test, and only because of the body. The goal in more than one line, what
was cut and why, the retrospective — none of that is anywhere else, and a year from now it is the
only place the reasoning survives. A sprint page that is a title and two dates fails as squarely
as an index does: everything on it is already in the frontmatter of the tasks pointing at it, and
the edges it draws pay for nothing. Writing the body is not tidiness. It is what buys the hub.

**And the body must not list the tasks.** This was measured too, the first day sprints existed, on
a vault of forty-six notes. The `sprint` property cost thirteen per cent of every edge — what a
label costs, the mechanism working as designed. The wikilinks in the three sprint pages' own prose
cost a further twenty-eight per cent, made those three pages the three most connected notes in the
vault, and pushed the largest cluster from thirty of forty-three notes to forty-three of
forty-six. The graph collapsed into the blob this section was written about, at a worse number
than the index pages that were removed for it.

The reason it is worse is §2. Standing at a task, "the sprint page mentions me" says nothing the
property has not already said; the edge is drawn either way. And the pages did not stop at their
own contents — one of them linked fourteen tasks while holding three, so the sprint had become a
hub over eleven pieces of work it did not contain. A sprint's contents are its backlinks. In prose,
write the key: `` `PIER-12` ``. Rule 13 reports a sprint page that links a task, and it reports
how many of them are not even in that sprint.

Rewriting those three pages took the vault from a hundred and eighteen edges to eighty-nine and
the sprints' share from forty-one per cent to twenty-one. Two things about that number are worth
saying rather than glossing. It is still above the eighteen per cent that got index pages deleted,
and the newest sprint is still the most connected note in the vault — so a sprint is not cheap,
and one at a time is not a stylistic preference. But the edges it now has are backlinks it did not
write, and they stop when its dates pass: an index gets denser every year and a closed sprint
never gains another edge.

The rest of the drop is the interesting part. The largest cluster went from forty-three of
forty-six notes to thirty-eight, and what fell out was a five-note island — an epic with no
estimates, no sprint and nobody on it, which had been fused to everything else purely by three
sprint pages saying "we did not take this again". That island is question four at the top of this
page finally being answered.

## 5a. A link in a hub carries a line saying why

§5 is a test you apply to a page that already exists. This is the rule that decides what goes in
one while it is being written, and it is sharper:

> **A context is not a folder. It is an annotated list — every link carries one line saying why
> that note is here.**

A link with a sentence around it is doing the work: standing at the target, "the roadmap says I
was the point where this stopped being a tracker in git" is worth having. A link in parentheses
after a clause — `(see [[X]])` — is a citation in passing, and it costs an edge to say what the
key alone would have said. Write the key: `` `DKT-21` ``.

Applied to this project's own roadmap it removed nine links of twenty-seven and took the page
from twenty-four per cent of every edge to nineteen. The eighteen that remain each have their
sentence, and nineteen per cent is what a narrative spine over a whole project costs. When a
context grows past that, the answer is not to strip the annotations — it is **recursion**: a
context of contexts, each holding its own part, which is how a large map stays readable without
becoming an index.

Taken from a working vault that had reached the same conclusion by a different road, where the
rule reads "Контекст — не папка, а аннотированный список".

## 6. Density has a budget

A task ends up with about five edges: one parent, one or two labels, nought to two relations, and
one sprint while it is in one — four before sprints existed, and this is the one more it gains. A
label ends up with as many as carry it, and a sprint is the same; that is what a hub is for.
**Anything else with more than about five outgoing links is worth a second look**, and it is
almost always one of two things: a page that is really an index, or a task whose labels each mean
too little.

The sprint is the cheapest of the five to keep honest, because it is written once at planning and
touched only when the plan changes. It is also the only hub in the vault that stops growing: a
sprint whose dates have passed takes no new tasks, so a vault of forty sprints is forty closed
clusters of history rather than forty things competing for the middle of the graph. That is the
opposite of an index, which gets denser every year it survives.

Tags cost nothing, because a tag is not a node. That asymmetry is the whole reason to have both:
**a tag is cheap and may be liberal; a link is an edge and is spent deliberately.**

## Which document carries what

| | `parent` | relations | `labels` | `sprint` | `tags` |
|---|---|---|---|---|---|
| Story, task, bug | its epic | as true | one or two | the one it is planned into, or none | the cross-cutting lists |
| Sub-task | its task | rarely | usually none — it is inside a task that has them | none — its task is in the sprint | none |
| Epic | an initiative, or none | rarely | one | rarely — the tasks under it are what get planned | the cross-cutting lists |
| Label page | — | — | **never** | — | none — it *is* the theme |
| Sprint page | — | — | — | — | none — its contents are its backlinks |
| Wiki page | — | — | — | — | usually none: its set is its folder |

A tag on a page earns its place only when pages will be filtered by it *across* folders. If the
answer is the folder, the folder is the answer.

## What this costs

Discipline at the moment of writing, which is the moment nobody feels like being disciplined.
Two of the four mistakes are mechanical and `docket check` catches them: a tag on one note and
nothing else, and a label said again as a tag. The other two are judgement, and this page is
what judgement is supposed to consult.

The sprint splits the same way. That a `sprint` names a page which exists is mechanical and
checked. Whether that page was worth the edges it draws is judgement, and nothing but a reader
can tell.

The alternative is not "a slightly messier graph". It is [[purpose]] §3 quietly becoming false:
open the repository in Obsidian and see the graph — of what.
