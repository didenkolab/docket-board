# docket-board

The board and knowledge base of the docket project itself — kept in docket's own format.

This repository is an **Obsidian vault**. Clone it, open the folder in Obsidian, and you get a
task board, a backlog and a wiki. There is nothing to install and nothing to run: tasks and
pages are plain Markdown files with YAML frontmatter, and git is the history.

It is also the specification. `docs/spec/vault-format.md` is the normative description of the
format; every vault docket manages looks like this one.

## Where things are

| Path | What |
|---|---|
| `docket.yaml` | The projects this vault holds and the vocabulary they share |
| `DKT/` | The docket project. `DKT-12 Its title.md` is the task `DKT-12` |
| `docs/` | Knowledge base — a free tree of wiki pages |
| `boards/` | Obsidian Bases views: board, backlog, my tasks |
| `templates/` | Templates for a new task and a new page |
| `AGENTS.md` | How an agent works in this vault |

A key is `DKT-12`, and the file is named after the task, so the graph and the file explorer say
what each note is. Link to one by its whole name: `[[DKT-12 See the boards render in Obsidian]]`.

## Reading order

1. [Vault format](docs/spec/vault-format.md) — the normative spec
2. [ADR-0001](docs/decisions/0001-vault-as-source-of-truth.md) — why files and not a database
3. [ADR-0002](docs/decisions/0002-go-and-a-single-binary.md) — what the tool is written in, and how you get it
4. [ADR-0003](docs/decisions/0003-a-vault-holds-several-projects.md) — why one vault holds many projects
5. [ADR-0004](docs/decisions/0004-access-comes-from-git.md) — why access comes from the git host
6. [ADR-0005](docs/decisions/0005-a-file-is-named-after-its-task.md) — why a file is named after its task
7. [Roadmap](docs/roadmap.md) — what is built and in what order

## The tool

The `docket` CLI and server live in a separate repository. This vault works without them —
they add key allocation, validation, a web board and importers on top of the same files.

## The other vaults

**docket-demo** is a demonstration: three columns, five tasks, English words. Open it to see
what the format is in a minute.

**docket-testbed** is a fixture, not a demo. A fictional payments team's vault with an
eight-stage pipeline, a vocabulary that is not English and six weeks of history — a vault where
our assumptions are not true. It exists to disagree with us, and it does; see
[The testbed](docs/design/the-testbed.md).
