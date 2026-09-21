---
title: What Obsidian gives, and what we take
type: design
updated: 2026-08-31
---

# What Obsidian gives, and what we take

[[What docket is for]] says this is Obsidian's pattern with task tracking on top. That is only true to the
extent we actually use what Obsidian offers, so this is the list — read out of its published
documentation and checked in the app, not remembered.

Each row says what it is, whether docket uses it, and if not, why not.

## Taken

| What | How docket uses it |
|---|---|
| **Wikilinks** | Every relationship. `parent`, `labels`, and any link written in a body. §3.3 of [[Vault format]]. |
| **Graph** | The reason a file is named after its task, and the reason relationships are links. Checked in the app: label and tag nodes join tasks across projects. |
| **Backlinks** | The task page's "Referenced by". Obsidian's linked mentions, which answer "what else refers to this" without any relationship having been declared. |
| **Tags** | A second axis beside labels, nested with `/`. The tag pane, the hierarchy and the case-insensitivity all match. |
| **Properties** | The frontmatter. Flat, because the property editor cannot show nested values and Bases cannot filter on them. |
| **Bases** | The boards. `.base` files, cards and table views, `groupBy`, `order`, `properties.displayName`. |
| **Callouts** | Rendered here as Obsidian renders them, including the aliases and folding. |
| **Aliases** | Keys carried in from another system, so an old key still finds the task in the quick switcher. They do **not** resolve wikilinks — see [[0005-a-file-is-named-after-its-task]]. |
| **Embeds** | `![[attachments/…]]` for anything attached to a task. |
| **Templates** | `templates/task.md` and `templates/page.md`, which `docket new` fills in. |

## Not taken, and the reason

| What | Why not |
|---|---|
| **Canvas** | A `.canvas` is JSON, not Markdown, and a card in one is not a file. It could hold a story map or a dependency sketch, and that is worth revisiting — but it is a drawing beside the tracker rather than part of it. |
| **Block references** (`^id`) | Would let a comment cite one acceptance criterion exactly. Obsidian's own documentation says they do not work outside Obsidian, so a link that resolves in one client and not the other is the thing this project avoids. Worth revisiting if the web view learns to resolve them. |
| **Daily notes** | A standup log or a decision journal is a real use, and it is a convention rather than a feature: a page under `docs/` named by date does the same and needs nothing. |
| **Search operators** | Obsidian's search language is far richer than the filters here — `line:`, `block:`, `section:`, `task-todo:`, property brackets, regex. Worth taking as a syntax for the search box rather than as more dropdowns. **Unbuilt.** |
| **Bookmarks, Workspaces** | Per-person interface state. They live in `.obsidian/` and are gitignored on purpose. |
| **Canvas-style graph groups** | Colouring the graph by query is configuration in `.obsidian/graph.json`, which is per machine. A vault could ship one; nobody has asked. |
| **Publish, Sync** | Paid Obsidian services. `git push` is the same thing. |
| **Obsidian CLI, Headless** | Obsidian's own automation. docket writes files; it does not need to drive Obsidian. |

## What the documentation gets wrong

Two things were found by opening the app rather than trusting the page, and both are recorded
where they bite:

- `groupBy` in a `.base` needs `direction` as well as `property`, and the error names neither.
- A `displayName` under `properties:` must use the qualified name — `note.title`, not `title`.
  The published example uses the short form, which is accepted and silently ignored.

Both are in [[Vault format]] §6. The lesson is in [[What docket is for]]: check it in the graph.

## Limits worth remembering

- A tag may not contain a space, may not be all digits, and is case-insensitive.
- A property name has one type across the whole vault.
- Frontmatter links must be quoted; `[[a]]` unquoted is a nested list.
- Markdown is not rendered inside a property.
- Obsidian's metadata cache can fall out of step with the files. There is no cache here.
