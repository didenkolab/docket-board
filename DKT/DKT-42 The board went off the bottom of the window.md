---
key: DKT-42
title: The board went off the bottom of the window
type: bug
status: Done
status_category: done
priority: high
assignee: agent/claude
labels: ["[[server]]"]
created: 2026-08-31T14:00:00Z
updated: 2026-08-31T14:20:00Z
aliases: []
relates: ["[[DKT-41 One control, and filters that look like filters]]"]
---

The columns grew as tall as their contents, so a full column ran off the bottom of the window
and the whole page scrolled. On a board that is wrong twice over: the other columns and every
heading scroll away with it, so you lose the thing you were comparing against — and the heading
that had been made sticky was sticking to the *page* rather than to its column, which is why it
looked fixed and was not.

It kept coming back because it kept being patched. The layout is now flex all the way down from
the body rather than a computed height, so there is no number to get wrong when the header
changes. The part that is easy to miss, and the reason no patch held:

> **`min-height: 0` on every link in the chain.** A flex item will not shrink below its content
> without it, so the innermost overflow never happens and everything looks exactly as it did
> before.

Six of them. Miss one and the symptom returns while the cause stays invisible.

The heading is no longer sticky: it sits outside what scrolls, so it stays without being told
to. On a phone one screen is the wrong shape — columns narrow enough to fit several across are
too narrow to read — so a narrow board goes back to being a page that scrolls.

Measuring that turned up a second overflow: seven navigation links were four pixels wider than
a 390-pixel phone, and the page scrolled sideways. The bar wrapped; the navigation inside it did
not. Same trap, same fix.

## Acceptance

- [x] The board is one screen and each column scrolls on its own.
- [x] The column heading stays without being sticky.
- [x] A task page still scrolls normally.
- [x] Nothing sticks out sideways at 1280, 1440 or 390 pixels wide.

## Comments

**agent/claude · 2026-08-31 14:20** — Recorded by editing files and committing, with no board
and no API, to see whether that path really works. It does: `docket check` was clean on the
first run, the server picked up all ten tasks without a restart, and it noticed the ten commits
it had not made itself — the header said "10 commit(s) written here and not yet sent" and one
button published them.

One defect fell out of it. The unsent panel was painted over by the board's column headings,
because a column heading is a `<header>` element and the page header's rules were written as a
bare `header` selector — so every column heading was `position: sticky` with `z-index: 20`
without anybody deciding that. It is also why they appeared to stay put while the page scrolled.
An element selector for a page region leaks into every component that uses the same element
correctly.
