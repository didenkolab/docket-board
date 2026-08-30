---
title: Roadmap
type: page
updated: 2026-08-30
---

# Roadmap

Four stages. Each one is usable on its own — nothing here is a prerequisite that produces
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

One dependency — a YAML parser — added when [[DKT/6]] needed to read frontmatter, and not
before.

## 3. Server and web UI — done

`docket serve` is an HTTP service over the same files: a board across every project with cards
you drag between columns, task pages, the wiki, search, settings, and a JSON API. It is a
second client — it holds no state the files do not have, reads from disk on every request, and
commits every write.

Not done: accounts and roles. The server assumes whoever can reach it may write, and attributes
writes to the author it was started with unless a caller says who it is.

## 4. Import from Jira and Confluence — done

A pipeline of `extract → plan → apply`: pull a cold snapshot of the source, propose mappings
for fields, statuses, types and people, then write the vault in one reviewable commit.

The constraints it places on the core were honoured in advance by [[vault-format]]: `aliases`
for keys that outlived their system, `x_` for foreign fields, status as a pair so a
cancelled-in-done workflow survives the trip, and `_history/` for a history git never saw.

Not verified against a live instance: there is none to point it at. Extraction is exercised
against a stub server, and everything downstream against snapshots built in tests.
