---
title: A file is named after its task
type: decision
status: accepted
date: 2026-08-30
updated: 2026-08-30
---

# ADR-0005 — A file is named after its task

Supersedes the identity half of [[0003-a-vault-holds-several-projects]]. Projects stay folders;
the key stops being the path.

## Context

[[0003-a-vault-holds-several-projects]] made the key `ACME/12` and the file `ACME/12.md`,
because Obsidian reads a wikilink containing a slash as a vault-relative path, so `[[ACME/12]]`
resolved with no help from us. The cost was named and accepted in that decision: the graph view
shows a note's file name, so it would show bare numbers.

Opening the vault settled it in about ten seconds. A graph of `1`, `2`, `7`, `12` is not a
graph of anything — you cannot tell what a task is, or which project it belongs to. The file
explorer is no better. The cost was accepted on paper by someone who had not looked at it.

The obvious repair — keep `12.md` and let a plugin display the `title` property instead — was
rejected: [[0001-vault-as-source-of-truth]] says a cloned vault works with nothing installed,
and the two plugins that do this are exactly something installed.

## Decision

**A task's file is named after the task**: `ACME/ACME-12 Fix login redirect loop.md`.

**The key is `ACME-12`** — one spelling, in the frontmatter, in the file name, in links and in
the server's URLs. `ACME/12` existed only to be a path; it stops being one, so it goes.

**Projects remain folders.** They organise the vault, scope the boards' filters and keep
numbering per project. They are no longer part of the key.

**Links carry the whole name**: `[[ACME-12 Fix login redirect loop]]`. That is what Obsidian
resolves — a link without a slash matches a file's name anywhere in the vault, and names are
unique because keys are.

## What this costs

**Retitling moves the file.** The old decision's proudest property — that only the key moves a
file — is gone. Obsidian rewrites every link when it renames a note, and `docket` does the same,
so nothing breaks; but a title change is now a rename in `git log` rather than a one-line diff.
That is the price of a readable graph, and the graph is used far more often than the diff of a
retitle.

**A link has to name the title.** `[[ACME-12]]` alone resolves to nothing, because Obsidian's
resolver does not consult aliases — verified before deciding, not assumed. `docket check`
reports a bare key as a broken link and prints the full form to use, and `docket link ACME-12`
writes it out.

**Finding a file by key is a glob, not a path.** `ACME/ACME-12 *.md` rather than a direct open.
Cheap, and confined to the tool.

## Alternatives considered

**Keep `ACME/12.md` and require a title-display plugin.** Cheapest change, and it breaks the
promise that a cloned vault needs nothing installed. That promise is the reason the format
exists.

**Keep the key `ACME/12` while naming the file `ACME/ACME-12 …`.** Two spellings of one thing,
in the same file. Whatever is saved by not migrating is spent forever afterwards on explaining
which is which.

**Put the title in the file name and no key at all.** Then a retitle loses the only stable
handle a task has, and seven years of `ACME-12` in commit messages point at nothing.
