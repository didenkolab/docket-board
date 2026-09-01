---
title: What the Jira marketplace sells, and what we do about each
type: design
date: 2026-09-01
---

The top hundred apps on the Atlassian Marketplace, by installs, read on
2026-09-01 through the marketplace's own API. Sorted by what they actually do
rather than by what they are called, because the names are products and the
shapes repeat.

This is the list the plan is drawn from. It says, for every group: what the
apps in it sell, what we already have, and what is left to build.

## The shape of the hundred

| what they do | of 100 | where we stand |
|---|---|---|
| Reports and dashboards | 22 | the data is in git; the drawing is an app |
| Automation and scripting | 19 | **done** — reactions |
| Integrations | 14 | reactions plus a way in; **half done** |
| Test management | 13 | **done** — the `tests` pack |
| Time tracking | 11 | **done** — the `time` pack |
| Portfolio, hierarchy, Gantt | 8 | levels and roll-ups exist; the drawing is an app |
| Templates and cloning | 4 | templates exist; cloning is a command |
| Service desk, forms, export | 9 | fields and views exist; export is a command |

## What we will not build, and why it is not a gap

Some of the hundred exist because Jira is a database behind an API. We keep
Markdown in git, so the need does not arise.

- **Backup, restore, migration** (Configuration Manager, Insight Backup) — a
  clone is a backup, and a restore is `git checkout`.
- **Audit log, issue history, "who changed what"** (Issue History, and a page
  of every dashboard) — `git log` and `git blame`, already on every task page.
- **Export to Markdown or a wiki** — the files are the export.
- **Bulk edit tooling** — `sed` over a folder, reviewed as a diff.
- **Anything that syncs Jira to a second Jira** (Exalate, Backbone, TFS4JIRA) —
  a repository is already shared; two teams work on one, or on two remotes with
  the ordinary git answer to divergence.

That is roughly a fifth of the list gone, not because we are missing something
but because the storage is different.

## What is done

- **Automation and scripting** — 19 apps, of which ScriptRunner, JMWE, JSU, JWT
  and Power Scripts are the top five. Reactions: the vault declares an event, a
  condition and a program; the server runs it only if it was started with
  `--reactions`. The program writes files and the change is a commit.
- **Test management** — 13 apps, led by Xray and Zephyr. The `tests` pack: test
  plans, tests and runs as types, steps and results as fields, `tests` ↔
  `tested_by` as the verb that carries coverage.
- **Time tracking** — 11 apps, led by Tempo. The `time` pack: an hour is a
  worklog note, not a number on a card, so it can be corrected, invoiced and
  argued with.
- **Time in status** — four apps sell this alone (Time in Status, Timepiece,
  Status Time Reports twice). `docket report time-in-status` reads it out of the
  history, following renames, and prints a table or JSON for an app to draw.

## What is next, in order

1. **Surfaces.** A page and a panel drawn from a program's output. This is what
   turns the 22 reporting apps from "not possible" into "somebody's afternoon":
   eazyBI, Custom Charts, Great Gadgets, Dashboard Hub and the rest are all a
   query and a drawing, and the query is `docket report … --json`.
2. **An Obsidian plugin.** The board, in the app people already have the vault
   open in. Everything works there today through Bases and the graph, but a
   status is changed by editing frontmatter; a plugin makes it a click, and
   brings the board, the filter bar and the reports inside Obsidian.
3. **Anomalies from the graph.** Not a marketplace category at all — an
   advantage nobody else has. `docket graph` already measures clusters, hubs and
   islands; the same numbers over time say things a board cannot: work nothing
   links to, an epic whose children stopped linking back, a label that has
   become a hairball, a person who is the only edge into a cluster.
4. **Cloning** (Deep Clone, Elements Copy & Sync — 4 apps). `docket clone
   ACME-12 --children`, which is a file copy and a key rewrite.
5. **Export** (Xporter, Better PDF, Better Excel, BigTemplate — 4 apps).
   `docket export --format csv|json` and a Markdown-to-PDF that is somebody
   else's binary, not ours.
6. **Checklists** (3 apps). The acceptance list already renders; what is missing
   is progress on the card and a template that carries a definition of done.
7. **Portfolio and Gantt** (8 apps). Levels and roll-ups exist; a timeline needs
   two date fields and a drawing, and the drawing is a surface.

## The rule the plan follows

Everything above is a pack or a program, and nothing is a feature of the board.
The core keeps what is hard to get right and shared by all of them: reading the
vault, reading git history correctly, and the one place a vault's own program is
executed. What each app does with that is its own business, in its own
repository, installed as a diff.
