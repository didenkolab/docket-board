---
title: Vault format
type: spec
status: normative
updated: 2026-08-30
---

# Vault format

Normative specification of a docket vault. A vault is one project. It is a git repository and
an Obsidian vault at the same time — the same folder, no export step between them.

Related: [[0001-vault-as-source-of-truth]], [[workspace]], [[roadmap]].

## 1. Layout

```
<project>/
  .obsidian/          Obsidian config — plugins, appearance, hotkeys
  project.yaml        project key, statuses, task types
  AGENTS.md           instructions for an agent working in this vault
  tasks/
    ACME-1.md         one file per task, named after its key
    ACME-2.md
  docs/               knowledge base: a free tree of pages
  boards/
    board.base        Bases views over tasks/
    backlog.base
  templates/
    task.md
    page.md
  attachments/        images and files referenced from tasks and pages
```

Only `tasks/`, `project.yaml` and `boards/` are load-bearing. A vault with an empty `docs/`
is valid; a vault without `project.yaml` is not.

## 2. Identity

A task's identity is its **key**: `<PROJECT>-<n>`, where `<PROJECT>` is `key` from
`project.yaml` and `<n>` counts from 1.

The file path is a function of the key and nothing else: key `ACME-12` lives at
`tasks/ACME-12.md`. Renaming a task, reassigning it, moving it between statuses or reparenting
it never moves the file. Knowing the key is enough to open the file — no search, no index.

Keys are permanent and never reused. Gaps left by deleted tasks stay as gaps.

The title is not in the file name. It is the `title` property, which boards display in place
of the file name. This is the deliberate trade: the graph view shows bare keys, and in exchange
a task can be retitled without breaking a single link.

### Allocation

The next key is the highest existing number plus one, determined by listing `tasks/`. There is
no counter file: a counter is a single line every task creation must touch, which turns routine
parallel work into merge conflicts on that line.

Two agents working in parallel branches can still choose the same number. That surfaces as a
git add/add conflict on merge — loud, and resolvable by renaming one task. It is never a silent
overwrite. A validator reports duplicate keys within a branch.

## 3. Task

A task is a Markdown file with YAML frontmatter.

```markdown
---
key: ACME-12
title: Fix login redirect loop
type: bug
status: In progress
status_category: doing
priority: high
assignee: agent/claude
parent: ACME-4
labels: [auth, regression]
created: 2026-08-30T10:12:00Z
updated: 2026-08-30T14:03:00Z
aliases: []
---

Free Markdown. Links to other tasks and pages: [[ACME-4]], [[docs/auth/session-model]].

## Comments

**agent/claude · 2026-08-30 14:03** — Reproduced: the redirect loops when the session cookie
is rejected but the login form still succeeds.
```

### 3.1 Core properties

| Property | Required | Meaning |
|---|---|---|
| `key` | yes | Identity. Equals the file basename. Never changes. |
| `title` | yes | One line, human-readable. Free to change. |
| `type` | yes | One of `types` in `project.yaml`. |
| `status` | yes | One of the status names in `project.yaml`. |
| `status_category` | yes | The category of that status: `todo`, `doing` or `done`. |
| `priority` | yes | One of `priorities` in `project.yaml`. |
| `assignee` | yes | `agent/<name>` or a person's handle. Empty string when unassigned. |
| `parent` | no | Key of the parent task. Absent at the top level. |
| `labels` | no | List of strings. |
| `created` | yes | UTC, RFC 3339. Never changes. |
| `updated` | yes | UTC, RFC 3339. Set on every change. |
| `aliases` | no | Obsidian's own alias field. Old keys carried in from another system. |

### 3.2 Frontmatter is flat

No nested objects, at any depth. This is a hard constraint, not a style preference:

- Obsidian's property editor only renders and edits flat values. A nested field makes the task
  uneditable through the interface.
- Bases filters, groups and sorts on top-level properties. A nested field cannot appear on a
  board or in a filter.

Project-specific fields sit at the same level as core ones. A project that tracks story points
adds `points: 3`, not `fields: {points: 3}`.

Fields carried in from another system are prefixed `x_` — `x_jira_sprint`, `x_jira_epic_link`.
The prefix keeps a foreign schema from colliding with the core one and makes imported data
obvious to anyone reading the file.

### 3.3 Status is a pair

`status` is the name people say and see. `status_category` is one of three fixed values that
machines act on:

| Category | Meaning |
|---|---|
| `todo` | Not started. |
| `doing` | In flight. |
| `done` | Finished, in any sense — including abandoned. |

Both live in the frontmatter and change together. Duplicating the category into every task is
denormalisation, done for a reason: boards, filters and metrics need the category without
loading and parsing `project.yaml` for every card, and a task file stays self-describing when
read on its own.

A project names its own statuses. `Dropped` sits in category `done`, because for every
question a machine asks — is this in flight, is this closed — a dropped task behaves as closed.
Imported workflows depend on this: systems commonly file `Cancelled` under a done-type category.

### 3.4 Links and aliases

`[[ACME-4]]` resolves because the file is named `ACME-4.md`. Obsidian resolves it natively;
so does anything else that understands wikilinks.

`aliases` is Obsidian's built-in property, not ours. New tasks have it empty. Import fills it
with the keys the task used to have elsewhere, so a key that leaked into seven years of commit
messages, branch names and conversations keeps opening the right task. No resolver code is
needed for this — Obsidian already does it.

### 3.5 Comments

Comments are appended to a `## Comments` section at the end of the body, oldest first:

```
**<author> · <YYYY-MM-DD HH:mm>** — text
```

The cost is known: two agents commenting on one task in parallel branches conflict on the same
region of the same file. That is accepted. A conflict at the end of a file is trivial to
resolve, and the alternative — one file per comment — scatters a single conversation across a
directory and makes the task unreadable without tooling.

### 3.6 History

The change history of a task is its git history. `git log -p tasks/ACME-12.md` shows who moved
it, when, and what the previous value was. The core keeps no separate journal: a second record
of the same facts is a second thing that can be wrong.

The one exception is import. A task carried in from another system arrives with a history that
git never saw, so it is written to `tasks/_history/ACME-12.jsonl` — one JSON object per event,
append-only. Files under `_history/` are read-only after import.

## 4. Project

`project.yaml` defines the project's vocabulary:

```yaml
key: ACME
name: Acme Platform

statuses:
  - {name: Backlog,     category: todo}
  - {name: In progress, category: doing}
  - {name: In review,   category: doing}
  - {name: Done,        category: done}
  - {name: Dropped,     category: done}

types: [task, bug, story, epic]
priorities: [low, normal, high, urgent]
```

Status order in the file is the column order on the board.

## 5. Knowledge base

`docs/` is a free tree of Markdown pages with no schema. It is a wiki, and a wiki that demands
a schema stops getting written in.

The only convention is that pages link to each other with `[[wikilinks]]`, which is what makes
the graph view and backlinks worth opening. Pages may carry frontmatter — `title`, `type`,
`updated` — and boards can be built over them, but nothing requires it.

Tasks link to pages and pages link back. That shared link layer is the whole of the integration
between the tracker and the knowledge base; there is no other coupling between them.

## 6. Boards

Boards are Obsidian Bases files under `boards/`. They are views, not data: deleting every
`.base` file loses no information.

`boards/board.base` — cards grouped by status, closed work hidden:

```yaml
filters:
  and:
    - file.inFolder("tasks")
    - 'note.status_category != "done"'
views:
  - type: cards
    name: Board
    groupBy:
      property: note.status
    order:
      - note.title
      - note.assignee
      - note.priority
```

Bases is a core Obsidian plugin, so a freshly cloned vault renders its boards with nothing
installed. Bases has no built-in drag-and-drop kanban; community plugins add one over the same
files. Whether such a plugin is installed changes nothing about the data — it is a viewer.

## 7. Validation

A vault is valid when:

1. Every file in `tasks/` has frontmatter, and its `key` equals its basename.
2. Every key is unique.
3. Every `status` appears in `project.yaml`, and `status_category` matches that status's
   category there.
4. `type` and `priority` appear in `project.yaml`.
5. Every `parent` names an existing task, and the parent graph has no cycles.
6. No frontmatter value is a nested object.
7. `created` and `updated` parse as RFC 3339, and `updated` is not earlier than `created`.
8. Every `[[wikilink]]` resolves to a file or an alias in the vault.

Rules 1–7 are checkable by reading `tasks/` and `project.yaml` alone. Rule 8 needs the whole
vault. `docket check` will implement all eight; until it exists, they are the review checklist.
