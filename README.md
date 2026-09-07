# docket-board

The board and knowledge base of the docket project itself — kept in docket's own format, which is
what makes it the working example.

This repository is an **Obsidian vault**. Clone it, open the folder in Obsidian, and you get a
task board, a backlog and a wiki. There is nothing to install and nothing to run: tasks and
pages are plain Markdown files with YAML frontmatter, and git is the history.

It is also the specification. `docs/spec/vault-format.md` is the normative description of the
format; every vault docket manages looks like this one.

## Quick start

```bash
git clone https://github.com/vadymdidenkolab/docket-board.git
open -a Obsidia docket-board     # macOS. Elsewhere: Obsidian → Open folder as vault
```

The left pane is the file tree — `DKT/` is the work, `docs/` is the wiki. Open `boards/board`
for the board, `boards/backlog` for the backlog, and the graph view for how it all connects.

With the [docket](https://github.com/vadymdidenkolab/docket) binary you can have the same thing in
a browser instead:

```bash
cd docket-board
docket serve --auth none --author "Your Name <you@example.com>"
```

Open <http://127.0.0.1:8080>: the same tasks as a board with six columns — Backlog, Ready, In
progress, In review, Done, Dropped — the same pages as a wiki, and a search across both.

## Requirements

git, and then either Obsidian or the docket binary or neither: the files are Markdown, and a text
editor reads them. Nothing here needs Go, Python or Docker.

## Install

Nothing to install — this is a vault, not a program, and `git clone` is the whole of it. The
tool that reads it is a separate, optional download; see
[docket](https://github.com/vadymdidenkolab/docket).

## Usage

A key is `DKT-12`, and the file is named after the task, so the graph and the file explorer say
what each note is. Link to one by its whole name: `[[DKT-12 See the boards render in Obsidian]]`.

Work is planned here the way it is done: open a task, edit its frontmatter, commit. A change to
the plan is a pull request, reviewed on the lines. `docket check .` validates the whole vault
against the specification and names a file and a line for anything it does not like.

## Configuration

`docket.yaml` at the root is the whole of it: the projects this vault holds, the statuses and
their categories, the types and their levels, the priorities, the fields and relations the apps
brought, and the workflow that says which status may move to which. Change it and commit it —
`docket check --fix` regenerates the boards to agree with it.

## How it works

Tasks and pages are one file tree, and a wikilink is the only pointer that joins them: `parent`,
`labels` and the relations are links, so an epic has an edge to each of its tasks and a label is
a hub joining everything that carries it. That is why the graph is worth opening, and why
Obsidian's backlinks pane answers questions no field was added for. The long version is the
[vault format](docs/spec/vault-format.md), and the decisions under `docs/decisions/` that say
why it is that way.

## Where things are

| Path | What |
|---|---|
| `docket.yaml` | The projects this vault holds and the vocabulary they share |
| `DKT/` | The docket project. `DKT-12 Its title.md` is the task `DKT-12` |
| `docs/` | Knowledge base — a free tree of wiki pages |
| `boards/` | Obsidian Bases views: board, backlog, my tasks, OKRs |
| `templates/` | Templates for a new task and a new page |
| `hooks/` | The programs the installed apps draw their pages and panels with |
| `scripts/` | `check-template-drift.sh`, which is what CI runs beside `docket check` |
| `AGENTS.md` | How an agent works in this vault |

### Reading order

1. [Vault format](docs/spec/vault-format.md) — the normative spec
2. [ADR-0001](docs/decisions/0001-vault-as-source-of-truth.md) — why files and not a database
3. [ADR-0002](docs/decisions/0002-go-and-a-single-binary.md) — what the tool is written in, and how you get it
4. [ADR-0003](docs/decisions/0003-a-vault-holds-several-projects.md) — why one vault holds many projects
5. [ADR-0004](docs/decisions/0004-access-comes-from-git.md) — why access comes from the git host
6. [ADR-0005](docs/decisions/0005-a-file-is-named-after-its-task.md) — why a file is named after its task
7. [Roadmap](docs/roadmap.md) — what is built and in what order

### The rest of the family

| Repository | What |
|---|---|
| [`docket`](https://github.com/vadymdidenkolab/docket) | The tool: the CLI, the server and the MCP endpoint, as one Go binary |
| [`docket-apps`](https://github.com/vadymdidenkolab/docket-apps) | Packs of vocabulary and files a vault takes on — twelve of them |
| [`docket-template`](https://github.com/vadymdidenkolab/docket-template) | What a new vault starts as. `docket init` clones it |
| [`docket-demo`](https://github.com/vadymdidenkolab/docket-demo) | A demonstration: two projects, seven tasks, a page. Open it to see what the format is, in a minute |
| [`docket-testbed`](https://github.com/vadymdidenkolab/docket-testbed) | A fixture, not a demo: a fictional payments team's vault with an eight-stage pipeline, a vocabulary that is not English and six weeks of history. It exists to disagree with us, and it does — see [The testbed](docs/design/the-testbed.md) |
| [`docket-showcase`](https://github.com/vadymdidenkolab/docket-showcase) | The whole of it on a team's worth of work: three products, six people, twelve weeks and every app, all invented and built by a generator. Open it to see what a board looks like after a quarter |
| [`northlight`](https://github.com/vadymdidenkolab/northlight) | That invented company's code, beside its vault |

Only `docket-template` is public today; the rest need access.

## Contributing

Read [AGENTS.md](AGENTS.md) first — the normative account of how to edit this vault, and the
same file whether the editor is a person or an agent. Then `docket check .`, which exits non-zero
when it finds anything and so works as a pre-commit hook. `.github/workflows/vault.yml` runs it
on every push and pull request together with `scripts/check-template-drift.sh`, which catches
this vault drifting from the templates the tool ships.

Work goes on the board here: a bug or an idea is a task in `DKT/`, added by a pull request like
anything else.

## License

MIT — see [LICENSE](LICENSE).
