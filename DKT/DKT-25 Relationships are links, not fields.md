---
key: DKT-25
title: Relationships are links, not fields
type: story
status: Done
status_category: done
priority: urgent
assignee: agent/claude
labels: ["[[format]]", "[[obsidian]]"]
created: 2026-08-30T22:18:11Z
updated: 2026-08-30T22:32:39Z
aliases: []
---

[[purpose]] §3 says a relationship is a wikilink or it is not a relationship. Two of ours are
strings, and both are invisible in Obsidian — which was checked, not assumed.

`parent: ACME-4` is a plain key. The epic-to-task hierarchy, which is the whole reason an epic
exists, draws no edge in the graph. `labels: [auth, regression]` are plain strings and draw
nothing either. Opened in Obsidian 1.13.7 with a probe vault, a task whose labels were
written as links had an edge to a real page and a task whose labels were written as plain words
had none — same word, same field, one connected and one inert.

So both become links:

```yaml
parent: "[[ACME-4 Session model]]"
labels: ["[[auth]]", "[[regression]]"]
```

A label being a link means a label can be a page — `docs/labels/auth.md` — that says what it
means and gathers everything carrying it. That is how a large number of documents come to be
connected, and it is the thing Obsidian is good at that we were not using.

`tags:` is worth offering as well, for the grouping tags are good at, and it costs nothing
because Obsidian already understands it.

The cost: every place that reads `parent` or `labels` has to resolve a link to a key, the
importer has to write links, `check` has to validate them, and existing vaults need migrating —
`docket check --fix` is where that belongs.

## Acceptance

- [ ] `parent` and `labels` are wikilinks in the frontmatter.
- [ ] The graph shows an epic connected to its tasks, and a label connected to what carries it.
- [ ] A label can be a page, and is not required to be one.
- [ ] `tags` is supported and documented.
- [ ] `docket check` reports the old form, and `--fix` migrates it.

## Comments

**Claude · 2026-08-30 22:32** — Done. The demo's graph now shows `auth` joining three tasks, `tooling` joining two across different projects, and ACME-2 with an edge to its parent — none of which existed when the same words were plain strings. Retitling had to be fixed first: it moved the file and left every inbound link pointing at nothing, which would have broken every child the moment a parent became a link.
