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

## 2. CLI

`docket init` scaffolds a vault. `docket new` creates a task with a valid key and a filled
template. `docket check` runs the eight validation rules from [[vault-format]]. `docket workspace
sync` clones and pulls projects from a manifest.

Why it comes second and not first: everything it does can be done by hand, and building it
before the format settled would have frozen the wrong format.

## 3. Server and web UI

An HTTP service over the same repositories: a board for people who do not have Obsidian, an
API, accounts and roles. It is a second client to the same files — it holds no state the files
do not have.

Substantial parts of this exist already in an earlier private prototype and will be ported
rather than rewritten.

## 4. Import from Jira and Confluence

A pipeline of `extract → plan → apply`: pull a cold snapshot of the source, propose mappings
for fields, statuses, types and people, then write the vault in one reviewable commit.

The design constraints this places on the core are already honoured by [[vault-format]] —
`aliases` for keys that outlived their system, `x_` for foreign fields, status as a pair so a
cancelled-in-done workflow survives the trip, and `_history/` for a history git never saw.
