---
title: What Jira models, and what we take
type: design
updated: 2026-08-31
---

# What Jira models, and what we take

[[purpose]] says the shape people expect is Jira's. This is Jira's actual data model, read out of
Atlassian's documentation, set beside ours — so that what we skip is skipped on purpose.

The companion pages are [[what-obsidian-gives]] and [[git-as-the-database]].

## The three things Jira gets right that we already have

**A project is the unit of everything.** In Jira a work item belongs to exactly one project, and
the project owns the workflow, the permissions and the key prefix. That is our repository, and
[[purpose]] §1 says so. Jira has renamed projects to **spaces** in the interface while leaving
`project` in the API — the word moved, the model did not.

**One parent field, at every level.** Jira spent years with three parenting fields — `parent`
for sub-tasks, `Epic Link` for stories, `Parent Link` for initiatives — and deprecated all of
them in favour of a single `parent`. We have one `parent`, which happens to be the arrangement
Jira arrived at after a decade of not having it.

**Status and "is it finished" are different questions.** Jira's answer is `statusCategory`, one
of `new` / `indeterminate` / `done`, so that a query works across projects that named their
statuses differently. Ours is `status_category`, one of `todo` / `doing` / `done`, for the same
reason and with the same values.

## What Jira has that we do not

### Typed links between work items — the largest gap

Jira ships five link types out of the box: **blocks / is blocked by**, **duplicates**,
**clones**, **relates to**, and **causes / is caused by**. They are directed, many-to-many, and
carry no structure — a link changes nothing about boards or reports; it is an annotation that a
person reads.

We have links and therefore backlinks, so we can say *that* two tasks are connected. We cannot
say **how**. "Blocked by" is the one that changes what somebody does next, and it is missing.

It fits without inventing anything: the property name carries the type, the value is a link.

```yaml
blocks: ["[[ACME-4 Session model]]"]
blocked_by: ["[[BETA-7 Ship the widget]]"]
relates: ["[[ACME-9 Rotate the signing key]]"]
```

Flat, linked, visible in the graph, and already counted in backlinks. Jira needs an admin screen
and a database table for this; here it is a property whose name is a verb.

Jira's own warning is worth carrying: an issue link named "Parent-Child" — which several
marketplace apps add — is **not** hierarchy. Structure is `parent`; everything else is
annotation. We should keep that line just as sharply.

### A type hierarchy

Jira gives each work type a **hierarchy level**: sub-task is −1, everything standard is 0, epic
is 1, and Premium allows levels above. A parent must sit exactly one level up. That is what makes
an epic behave like a container: the epic panel, the roll-ups, and the rule that sub-tasks never
appear in the backlog all come from it.

Our `types` are a flat list of words — `task`, `bug`, `story`, `epic` — and nothing says an epic
is above a story. A task can parent a task can parent a task, and a board cannot tell an epic
from a bug.

The fix is small and belongs in `docket.yaml`: say which level each type is at, and let `parent`
be checked against it.

### Releases, and where release notes come from

A Jira **version** is a real object with a name, dates and a released flag, and two fields point
at it: **fixVersion** ("this work shipped in that release", which is what release notes are
generated from) and **affectsVersion** ("this bug is present in that release"), which — a common
confusion — does *not* add the item to the release.

We have nothing. And the Obsidian-shaped answer is unusually neat: a release is a **page**,
`fix_version` is a **link** to it, and the release notes are that page's **backlinks**. No
generation step, because the list is a query over links that already exist.

### Iterations

A Jira **sprint** is a named, time-boxed set with a state — `future`, `active`, `closed` — and a
goal. Its shape is the same as a release's: a page, a link, and a set that falls out of the
links. Whether a tracker needs sprints at all is a question for whoever uses it; the mechanism
costs nothing once releases exist.

### Estimates

Two numeric fields in Jira, for reasons Atlassian admits are a wart: **Story Points** in
company-managed projects and **Story point estimate** in team-managed ones, which do not
migrate between them. A number on a task is a number on a task. If we want it, it is one
property.

### Resolution

Jira separates **status** ("where in the workflow") from **resolution** ("why it ended") —
`Done`, `Won't do`, `Duplicate`, `Cannot reproduce` — and unresolved is the *absence* of a
resolution rather than a value. Atlassian describes the mismatch between the two as the single
most common way a Jira workflow goes wrong.

We fold this into status: `Dropped` is a status in the `done` category, which is Jira's
"Won't do" said as a status. That is a deliberate simplification and it costs the ability to ask
"finished, but how" across differently-named statuses. Worth revisiting only if somebody wants
that question answered.

## What Jira has that we should not take

- **Schemes.** Issue type schemes, workflow schemes, screen schemes, issue type screen schemes,
  field configurations, field configuration schemes, permission schemes, notification schemes.
  Seven layers of indirection whose purpose is sharing configuration between projects. A
  repository is a project and configures itself in one file.
- **Screens.** Which fields appear on create, on edit, on view. A file has the fields it has.
- **Components.** A space-scoped taxonomy with a lead and a default assignee. Labels are the
  taxonomy and they can be pages; the default-assignee behaviour is automation, not structure.
- **Issue security levels.** Per-item visibility inside a project. Anyone who can clone has
  everything — [[0004-access-comes-from-git]].
- **Custom field contexts.** One field with different options per project and per type. Our
  fields are properties in a file; a project that wants a different one adds it.
- **Dashboards, gadgets, filter subscriptions.** Reporting furniture. A board and a search first;
  these only when somebody misses them.
- **Team-managed versus company-managed.** Jira's own split, which costs it components, issue
  security, parallel sprints and a compatible story-point field. There is one kind of project
  here.

## The order to build in

1. **Typed links.** `blocks`, `blocked_by`, `relates`, `duplicates` as properties whose values are
   links. Shown on the task page beside the backlinks, and offered in search.
2. **A type hierarchy** in `docket.yaml`, so an epic is a container and `parent` is checked
   against it.
3. **Releases** as pages, `fix_version` as a link, release notes as backlinks.
4. Estimates, and iterations, if anybody asks for them.

Everything above 4 is deliberately unscheduled: it is easier to add a property than to remove
one, and [[vault-format]] gets harder to read with every field nobody uses.
