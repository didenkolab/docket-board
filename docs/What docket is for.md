---
title: What docket is for
type: page
status: normative
updated: 2026-08-30
---

# What docket is for

This is the document every other decision is checked against. When something in this project is
argued about, the answer is here or the answer is wrong.

Related: [[Vault format]], [[0001-vault-as-source-of-truth]], [[Roadmap]].

## The idea in one paragraph

Take Obsidian's pattern — a folder of Markdown notes that link to each other, and a graph that
shows the linking — and put task tracking on top of it, so that the result is a Jira and a
Confluence made of files. One repository is one project, the way a Space is one project in
Jira. One file is one thing: a task, a bug, an epic, a page. Everything that happens to any of
them is a commit, so git is the history and `git log` says who did it. And the same folder,
opened in Obsidian, shows the whole thing as a graph.

## The five things that make it what it is

### 1. A repository is a project

One git repository holds one project, the way a Space holds one project in Jira. Its issues,
its documentation, its board configuration and its history are in it and nowhere else, so a
project can be handed to a team by handing over a clone, and access to it is access to the
repository.

A board shows several projects at once by reading several repositories. It does not own them
and does not copy them.

### 2. One file is one thing

A task is a file. So is a bug, an epic and a wiki page. Not a row in a table that a file
happens to describe — the file *is* the thing, and there is no other copy of it anywhere.

The file is named after what it is: `ACME-12 Fix login redirect loop.md`. Obsidian labels a
graph node and a file explorer row with the file name and nothing else — not with a `title`
property, not with an alias — which is why the name carries the title. Verified in Obsidian
1.13.7, and the reason for [[0005-a-file-is-named-after-its-task]].

### 3. Relationships are links, not fields

This is the part that makes it Obsidian rather than a database that happens to store Markdown.

An epic and its tasks, a task and its label, a task and the page that explains it — all of
these are **wikilinks**, because a wikilink is what Obsidian resolves, draws in the graph,
counts in backlinks and offers in the quick switcher. A relationship written as a plain string
in the frontmatter is invisible to every one of those: it exists for our own tools and for
nothing else.

So a parent is `parent: "[[ACME-4 Session model]]"`, not `parent: ACME-4`. A label is a link to
a page that can then say what the label means, so labels are how a large number of documents
come to be connected. Tags are available too, for the kind of grouping tags are good at.

The test for any new field: open the vault in Obsidian and look at the graph. If the
relationship is not an edge there, it is not a relationship — it is a string.

### 4. Every change is a commit

Moving a task from `Backlog` to `In review` writes the file and commits it, with a message that
says what changed and an author who is the person or the agent that did it. Adding a comment is
a commit. Retitling is a commit, and a rename with it.

There is no activity log, no audit table and no event stream, because a second record of what
happened is a record that can disagree with the first. `git log` is the history, and the
interface reads it rather than keeping its own.

The consequence, and the point: a change made through the web interface, a change made by an
agent through MCP, and a change made by editing the file and running `git commit` are the same
kind of thing. Any of them can do anything, none of them is privileged, and the repository is
the only thing that has to be right.

### 5. It works with nothing installed

Clone the repository, open the folder in Obsidian, and it is a tracker: a board, a backlog, a
wiki, a graph. No server, no binary, no import. The tool makes the routine parts routine and
enforces the rules; it is never the thing that makes the data readable.

## What this rules out

- A database, a cache or an index that has to be rebuilt. Read the files.
- A field that only our own tools understand where a link would do.
- A change that is not a commit.
- A project that cannot be taken away as a clone.
- Anything that makes the vault unusable in Obsidian on its own.

## How to use this document

Before adding anything, answer:

1. Which of the five does it serve?
2. Does it show up in Obsidian's graph, or only in our own interface?
3. Is it a commit?
4. Does the vault still work if the tool is deleted?

An answer of "none", "only ours", "no" or "no" means the thing is wrong, however useful it
looks.
