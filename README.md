# docket-board

The board and knowledge base of the docket project itself — kept in docket's own format.

This repository is an **Obsidian vault**. Clone it, open the folder in Obsidian, and you get
a task board, a backlog and a wiki. There is nothing to install and nothing to run: tasks and
pages are plain Markdown files with YAML frontmatter, and git is the history.

It is also the specification. `docs/spec/vault-format.md` is the normative description of the
format; every other project managed by docket looks like this one.

## Where things are

| Path | What |
|---|---|
| `tasks/` | One Markdown file per task, named after its key: `DKT-12.md` |
| `docs/` | Knowledge base — a free tree of wiki pages |
| `boards/` | Obsidian Bases views: board, backlog, my tasks |
| `templates/` | Templates for a new task and a new page |
| `project.yaml` | Project key, statuses, task types |
| `AGENTS.md` | How an agent works in this vault |

## Reading order

1. [Vault format](docs/spec/vault-format.md) — the normative spec
2. [Architecture decisions](docs/decisions/0001-vault-as-source-of-truth.md) — why it is built this way
3. [Roadmap](docs/roadmap.md) — what is built and in what order

## The tool

The `docket` CLI and server live in a separate repository. This vault works without them —
they add key allocation, validation, a web UI and importers on top of the same files.
