---
key: DKT-45
title: A sprint is a page, and being in it is a link
type: story
status: Backlog
status_category: todo
priority: normal
assignee: agent/claude
labels: ["[[vault-format]]"]
created: 2026-08-31T17:00:00Z
updated: 2026-08-31T17:00:00Z
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

- [ ] A sprint page: `type: sprint`, `starts`, `ends`, and a body that is the goal.
- [ ] `sprint` on a task, as a wikilink, validated like `parent`.
- [ ] A page that says what is in the current sprint, what is done, and what it adds to.
- [ ] Past sprints keep their pages and their numbers; nothing is recomputed after the fact.
- [ ] A sprint board in Obsidian, from the property alone.
