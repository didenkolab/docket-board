---
key: DKT-41
title: One control, and filters that look like filters
type: story
status: Done
status_category: done
priority: high
assignee: agent/claude
labels: ["[[server]]"]
created: 2026-08-31T14:00:00Z
updated: 2026-08-31T16:45:00Z
aliases: []
---

The controls were four different boxes. A dropdown is a different height from a field in every
browser and carried the operating system's own arrow next to our own borders, so a form of them
looked assembled rather than designed. One `--control` height now, one border, one radius, one
focus ring, and a dropdown is our box with our own chevron — `appearance: none` is what makes
the height honest, and the menu stays the browser's because on a phone it is the system picker
and with a keyboard it already does everything a hand-built one would have to be taught.

The filter bar was seven native dropdowns side by side, every one saying "Any". That reads as a
form to fill in, and a filter that is not set should not be taking up a control. Each dimension
is a menu that says what it is narrowed to, marked when it is doing something, with **Clear
filters** appearing only when there is something to clear.

The options are links rather than a form, which is the whole trick: a link carries the entire
state of the bar, so there are no hidden inputs shadowing each other and no script. The browser
opens the `<details>`, gives it keyboard focus and closes it on Escape.

The board lost a row per card. Tags are off the card — a tag is a set somebody asks for, not a
fact about the thing — and four dimensions of metadata in a two-hundred-pixel column wrap to
four lines, which is the one thing a board must not do. The epic moved down with the rest of
the small print, because three things on the key's line truncated it to a letter and a full
stop on any blocked card. Not a link, however much one would help: the whole card is an anchor,
and an anchor inside an anchor is not markup a browser keeps.

Pages are a tree, because `docs/` is a tree. Shown by the title a page gives itself and sorted
by its file name — numbering a file is a statement about order, and a title is not.

And the colours no longer only follow the system: three states, so following it stays reachable,
kept in a cookie the server reads and stamped on the `html` element, because a script that
swapped them after paint would flash the wrong theme on every load.

## Acceptance

- [x] A field, a dropdown, a button and a text area are the same box.
- [x] Filters read as filters, and work without a script.
- [x] The board is denser by a row per card, and nothing truncates to nonsense.
- [x] Pages are a tree, by title, in file-name order.
- [x] Light, dark, or whatever the system says — arriving with the page.
- [x] The task page: an order in the side column, and criteria that read as criteria.
- [x] Releases, branches and settings have had the pass too.

## Comments

**agent/claude · 2026-08-31 14:35** — The task page is done. Three things, each a case of
weight not matching importance: a side column where the task's properties, a file upload and a
delete button had the same weight; an action row of five controls when one of them changes
anything; and an acceptance list that arrived with two markers, because GFM renders a Markdown
task list as a disabled native checkbox inside an ordinary list item.

**agent/claude · 2026-08-31 16:45** — The last three pages, and each had the same kind of fault:
it showed what it had rather than what was being asked of it.

Releases listed every task of every release, flat — the testbed's three tags came to two and a
half thousand pixels, and "how much shipped, and how much of it was actually finished at the
tag" could only be answered by counting chips. Each release now states itself in a line and
only the newest is spelled out. The page also says out loud what it never did: the status shown
is the status as it stood at the tag, which is the whole difference between this and a report.

Branches set the commit subject larger than the branch name, so it read as a list of commits
that happened to have branches attached. And the checked-out branch was in the list of
proposals, which it is not one of: it is the plan they are arguments about.

Settings is one form four screens long. The save control follows you down it now — sticky, in
the flow of the form, no script.
