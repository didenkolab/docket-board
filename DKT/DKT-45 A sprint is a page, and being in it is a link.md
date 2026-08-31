---
key: DKT-45
title: A sprint is a page, and being in it is a link
type: story
status: Done
status_category: done
priority: normal
assignee: agent/claude
labels: ["[[vault-format]]"]
created: 2026-08-31T17:00:00Z
updated: 2026-08-31T18:30:00Z
aliases: []
relates: ["[[DKT-44 An estimate is a number the vault chose the unit for]]"]
---

Jira makes a sprint an object with a state, and issues point at it by id. The state is the part
that goes wrong: started, completed, and a date that disagrees with both.

Here a sprint is a page — `docs/sprints/Sprint 24.md` — with `starts`, `ends` and a body. The
body is the part Jira does not have: the goal in more than one line, what was cut and why, and
the retrospective, written where the work is rather than in a different tool. A task's
membership is `sprint: "[[Sprint 24]]"`, so it is an edge in the graph and the sprint's
backlinks are its contents.

There is no state. A sprint runs between two dates; whether it is on is a question about today,
which cannot be stale. A sprint nobody finished does not sit "started" for a year.

## Why the link is on the task and not the list on the page

Both directions draw the same undirected edge, so the choice is about who maintains it and who
can read it. Obsidian Bases filters on a property of the note it is drawing — `note.sprint` —
so a sprint board in Obsidian is only possible if the task carries the field. A list on the
sprint page would make the sprint invisible to the one client that must work with nothing
installed ([[purpose]] §5).

It also matches how the work actually moves: pulling one task into a sprint is one file and one
commit, and re-planning is a branch — [[DKT-31 A plan on a branch]] already reads one.

## Acceptance

- [x] A sprint page: `type: sprint`, `starts`, `ends`, and a body that is the goal.
- [x] `sprint` on a task, as a wikilink, validated like `parent`.
- [x] A page that says what is in the current sprint, what is done, and what it adds to.
- [x] Past sprints keep their pages and their numbers; nothing is recomputed after the fact.
- [x] A sprint board in Obsidian, from the property alone.

## Comments

**agent/claude · 2026-08-31 18:30** — Built, and the design survived contact with real data
except in one place, which was the important one.

The mechanism is fine. The `sprint` property cost thirteen per cent of the testbed's edges,
which is what a label costs. What was not fine was the sprint pages' prose: written the obvious
way, citing each task by wikilink, it cost twenty-eight per cent more, made the three sprints the
three most connected notes in the vault, and pushed the largest cluster from thirty of
forty-three notes to forty-three of forty-six. That is the blob [[how-things-connect]] §5 exists
to describe — at a worse number than the index pages that were deleted for it. One page linked
fourteen tasks while holding three.

So the rule is that a sprint page never links a task, and rule 13 reports one that does, with
how many of them it does not even contain. Rewriting the three pages took the vault to
eighty-nine edges and twenty-one per cent, and an island of five notes fell out of the blob: an
epic with no estimates, no sprint and nobody on it, which had been held in only by sprint pages
saying "we did not take this again". That island is the fourth question at the top of
[[how-things-connect]] — what is nobody looking after — being answered for the first time.

Twenty-one per cent is still above the eighteen that got indexes deleted, and the newest sprint
is still the most connected note. Recorded rather than explained away: a sprint is not a cheap
mechanism, which is why it is one at a time. What is different is that its edges are backlinks it
did not write, and they stop when its dates pass.

Two smaller decisions. "Carried" is read out of `git log -p` on the task rather than from a
field: a task holds one sprint, and where it has been is what the history is for. And a sprint
with unreadable dates is still shown, with what is wrong with it said out loud — hiding the page
is a worse answer than a page that says its dates are backwards.
