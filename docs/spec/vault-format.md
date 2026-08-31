---
title: Vault format
type: spec
status: normative
updated: 2026-08-31
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
    sprints/
      Sprint 24.md                  one page per sprint, in a vault that has them
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
estimate: 3
assignee: agent/claude
sprint: "[[Sprint 24]]"
parent: "[[ACME-4 Session model]]"
labels: ["[[auth]]", "[[regression]]"]
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
| `type` | yes | One of `types` in `docket.yaml`. Its level decides what it may hold — see 4.2. |
| `status` | yes | One of the status names in `docket.yaml`. |
| `status_category` | yes | The category of that status: `todo`, `doing` or `done`. |
| `priority` | yes | One of `priorities` in `docket.yaml`. |
| `estimate` | no | A number, in the unit `docket.yaml` declares. Absent is nobody having said. See 3.10. |
| `assignee` | yes | `agent/<name>` or a person's handle. Present but empty when unassigned. |
| `sprint` | no | Wikilink to the sprint the task is in now. One at a time. See 5.3. |
| `parent` | no | Wikilink to the parent task. Absent at the top level. See 3.3. |
| `labels` | no | List of wikilinks. See 3.3. |
| `tags` | no | Obsidian's own tags. Nested with `/`. See 3.3. |
| `blocks`, `blocked_by`, `duplicates`, `duplicated_by`, `causes`, `caused_by`, `relates` | no | Typed links to other tasks. See 3.4. |
| `created` | yes | UTC, RFC 3339. Never changes. |
| `updated` | yes | UTC, RFC 3339. Set on every change. |
| `aliases` | no | Obsidian's own alias field. Old keys carried in from another system. |
| `order` | no | Where the task sits in its column when somebody has arranged one. See 3.2. |

### 3.2 Where a task sits in its column

`order` is an integer. Within a status, tasks sort by it ascending; a task without one sorts
after every task that has one, and those sort by key, which is by age. So a column nobody has
arranged reads oldest first, and arranging one card does not renumber the rest.

The numbers are spaced a thousand apart, so a card dropped between two others usually lands in
a gap and rewrites one file. When a gap runs out — about ten insertions into the same place —
the column is renumbered into multiples of a thousand again, in one commit.

It is a number on each task rather than a list of keys somewhere because a list is a second
source of truth: a rename, a merge, or a task moved in Obsidian puts it out of step with the
tasks it claims to order, and nothing says so. A number travels with the task it describes.

Nothing has to set it. A vault where no task carries `order` is a vault sorted by key, which is
what a board looks like until somebody drags a card.

### 3.3 A relationship is a link

`parent` and `labels` are wikilinks, not strings:

```yaml
parent: "[[ACME-4 Session model]]"
labels: ["[[auth]]", "[[regression]]"]
```

A wikilink is the only pointer Obsidian resolves, draws in the graph, counts as a backlink and
offers in the quick switcher. The same word written plainly connects nothing: it exists for
docket's own tools and is absent from every place the relationship was supposed to show. That is
the difference between this being Obsidian with tracking on top and being a database that keeps
its rows in Markdown.

A link resolves by **note name**, so a parent is `[[ACME-4 Session model]]` and never
`[[ACME-4]]` — Obsidian does not consult `aliases`, so a bare key points at nothing.
Retitling therefore rewrites every link to the renamed note, in bodies and in frontmatter
alike, in the same commit as the rename.

A label link need not resolve. An unresolved link is still an edge in the graph, so `[[auth]]`
groups everything carrying it whether or not `auth.md` exists. Writing that page — anywhere
under `docs/` — is what turns a label into something that can explain itself and gather what
belongs to it.

Both must be quoted. `labels: [[[auth]]]` unquoted is a nested sequence in YAML, not a link.

The values are read either way while vaults written before this are migrated, and `docket check`
reports the old form at rule 10. `docket check --fix` rewrites it.

`tags` is the other thing Obsidian offers for grouping, and it is a different thing from a
label. A label says what a task is about and can be a page that explains it. A tag says which
slice of the work a task belongs to, and **nests**: `area/auth` is inside `area`, so a filter on
`area` finds it. Obsidian's tag pane shows that hierarchy with counts, its `tag:` search reads
it, and its graph draws tags as nodes when set to show them.

```yaml
tags: [area/auth, needs-review]
```

Written without the leading `#`, which is the inline form, and unquoted, which is how Obsidian's
own property editor writes them. A tag may hold letters, digits, `_`, `-` and the `/` that nests
it; it may not contain a space and may not be all digits. `docket` rewrites a space as a hyphen
rather than splitting the tag in two, and drops what cannot be a tag at all.

Narrowing by a tag anywhere in docket narrows by the whole subtree, which is what the same word
does in Obsidian. Anything else would mean the two clients answer the same question differently.

### 3.4 A relation says how two tasks are connected

`parent` is hierarchy. Everything else is an annotation, and the property name is the verb:

```yaml
blocked_by: ["[[ACME-4 Session model]]"]
relates: ["[[BETA-7 Ship the widget]]"]
```

Seven of them, in inverse pairs: `blocks` / `blocked_by`, `duplicates` / `duplicated_by`,
`causes` / `caused_by`, and `relates`, which is symmetric. They are Jira's set minus `clones`,
which describes how a task came into existence rather than how it relates to the work — and
which git records anyway.

Written as links, like every other relationship, so each one is an edge in the graph and each
one shows in backlinks. Jira keeps these in a table with an admin screen over it; here a
relation is a line of frontmatter whose name is a verb.

**They carry no structure.** `parent` decides what a board does — the column a card is in, the
children a task shows, what a backlog excludes. A relation changes nothing except what somebody
reads and acts on. Jira's own documentation warns about this exact confusion, because several
marketplace apps ship a link type called "Parent-Child" that is not the parent field. One field
is hierarchy; these are not.

The one exception, because it is the one that changes what somebody picks up next: a task with
an unfinished `blocked_by` is marked on the board. Blocked by something already done is not
blocked.

Each side is written independently. Nothing writes the inverse for you, because doing so would
edit a task somebody did not ask to change — and in a workspace it may be in another
repository. `docket check` reports a relation pointing at a task that is not there.

### 3.5 Frontmatter is flat

No nested objects, at any depth. This is a hard constraint, not a style preference:

- Obsidian's property editor only renders and edits flat values. A nested field makes the task
  uneditable through the interface.
- Bases filters, groups and sorts on top-level properties. A nested field cannot appear on a
  board or in a filter.

Project-specific fields sit at the same level as core ones. A vault that tracks which
environment a bug appeared in adds `env: staging`, not `fields: {env: staging}`.

Fields carried in from another system are prefixed `x_` — `x_sprint`, `x_epic_link`. The prefix
keeps a foreign schema from colliding with the core one and makes imported data obvious to
anyone reading the file.

### 3.6 Status is a pair

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

### 3.7 Links and aliases

**Link to a task by its whole note name**: `[[ACME-4 Session model]]`. Obsidian resolves a link
without a slash against the names of notes anywhere in the vault, and names are unique because
keys are.

`[[ACME-4]]` on its own resolves to nothing. Obsidian's resolver does not consult `aliases` —
this was checked before the format relied on it, not assumed. `docket check` reports a bare key
as a broken link and prints the name to use instead.

`aliases` is still worth filling: it drives the quick switcher and search, so a key carried in
from another system stays findable by someone typing it. It does not make links work.

### 3.8 Comments

Comments are appended to a `## Comments` section at the end of the body, oldest first:

```
**<author> · <YYYY-MM-DD HH:mm>** — text
```

The cost is known: two agents commenting on one task in parallel branches conflict on the same
region of the same file. That is accepted. A conflict at the end of a file is trivial to
resolve, and the alternative — one file per comment — scatters a single conversation across a
directory and makes the task unreadable without tooling.

### 3.9 History

The change history of a task is its git history. `git log --follow -p "ACME/ACME-12 Fix login redirect loop.md"` shows who moved it,
when, and what the previous value was. The core keeps no separate journal: a second record of
the same facts is a second thing that can be wrong.

The one exception is import. A task carried in from another system arrives with a history git
never saw, so it is written to `ACME/_history/12.jsonl` — one JSON object per event,
append-only. Files under `_history/` are read-only after import.

### 3.10 An estimate is a number

```yaml
estimate: 3
```

A plain unquoted number, written after `priority`, and a field rather than a link deliberately.
An estimate is the one thing that is supposed to fail the test in [[how-things-connect]] §1:
standing at a task, nobody needs to know what else in the vault was estimated at three.
`priority` is the precedent — a property of one task, sorted and totalled, never navigated.

The unit and the values allowed are the vault's, declared in `docket.yaml`; see 4.3. A declared
scale means the interface offers those values and nothing else, and rule 12 refuses a number off
it.

**Absent and `0` are different.** `0` claims there is no work in the task. Absent is nobody
having said, which is the state a task is created in and stays in until somebody estimates it —
so a vault where nothing carries the field is a vault that has not estimated, not a vault of
zeroes.

**A task that has children may not carry one.** A container's estimate is the sum of its
children's, added up by whatever is displaying it and written down nowhere: an epic carrying
`estimate: 8` whose tasks add to thirteen is two records of one fact, which is what [[purpose]]
§4 exists to refuse. Rule 12 reports an estimate on a task that something else names as its
parent.

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

### 4.2 A type has a level

```yaml
types:
  - name: epic
    level: 1
  - task
  - bug
  - name: subtask
    level: -1
```

A bare name is level 0. A level says how the types stack, and it is what makes an epic a
container rather than a word:

| Level | What it is |
|---|---|
| `1` and above | Holds standard work. Higher levels are allowed and unnamed — a vault that wants an initiative above its epics says `2`. |
| `0` | The ordinary unit of work, and the default. |
| `-1` | Work inside one task. Never appears in a backlog on its own. |

**A parent sits above its child.** Jira says exactly one level above, which is right for its
fixed three-level model and too strict here, where a vault may use levels 0, 1 and 3 and mean
it. Above is the rule, and it is the one that stops a bug from owning an epic.

**Nothing is enforced until a vault says something.** A `types` list of bare names means what it
has always meant — any task may hold any other — and only a vault that describes its hierarchy
gets it checked. Turning the rule on for everybody would make existing vaults wrong about
themselves overnight.

The level cannot be guessed from the name. A real project's types are the team's own words in
the team's own language: `Эпик`, `История`, `Подзадача`. `Эпик` is an epic only because
somebody says so.

### 4.3 The vault chooses the unit an estimate is in

```yaml
estimates:
  unit: points
  scale: [1, 2, 3, 5, 8, 13]
```

The block is optional. `unit` is required when it is there and is a free string — a team that
counts hours says `unit: hours` — because what a number of points means is a local agreement and
no list of units we wrote would hold every team's.

`scale` is the values the vault estimates in. It is optional: absent means any number, which is
what a team counting hours wants. Present, it is the same shape as `statuses` and `priorities` —
a vocabulary the vault chose, offered by the interface and enforced by rule 12.

A vault that has not declared a unit is a vault that does not estimate: no field is offered, and
a number written into a task by hand is in no unit anybody reading it can name.

### 4.4 A vault adds the fields it needs

Twelve properties belong to the format. A team needs more than twelve, and a tracker where
adding one means a schema migration is a tracker with a spreadsheet beside it. So `docket.yaml`
declares them:

```yaml
fields:
  - name: found_in            # the property, as written in frontmatter
    label: Found in           # what a person reads; the name will do without it
    kind: text                # text | number | date | datetime | choice | flag | link
    types: [bug]              # which types carry it; empty means all of them
    required: true
    help: Which build it was seen on
  - name: risk
    kind: choice
    choices: [low, high]      # a choice, and only a choice, has these
```

A field is a frontmatter property and nothing else. That is what makes it work in Obsidian
without the tool: it appears in the property editor, it filters in a Base, and it is still
there if the binary is deleted. Nothing here invents a store.

**A field is a property of one task.** Every kind above is a scalar for that reason: anything
that joins two tasks is a link, and [[how-things-connect]] §3 says which mechanism answers which
question. A choice whose values want a page behind them is a label.

**A property name may be in any script**, because the vault's words are the vault's — a project
whose fields are Russian declares Russian names, and the importer writes exactly those. What it
may not be is a property the format already owns: `status` as a free text field is a board that
cannot draw a column.

**The level of checking is deliberate.** Rule 15 asks whether a number parses and whether a
choice is on the list. It does not ask whether the value is right, and a rule that tried would
be a rule people switch off.

**A field is not refused on the way in.** A value that does not match its declaration is written
and then reported — the opposite of how a status is handled, and on purpose. A status the board
cannot read breaks the board; a field that says the wrong thing is a mistake in somebody's data,
and a form that will not save until every unrelated property is correct is a form nobody can use
on a vault imported from a system that had no such rule.

**Removing a field from the vocabulary leaves the values in the files.** Deleting a property
from a thousand tasks because somebody edited a settings page is not something a form does
behind you; `docket check` simply stops having an opinion about a field nobody declares.

## 5. Knowledge base

`docs/` is a free tree of Markdown pages. The tree is free — a page goes wherever it belongs, and
a wiki that demands a folder for everything stops getting written in — but a page is not
shapeless. Every page carries `title`, `type` and `updated`, and each of the five values `type`
may take says where the page lives and what, if anything, it must contain. That is [[documents]],
which is normative and is what an agent follows when it writes one. The five kinds, the shape of
a decision and the rest live there rather than here, because this file is about tasks.

Pages link to each other with `[[wikilinks]]`, which is what makes the graph view and backlinks
worth opening, and boards can be built over the frontmatter.

Tasks link to pages and pages link back. That shared link layer is the whole of the integration
between the tracker and the knowledge base; there is no other coupling between them.

The principle these two rules come from — what the graph is for, and why each mechanism exists
— is [[how-things-connect]]. This section is the normative part of it.

### 5.1 A link is a relationship, not a route

**A page whose purpose is to list other pages must not be written.** No index of labels, no
"see also" that names every sibling, no front page that links every epic.

The graph is a picture of what relates to what. A table of contents connects everything it
lists, so it lands in the middle of the graph and collapses the distance between clusters that
have nothing to do with each other. Getting from a payment bug to an antifraud story becomes
two hops through a list somebody made, and the graph stops answering the only question it is
good at.

This is measurable, and it was measured on a vault of 42 notes:

| | With an index of labels and a front page listing the epics | Without them |
|---|---|---|
| Edges | 85 | 70 |
| Largest cluster | 43 of 43 — one blob | 30 of 42 — clusters |
| Most connected notes | `метки` (11), `index` (9) | a task (8), a label (8) |

Eighteen per cent of every edge in the vault was navigation, and the two most connected notes
in it were both tables of contents. Removing them is what let the graph fall into clusters.

What replaces an index: the file explorer, the tag pane, the quick switcher, and backlinks.
Obsidian ships four ways to find a page. None of them draws an edge.

A front page is allowed to link the few pages somebody must read — that is a relationship
("read this first"), and there are three or four of them. It is not allowed to link everything.

### 5.2 Which document carries what

Five mechanisms, five jobs. Using one for another is what produces a graph nobody opens.

| | What it is | Draws an edge | On a task | On a page |
|---|---|---|---|---|
| `parent` | hierarchy — this is inside that | yes | exactly one, one level up | never |
| relations | a named relationship between two tasks | yes | as many as are true | never |
| `labels` | a theme work gathers around | yes | one or two | never on a label page |
| `sprint` | the fortnight the work was planned into | yes | one at a time, or none | never — a sprint page is what is pointed at |
| `tags` | a slice to search by | no | as needed | as needed |

- **One or two labels.** A task with five is a task whose labels each mean too little. A label
  is a place where work gathers, and it earns its edges by being the reason those tasks are
  near each other.
- **A label page never links another label page.** Its value is its backlinks. Linking siblings
  turns the labels themselves into the blob.
- **A label and a tag never say the same thing.** Both `labels: ["[[оплата]]"]` and
  `tags: [оплата]` on one task is one fact recorded twice, and the second copy is the one that
  goes stale.
- **Tags are free, links are not.** A tag is not a node and costs the graph nothing, so
  `area/платежи`, `риск/деньги`, `регресс` may be used liberally. A wikilink is an edge and is
  spent deliberately.
- **A sub-task usually needs no labels at all.** It is inside a task that has them.
- **A sprint page never links a task, in a list or in prose.** Its contents are its backlinks.
  Measured on a forty-six note vault, the `sprint` property cost thirteen per cent of every edge
  and the wikilinks in three sprint pages' prose cost twenty-eight per cent more, collapsing the
  largest cluster from thirty of forty-three notes to forty-three of forty-six. In prose, name a
  task by its key in backticks: `` `PROJ-12` ``. Rule 13 reports it.

### 5.3 A sprint is a page

A sprint is a page under `docs/sprints/`, named after its title the way a task is named after
its own:

```markdown
---
title: Sprint 24
type: sprint
starts: 2026-08-17
ends: 2026-08-28
updated: 2026-08-28
---
```

`docs/sprints/Sprint 24.md`. The dates are plain unquoted `YYYY-MM-DD`, which is the form
Obsidian reads as a date and can sort on. Retitling a sprint renames the file and rewrites the
links to it, exactly as retitling a task does.

A sprint's name is unique in the vault, because a link resolves by note name and `docs/` is one
tree. Two projects on different cadences either name their sprints differently or live in
different vaults — the same answer §4 gives about statuses, and for the same reason.

`type: sprint` is what the page says it is. `types` in `docket.yaml` is the task vocabulary and
rule 4 checks tasks; a page is free to call itself what it is. This is the one shaped document in
an otherwise unschematised tree, and it is shaped because a task points at it and something has
to be able to tell what it is pointing at.

**There is no state field.** A sprint runs between two dates, and whether it is on is a question
about today — which cannot go stale. A field saying `active` is a second record of what the dates
already say, and it is the copy that rots: a sprint nobody remembered to close sits `started`
for a year, which is the most familiar piece of stale data in any tracker that has sprints.

The body is the goal in more than one line, what was cut and why, and the retrospective. That is
the part Jira has no room for, written where the work is rather than in a document in another
tool — and it is also what makes the page worth being a hub at all, because a page of two dates
teaches nobody anything ([[how-things-connect]] §5).

**Membership is a wikilink on the task**, written after `assignee`:

```yaml
sprint: "[[Sprint 24]]"
```

One sprint at a time. A carried-over task names the sprint it is in **now**; that it did not
finish in the previous one is said in that sprint's retrospective, in a sentence that also says
why — which is the thing a task belonging to two sprints never manages to say.

The link is on the task rather than a list on the sprint page for one decisive reason: Bases
filters on a property of the note it is drawing, so a sprint board is `note.sprint` and nothing
else, and a vault with nothing installed has one only if the task carries the field ([[purpose]]
§5). Both directions draw the same undirected edge in the graph, so the choice was never about
the graph — it was about who maintains the fact and who can read it.

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
properties:
  note.title:
    displayName: Title
views:
  - type: cards
    name: Board
    groupBy:
      property: note.status
      direction: ASC
    order:
      - note.title
      - note.assignee
      - note.priority
```

Two details in that file were established by opening it in Obsidian, because the published
syntax reference is wrong about both. Checked against Obsidian 1.13.7.

`groupBy` needs `direction` as well as `property`. Given only a property, Obsidian refuses the
whole file with "groupBy must be of type object" — which is true of the value and is not the
reason. Its parser requires both keys and names neither.

A property under `properties:` is written qualified — `note.title`, not `title`. The published
example uses the bare form, and the bare form is accepted and silently ignored: the key is
matched against the same qualified identifier `order` uses, so a display name written the short
way never appears.

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
10. Every relationship is a link: `parent`, every entry in `labels`, and every typed relation
    are wikilinks, not bare strings. See 3.3 and 3.4.
11. Every tag is carried by more than one note, and no tag repeats a label. A tag is a set
    somebody asks for, and a set of one is not a set. See 5.2.
12. Every `estimate` is on the `scale` in `docket.yaml` when the vault declared one, and no task
    that has children carries one at all — a container's estimate is the sum of its children's
    and is never stored. See 3.10 and 4.3.
13. Every `sprint` is a wikilink naming a page whose `type` is `sprint`; every sprint page's
    `starts` and `ends` are dates in that order; no two sprints cover the same day; and no
    sprint page links a task — a sprint's contents are its backlinks, and in prose a task is
    named by its key in backticks. See 5.3.
14. Every page under `docs/` says what kind of document it is, and a decision has the shape a
    decision has: the four sections, a number no other decision uses, a `status` from the three
    and the `date` it was taken, and a `supersedes` written as a link. See [[documents]].
15. Every value of a field the vault declared means what its `kind` says: a number parses, a
    date is `YYYY-MM-DD`, a `datetime` is a moment, a choice is on the list, a flag is true or
    false, and a link has a scheme and a host. A required field is present, and a field
    belonging only to other types is not. See 4.4.

`docket.yaml` itself must also parse and agree with itself — every status has one of the three
categories, every project key is usable, every name in `transitions` is a status the vault has,
`estimates` has a `unit` if it is there at all, and every declared field has a usable property
name the format does not already own, a kind that exists, and choices if and only if it is a
choice. A file that fails those is refused at load
rather than reported as a finding: nothing else can be checked against a vocabulary that does not
make sense.

Rules 1–7, 10, 12 and 15 are checkable from the project folders and `docket.yaml` alone, and rule
14 from `docs/` alone. Rules 8, 9, 11 and 13 need the whole vault: whether a link resolves, whether
a tag is carried twice, whether a container has children, and whether a sprint page exists are
all questions about the other files. `docket check` implements all fifteen and reports each
finding with a file and a line.
Two of them have a right answer rather than a judgement — a name that drifted from its title,
and a relationship still written as a string — and `docket check --fix` settles those.
