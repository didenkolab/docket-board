---
key: DKT-46
title: A page is named after its title, like a task is
type: task
status: Backlog
status_category: todo
priority: normal
assignee: 
labels: ["[[docs]]", "[[format]]"]
created: 2026-08-31T19:00:00Z
updated: 2026-08-31T19:00:00Z
aliases: []
---

[[documents]] §10 says a page is named after its title, exactly, for the reason
[[0005-a-file-is-named-after-its-task]] gives about tasks: Obsidian labels a graph node, a file
explorer row and a quick switcher result with the file name and nothing else. Nine pages under
`docs/` in this vault do not obey it. They carry the lower-case hyphenated spelling of their
titles — `git-as-the-database.md` for "Git as the database" — and one is not a spelling of its
title at all, `2026-08-30-docket-design.md` being titled "docket design".

Two documents are outside this and stay as they are. `docs/index.md` is the exception §10 names:
a front page is found by position, because everything that makes or renders a vault has to reach
it without first knowing the project's name. The specs are the different rule in §6 — a spec's
path is quoted from the Go source, from both READMEs and from published URLs, which makes it an
identifier rather than a graph label, and an identifier that changes is not one.

They are not renamed in the commit that wrote the rule because it is a migration rather than an
edit. About ninety wikilinks point at those names across the tasks and the pages; the README of
this repository links some of them by published GitHub URL. A rename that misses any of those
turns a working reference into a dead one silently, which is the failure the rule exists to
prevent.

The rule stands in the meantime, and this task is where the exception is recorded rather than
being a quiet one — [[documents]] §13.

## Acceptance

- [ ] Every page under `docs/` has a file name equal to its `title`, except the two §10 names:
      a decision keeps `NNNN-kebab-title.md`, and `docs/index.md` keeps its path.
- [ ] Every wikilink pointing at a renamed page is rewritten in the same commit, in bodies and in
      frontmatter alike.
- [ ] The published URLs in this repository's README and in the template's `AGENTS.md` and
      `README.md` resolve, and the path comments in the `docket` source name files that exist.
- [ ] `docket check` reports no broken link, and `docket graph` reports no note that was reachable
      before and is an island afterwards.
- [ ] The exception paragraph in [[documents]] §10 is deleted, and §13 stops naming this task.

## Comments
