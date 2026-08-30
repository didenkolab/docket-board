---
title: Roadmap
type: page
updated: 2026-08-30
---

# Roadmap

What this is for is [[purpose]]. Two of its five points are not met yet, and they are named at
the bottom of this page rather than buried: relationships are still fields rather than links,
and a board still reads one repository rather than several.

Released: [v0.2.0](https://github.com/vadymdidenkolab/docket/releases/tag/v0.2.0) — binaries for six
platform pairs, and a container image for two architectures.

Five stages. Each one is usable on its own — nothing here is a prerequisite that produces
nothing until the next stage lands.

## 1. Format and vault — done

The vault format ([[vault-format]]), the workspace layout ([[workspace]]), the boards, the
templates and the agent instructions. This repository is the first vault and runs on it from
day one.

What this already gives you: clone, open in Obsidian, work. Board, backlog, wiki, links,
graph, full history in git. No installation.

## 2. CLI — done

`docket init` scaffolds a vault. `docket new` creates a task with a valid key and a filled
template. `docket check` runs the nine validation rules from [[vault-format]]. `docket workspace
sync` clones and pulls projects from a manifest. Released as a single binary for six platform
pairs; see [[0002-go-and-a-single-binary]].

Why it comes second and not first: everything it does can be done by hand, and building it
before the format settled would have frozen the wrong format.

One dependency — a YAML parser — added when [[DKT-6 docket check — validate a vault]] needed to read frontmatter, and not
before.

## 3. Server and web UI — done

`docket serve` is an HTTP service over the same files: a board across every project with cards
you drag between columns, task pages in the shape people know from Jira, the wiki, search,
settings, and a JSON API. It is a second client — it holds no state the files do not have,
reads from disk on every request, and commits every write.

People sign in against the git host that already holds the repository, and what they may do is
what that host says — see [[0004-access-comes-from-git]] and [[DKT-15 Access comes from the git host, not from a user table]]. Commits are authored
by the person who made them.

Every change to a task is a commit, and the task page shows those commits as a history — who,
when, and which fields moved ([[DKT-23 What happened to this task]]). It is read from git on the
way past, so there is no activity table to fall out of step with the files.

A card stays where it is dragged, in the column as well as between columns
([[DKT-20 A column stays in the order you drag it into]]); search narrows by project, status,
type, priority, assignee and label ([[DKT-21 Search you can narrow]]).

Running it on a server is `docker compose up`, which builds from the checkout so that a
registry is never between somebody and a running board
([[DKT-22 A container, so a board can run somewhere other than a laptop]]) — or the binary and a
clone, since that is all it ever was.

## 4. An agent, over a protocol — done

`docket mcp` serves the vault over the Model Context Protocol: eight tools on stdin and stdout,
covering the whole loop an agent runs — find work, read it, create, move, comment, write a
page, validate. See [[DKT-19 An agent drives the vault over MCP]].

It changes nothing about the format. An agent that would rather edit the Markdown still can,
and [[AGENTS]] still says how. What it removes is the four ways a hand-written change goes
quietly wrong: a key another branch already took, a `status` moved without its category, a move
the workflow forbids, a retitle that leaves the file name behind. And `update_task` refuses a
write whose fingerprint is stale, so an agent cannot discard an edit made in Obsidian while it
was thinking.

## 5. Import from Jira and Confluence — done

A pipeline of `extract → plan → apply`: pull a cold snapshot of the source, propose mappings
for fields, statuses, types and people, then write the vault in one reviewable commit.

The constraints it places on the core were honoured in advance by [[vault-format]]: `aliases`
for keys that outlived their system, `x_` for foreign fields, status as a pair so a
cancelled-in-done workflow survives the trip, and `_history/` for a history git never saw.

Not verified against a live instance: there is none to point it at. Extraction is exercised
against a stub server, and everything downstream against snapshots built in tests.

## Not done, and central

These are not extras. They are places where the product does not yet do what [[purpose]] says
it is for, found by checking it against that document rather than against a list of features.

**[[DKT-25 Relationships are links, not fields]]** — `parent` and `labels` are plain strings, so
an epic draws no edge to its tasks and a label connects nothing. In Obsidian, which is where
this is supposed to show, they do not exist.

**[[DKT-26 A board across several repositories]]** — a repository is supposed to be a project,
and a board is supposed to read several of them. It reads one. Several projects in one
repository works and is not the same thing.
