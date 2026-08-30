---
title: Vault format
type: spec
status: normative
updated: 2026-08-30
---

# Vault format

Normative specification of a docket vault. A vault is a git repository and an Obsidian vault at
the same time — the same folder, no export step between them — and it holds one or more
projects.

Related: [[0001-vault-as-source-of-truth]], [[0003-a-vault-holds-several-projects]],
[[0005-a-file-is-named-after-its-task]], [[workspace]], [[roadmap]].

## 1. Layout

```
<vault>/
  .obsidian/          Obsidian config — plugins, appearance, hotkeys
  docket.yaml          the projects, and the vocabulary they share
  AGENTS.md           instructions for an agent working in this vault
  ACME/                             one folder per project
    ACME-12 Fix login redirect loop.md
    ACME-13 Session model.md
    _history/12.jsonl               imported history, if any
  BETA/
    BETA-7 Ship the widget.md
  docs/               knowledge base: a free tree of pages
  boards/
    board.base        Bases views over the projects
    backlog.base
    my-tasks.base
  templates/
    task.md
    page.md
  attachments/        images and files referenced from tasks and pages
```

Only `docket.yaml`, the project folders and `boards/` are load-bearing. A vault with an empty
`docs/` is valid; a vault without `docket.yaml` is not.

`docs`, `boards`, `templates`, `attachments` and `scripts` are reserved: a project cannot be
called any of them.

## 2. Identity

A task's key is `PROJECT-NUMBER` — `ACME-12`. `PROJECT` is a project listed in `docket.yaml`,
and `NUMBER` counts from 1 within it. One spelling, used in the frontmatter, in the file name,
in links and in the server's URLs.

Keys are permanent and never reused. Gaps left by deleted tasks stay as gaps.

**A file is named after its task**: the key, a space, and the title.

```
ACME/ACME-12 Fix login redirect loop.md
```

The name carries the title because that is what Obsidian shows — in the graph, in the file
explorer, in search, in backlinks. A vault of `1.md`, `2.md`, `12.md` renders a graph of
numbers, which tells nobody anything. See [[0005-a-file-is-named-after-its-task]].

The title goes into the name as written, in whatever language it was written in. Only what a
file name or a wikilink cannot hold is replaced: `/` and `\` would make folders; `: * ? " < >
|` are refused by one file system or another; `# ^ [ ]` are wikilink syntax, and a note holding
them cannot be linked to. Everything else survives exactly.

**Retitling renames the file.** Obsidian rewrites every link when it renames a note, and
`docket` does the same, so nothing breaks — but a title change shows up in `git log` as a rename
rather than a one-line diff, and reading a task's history wants `git log --follow`. That is the
price of a readable graph, and the graph is looked at far more often.

Finding a file by key is a glob — `ACME/ACME-12 *.md` — rather than a direct path. Cheap, and
confined to the tool.

### Allocation

The next key in a project is its highest existing number plus one, determined by listing the
project's folder. There is no counter file: a counter is a single line every task creation must
touch, which turns routine parallel work into merge conflicts on that line.

Two agents working in parallel branches can still choose the same number. That surfaces as a
git add/add conflict on merge — loud, and resolvable by renaming one task. It is never a silent
overwrite. `docket new` additionally opens the file with `O_EXCL`, so a collision between the
scan and the write fails rather than replacing what is there.

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

Free Markdown. Links to other tasks and pages: [[ACME-4 Session model]],
[[BETA-7 Ship the widget]], [[docs/auth/session-model]].

## Comments

**agent/claude · 2026-08-30 14:03** — Reproduced: the redirect loops when the session cookie
is rejected but the login form still succeeds.
```

### 3.1 Core properties

| Property | Required | Meaning |
|---|---|---|
| `key` | yes | Identity, and the path. Never changes. |
| `title` | yes | One line, human-readable. Free to change. |
| `type` | yes | One of `types` in `docket.yaml`. |
| `status` | yes | One of the status names in `docket.yaml`. |
| `status_category` | yes | The category of that status: `todo`, `doing` or `done`. |
| `priority` | yes | One of `priorities` in `docket.yaml`. |
| `assignee` | yes | `agent/<name>` or a person's handle. Present but empty when unassigned. |
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

Project-specific fields sit at the same level as core ones. A vault that tracks story points
adds `points: 3`, not `fields: {points: 3}`.

Fields carried in from another system are prefixed `x_` — `x_sprint`, `x_epic_link`. The prefix
keeps a foreign schema from colliding with the core one and makes imported data obvious to
anyone reading the file.

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
loading and parsing `docket.yaml` for every card, and a task file stays self-describing when
read on its own.

A vault names its own statuses. `Dropped` sits in category `done`, because for every question a
machine asks — is this in flight, is this closed — a dropped task behaves as closed. Imported
workflows depend on this: systems commonly file `Cancelled` under a done-type category.

### 3.4 Links and aliases

**Link to a task by its whole note name**: `[[ACME-4 Session model]]`. Obsidian resolves a link
without a slash against the names of notes anywhere in the vault, and names are unique because
keys are.

`[[ACME-4]]` on its own resolves to nothing. Obsidian's resolver does not consult `aliases` —
this was checked before the format relied on it, not assumed. `docket check` reports a bare key
as a broken link and prints the name to use instead.

`aliases` is still worth filling: it drives the quick switcher and search, so a key carried in
from another system stays findable by someone typing it. It does not make links work.

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

The change history of a task is its git history. `git log --follow -p "ACME/ACME-12 Fix login redirect loop.md"` shows who moved it,
when, and what the previous value was. The core keeps no separate journal: a second record of
the same facts is a second thing that can be wrong.

The one exception is import. A task carried in from another system arrives with a history git
never saw, so it is written to `ACME/_history/12.jsonl` — one JSON object per event,
append-only. Files under `_history/` are read-only after import.

## 4. The vault configuration

`docket.yaml` lists the projects and defines the vocabulary they share:

```yaml
name: Acme

projects:
  - {key: ACME, name: Acme Platform}
  - {key: BETA, name: Beta}

statuses:
  - {name: Backlog,     category: todo}
  - {name: In progress, category: doing}
  - {name: In review,   category: doing}
  - {name: Done,        category: done}
  - {name: Dropped,     category: done}

types: [task, bug, story, epic]
priorities: [low, normal, high, urgent]

# The workflow: which status may move to which. Leave it out and any task can
# go anywhere.
transitions:
  Backlog: [In progress, Dropped]
  In progress: [In review, Dropped]
  In review: [Done, In progress]
  Done: [In progress]
  Dropped: [Backlog]
```

Status order in the file is the column order on the board.

`transitions` is the workflow, and it lives here rather than anywhere else for the same reason
everything else does: a change to which moves are allowed is a change to how the team works,
and it belongs in a diff someone can read and revert. An absent or empty `transitions` means
any status may move to any other, which is what a new vault gets — a workflow nobody asked for
is a workflow that gets in the way, and it is easier to add one later than to discover why a
task will not move.

A status may always stay where it is; that is not a move and is never listed. Renaming a status
carries its moves with it, and removing one removes them.

A project key is 2 to 10 characters, upper-case letters and digits, starting with a letter, and
is not one of the reserved folder names. It is a folder name, the head of every key in the
project, and permanent.

The vocabulary is shared by every project in the vault rather than defined per project. That is
what makes one board across projects mean anything — see
[[0003-a-vault-holds-several-projects]]. A team that genuinely needs different workflows uses
different vaults, and [[workspace]] assembles those into one Obsidian view.

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

A board selects tasks by naming the project folders:

```yaml
filters:
  and:
    - or:
      - file.inFolder("ACME")
      - file.inFolder("BETA")
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

Naming the projects is deliberate. A filter that recognised a task by the properties it carries
would quietly include pages that happen to have a status and quietly exclude a project nobody
remembered to add. `docket project add` regenerates the boards, and rule 9 below reports a
project no board mentions.

Bases is a core Obsidian plugin, so a freshly cloned vault renders its boards with nothing
installed. Bases has no built-in drag-and-drop kanban; community plugins add one over the same
files. Whether such a plugin is installed changes nothing about the data — it is a viewer.

## 7. Validation

A vault is valid when:

1. Every task file has frontmatter; its name begins with its `key`; and the rest of the name is
   the `title`.
2. Every key is unique.
3. Every `status` appears in `docket.yaml`, and `status_category` matches that status's category
   there.
4. `type` and `priority` appear in `docket.yaml`.
5. Every `parent` names an existing task, and the parent graph has no cycles.
6. No frontmatter value is a nested object.
7. `created` and `updated` parse as RFC 3339, and `updated` is not earlier than `created`.
8. Every `[[wikilink]]` resolves to a file or an alias in the vault.
9. Every folder holding task files is a project in `docket.yaml`, and every project in
   `docket.yaml` is named by at least one board.

`docket.yaml` itself must also parse and agree with itself — every status has one of the three
categories, every project key is usable, and every name in `transitions` is a status the vault
has. A file that fails those is refused at load rather than reported as a finding: nothing else
can be checked against a vocabulary that does not make sense.

Rules 1–7 are checkable from the project folders and `docket.yaml` alone. Rules 8 and 9 need the
whole vault. `docket check` implements all nine and reports each finding with a file and a line.
