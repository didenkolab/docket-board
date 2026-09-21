---
title: Public release and the showcase
type: design
updated: 2026-09-06
---

# Public release and the showcase

Two pieces of work, decided together on 2026-09-06 because the second is what the first is
for: the docket repositories made fit to open, and a showcase that shows what the tool does
on something that looks like a real team's work.

## 1. What "ready for public" means

A reader who clones any docket repository finds a tool, its apps, its own board, a template,
a demo and a showcase — and nothing else. Concretely:

- **No customer, employer or product of somebody else** anywhere: not in code, help text,
  fixtures, documents, commit messages or commit history. Examples say ACME and BETA, hosts
  say `example.com`.
- **One author.** Every commit in every public repository is
  `Vadym Didenko <vadym@didenkolab.com>`, which GitHub attributes to `didenkolab`. The
  one exception is `agent@docket.local`: those commits were made through `docket mcp` and
  `docket serve`, and a history that says which writes an agent made is the product's own
  argument. They stay.
- **The vaults agree with the tool.** `docket check` is clean in every vault, and the boards
  a vault carries are the ones `docket check --fix` would generate today.
- **The READMEs agree with the visibility.** `core` tells a reader to clone `docket-demo`;
  that is only true once `docket-demo` is public. Which repositories to flip is the owner's
  decision and is made last, in the GitHub settings, after everything below is done.

### 1.1 Where each repository stands

| Repository | Customer traces | Authors | Check | Decision |
|---|---|---|---|---|
| docket (core) | none — history rewritten 2026-09-06 | one | clean | done |
| docket-apps | none — history rewritten 2026-09-06 | one | clean | done |
| docket-board | none | seven identities over 104 commits | clean | rewrite authors; keep `agent@docket.local` |
| docket-template | none | three identities | clean | rewrite authors |
| docket-testbed | none | four fictional authors, one agent, two real | clean | rewrite only the real identities; the four fictional ones are the fixture's history and are documented in [[the-testbed]] |
| docket-demo | none | `claude@example.com` and two demo identities | one finding: `board.base` is stale | rewrite authors; regenerate the board |
| docket-test | **23 blobs in history** | one identity | clean | **not published.** It is the laboratory for checks against live boards and holds copies of live data by design. It stays private and is not part of the family a reader sees. |

Rewriting is `git filter-repo --mailmap`, force-pushed, with a mirror of the previous history
kept in `_archive/` first — the same procedure core and apps went through. Every clone
elsewhere is re-cloned afterwards, never pulled.

### 1.2 What the tool's own documents say

- `core/README.md` names `docket-board` as where the format lives and `docket-demo` as the first
  thing to open. After this work it also names `docket-showcase` as the second: "to see the
  whole of it on a team's worth of work".
- This vault's README and [[the-testbed]] describe the two other vaults. A third, the showcase,
  is added beside them with the same honesty: everything in it is invented.

## 2. The showcase

### 2.1 What it is

**Northlight** is an invented software company with three products, and `docket-showcase` is
its vault: one repository, three projects, twelve weeks of history by six people. Beside it,
`northlight` is the company's code — a monorepo of three small Python services with Gherkin
features — so that the parts of docket that read a codebase (test import, coverage by blame,
people from git) read a real one.

The three products are the "one to three demo projects that look like real work". They are
three projects in one vault rather than three vaults, because that is how a company of this
size actually runs a board, and because a single vault is what shows cross-project links,
a project tab drawing its own columns, and a workspace being unnecessary until it is.

| Key | Product | What it is | Why it is in the story |
|---|---|---|---|
| `HARBOR` | Harbor | Berth booking and invoicing for marinas: bookings, berth calendar, mobile check-in | seasonality gives deadlines; card payments give incidents; marinas are outside customers, so intake has requests |
| `LEDGER` | Ledgerline | Bookkeeping for small businesses: invoices, bank imports, tax periods | rules and edge cases make good tests and a risk register |
| `FIELD` | Fieldnote | Scheduling for field service crews: jobs, routes, an offline mobile app | offline sync is where the bugs and the postmortem come from |

Nothing in it resembles a real customer of the author's. The names of the people are
invented, the domains are `northlight.example`, and the README says so in its first paragraph.

### 2.2 The vault

`docket.yaml` declares three projects and one vocabulary:

- statuses `Backlog, Ready, In progress, In review, QA, Done, Cancelled`, with transitions that
  move forward one stage, back to `In progress` from review or QA, and to `Cancelled` from
  anything before `Done`;
- types `epic` (level 1), `story`, `task`, `bug`, `subtask` (level −1), plus every type the
  twelve apps add;
- priorities `low, normal, high, critical`; estimates in story points on `[1, 2, 3, 5, 8, 13]`.

All twelve apps from `docket-apps` are installed, and each one has data to show:

| App | What the showcase holds |
|---|---|
| tests | test plans per product, sets per feature area, ~60 tests imported from `northlight/features`, eight executions with runs, a handful of failures that `found` bugs |
| time | worklogs on the current and last sprint's tasks, some billable (Harbor is billed to marinas) |
| risks | a register of six risks with `threatens` and `mitigated_by`, reviewed on dates |
| okr | one quarter: three objectives, seven key results, `contributes_to` from epics |
| incidents | two incidents (a payment double-charge in Harbor, a sync loss in Fieldnote) with postmortems, `causes` on the bugs they produced |
| intake | eight requests from marinas and accountants, three of which `became` work |
| checklists | a definition of done on stories, partly ticked |
| estimation, portfolio, workload, time-in-status, anomalies | programs over the data above; the showcase makes sure each has something to draw — unestimated stories, an epic roll-up, one overloaded person, a task stuck in review, an adrift task |

Around the tasks: six people pages under `people/`, eight label pages, `docs/index.md`,
a design page per product, six decisions in the shape [[documents]] requires, six sprints
(four finished with retrospectives, one running, one planned), and attachments — the test
results chart the tests app draws, and one architecture diagram.

About 130 tasks in all, connected by every one of the seven relations, including
`blocked_by` across projects.

### 2.3 The code

`northlight` is one repository:

    harbor/       ledgerline/    fieldnote/     three small packages, a few modules each
    features/harbor/  features/ledgerline/  features/fieldnote/   behave features
    run-tests     three lines: behave <feature> --junit
    README.md

Scenarios carry case ids in the form `@HARBOR-BKG-001` where a person would have written
one, and none where a person would not — so the import shows both a written identity and a
derived one. Commit subjects name the task they were for, `HARBOR-42: ...`, so
`link-coverage` finds by blame which story each scenario covers. The runs are real: behave
runs, writes JUnit, and the import turns it into an execution. Two scenarios fail on purpose
at the revision the last execution was taken from.

### 2.4 How it is built

A generator, `.showcase/build.py` in the vault repository, holds the whole story as data — the
people, the products, every task with its dates, every move, comment and sprint — and replays
it into git with the author and date each event has. The vault is reproducible in one command
and the README says that is how it was made.

The generator uses the tool for what the tool does (`docket new`, `docket set`, `docket app add`,
the tests app's hooks) and writes files directly only where no command exists (pages, people,
attachments), so the showcase is also a long test of the CLI.

Vault history is by the six invented people, at `name@northlight.example`. The generator, the
README and the scaffolding are committed by the owner as `vadym@didenkolab.com`.

### 2.5 Done means

- `docket check`: no findings. `docket graph` and `docket anomalies` return findings that read as
  a real team's — the anomalies are planted, and each one is something a reader can look at.
- `docket serve --programs` draws all twelve apps' pages and panels with data on them.
- `docket report time-in-status` shows a spread, not a column of zeros.
- The coverage page links features to stories; `people --from-git` finds the same six people
  in `northlight` that the vault names.
- `docket-board` has this page and [[the-testbed]] updated to mention the third vault;
  `core/README.md` names the showcase.
- Both repositories exist under `didenkolab`, private, ready to be flipped.

### 2.6 Not in this work

- `docket import` is not shown: it needs a live Jira, and a fabricated snapshot would show the
  importer reading something the importer made.
- No CI in `northlight`. `receive-junit` is documented, not exercised.
- Flipping repositories to public. That is done by the owner, after reading the result.
