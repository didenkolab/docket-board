---
key: DKT-27
title: Tags, and everything else Obsidian gives
type: story
status: Done
status_category: done
priority: high
assignee: agent/claude
labels: ["[[obsidian]]", "[[format]]"]
created: 2026-08-30T23:33:03Z
updated: 2026-08-30T23:33:22Z
aliases: []
tags: []
---

`tags` was a field that parsed and did nothing, which is [[purpose]] §3 not being met by half.
Studying Obsidian's documentation properly — see [[what-obsidian-gives]] — turned up four things
worth taking and two the documentation is wrong about.

**Tags**, used rather than tolerated. A label says what a task is about and can be a page; a tag
says which slice of the work it is in, and nests. `area/auth` is inside `area`, so narrowing by
`area` finds it — the same answer Obsidian's tag pane and `tag:` search give. Checked in the
app: its pane shows area (3), auth (2), import (1), needs-review (2), which is what this search
returns. Case-insensitive too, because in Obsidian `#Auth` and `#auth` are one tag.

**Callouts.** `> [!warning]` was a blockquote here with the syntax leaking into the text, and a
coloured box there. The same file said two different things depending on which client opened it.

**Backlinks.** Obsidian shows everything that points at a note. For a tracker that is the
question Jira needs issue links for, and here it falls out of the format.

**Excerpts** that begin on a word rather than mid-syllable.

## Acceptance

- [x] Tags go through create, the form, the API, MCP, the card, the page, search and the boards.
- [x] A tag narrows to its whole subtree, and case does not split one in two.
- [x] Callouts render as Obsidian renders them, including aliases and folding.
- [x] A task shows what links to it, and an unlinked mention does not count.

## Comments
