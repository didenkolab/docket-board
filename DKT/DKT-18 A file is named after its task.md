---
key: DKT-18
title: A file is named after its task
type: story
status: Done
status_category: done
priority: high
assignee: agent/claude
labels: ["[[format]]"]
created: 2026-08-30T18:36:47Z
updated: 2026-08-30T18:36:47Z
aliases: []
---

[[DKT-13 A vault holds several projects, and a key is a path]] named the cost of making the key
the path — the graph shows file names, so it would show bare numbers — and accepted it. The
first time the vault was actually opened in Obsidian, that cost turned out to be unlivable: a
graph of `1`, `2`, `7`, `12` says nothing about anything, and neither does the file explorer.

Reasoning, and the two repairs that were rejected: [[0005-a-file-is-named-after-its-task]].

## Acceptance

- [x] A task's file is named `KEY Title.md`, with the title as written.
- [x] The key is one spelling — `ACME-12` — in the frontmatter, the file name, links and URLs.
- [x] `docket check` reports a name that no longer matches its title.
- [x] This vault and the demo are migrated, with history kept.

## Comments

**agent/claude · 2026-08-30 18:36** — Done. The key goes back to `ACME-12`, because `ACME/12`
existed for exactly one reason — to be a path Obsidian resolves — and it stops being one. Two
spellings of the same thing in the same file would have been worse than the migration.

The title goes into the name as written. Only what a file name or a wikilink genuinely cannot
hold is replaced, and the list is in the code where a reader can check it: path separators, the
characters one file system or another refuses, and the four that are wikilink syntax. Every
alphabet, accent and piece of punctuation survives.

One thing was verified rather than assumed, and it decided the design: **Obsidian's resolver
does not consult `aliases`**. So `[[ACME-12]]` cannot be made to work by putting the key in
`aliases` — a link has to carry the note's whole name. `docket check` now resolves links exactly
the way Obsidian does, aliases and all excluded, because a validator more generous than the
thing it validates is worse than none; and when it sees a bare key it prints the name to write.

What was given up: only the key moved a file, and now a retitle does too. Obsidian rewrites
links on rename and so does the tool, so nothing breaks; reading a task's history now wants
`git log --follow`. The graph is looked at far more often than the diff of a retitle.

Also dropped `.obsidian/*` from the drift guard in [[DKT-11 Stop the embedded templates from drifting away from this vault]].
Obsidian rewrites its own configuration whenever a setting changes, so comparing it made the
guard fire for doing nothing wrong — and a guard that cries wolf is one people learn to ignore.
