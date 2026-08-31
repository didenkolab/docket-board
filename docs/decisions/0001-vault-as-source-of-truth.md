---
title: The vault is the source of truth
type: decision
status: accepted
date: 2026-08-30
updated: 2026-08-31
---

# ADR-0001 — The vault is the source of truth

## Context

Agents do most of the work in this system, and agents are good at files and bad at web
interfaces. A tracker whose data lives in a database behind an API forces every agent action
through a network round trip and a schema it cannot inspect. Meanwhile the humans on the same
project want a board, a backlog and a wiki — not a folder of YAML.

Obsidian resolves the tension: it renders a folder of Markdown as a linked knowledge base, and
since Bases became a core plugin it renders database views over frontmatter too. A folder can
be both the agent's working directory and the human's product.

## Decision

**A project is a git repository that is also an Obsidian vault.** Tasks and pages are Markdown
files with flat YAML frontmatter. Git is the history. Obsidian is a client.

Consequences that follow, and that we accept:

1. **No database in the core.** Any index is derived and must be fully rebuildable from the
   files. If an index and the files disagree, the files are right.
2. **No API is required to participate.** An agent creates a task by writing a file. The CLI
   and the server add convenience and validation, never exclusivity.
3. **Export is `git clone`.** There is no lock-in to remove later, because there is none now.
4. **The change log is `git log`.** We do not keep a parallel audit trail of facts git already
   records.
5. **Access boundaries are repository boundaries.** One project, one repository, one vault.
   Cross-project reading is a matter of who cloned what — see [[workspace]].

The normative consequences are written up in [[vault-format]] and [[workspace]].

## What this costs

The five above are the rule. Read the other way round, they are the bill.

**No query engine, and no index anybody may trust.** A question the files do not answer directly
is answered by reading them. Anything built to make that faster is derived, has to be fully
rebuildable from the files, and loses to them whenever the two disagree — so no part of the core
may hold a fact that only it holds.

**Nothing can be made compulsory.** An agent creates a task by writing a file, which means it can
just as easily write a file that is wrong. The CLI and the server add validation, and validation
that is not the only door is something that reports rather than something that prevents.

**The history is git's, and it is read on git's terms.** There is no activity feed to filter and
no query over who changed what. The answer is in `git log`, and getting it out is git's interface
rather than one we designed.

**Nowhere to stand and see everything.** One project is one repository, so there is no vantage
point from which every project is visible and no permission that grants one. Somebody who needs
two at once clones two, which is a layout problem rather than a lookup — [[workspace]].

## Alternatives considered

**A server with a database, files exported on demand.** Rejected: the export is always stale,
and the agent ends up talking to the API anyway, which was the problem.

**Files as the format but a proprietary viewer.** Rejected: it means building and maintaining
the thing Obsidian already is, before writing a single feature that is actually ours.

**Obsidian's Kanban plugin as the board.** Rejected: it stores a board as one Markdown file
containing the cards, which makes the board the source of truth and the task files derived —
exactly inverted. Bases reads the task files instead and stores nothing.
