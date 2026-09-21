---
key: DKT-61
title: check --fix renames a retitled task and leaves every link to it pointing at nothing
type: bug
status: Done
status_category: done
priority: high
assignee:
labels: ["[[check]]"]
created: 2026-09-21T09:42:46Z
updated: 2026-09-21T09:42:46Z
aliases: []
tags: []
---

Retitling a task by hand and then running `docket check --fix` renames the file and leaves every
inbound wikilink naming the old title. `check` then reports the vault clean, because the rule
that validates a relation matches on the **key** inside the link rather than on the note name —
and the key did not change.

The result is a vault that is valid to the tool and broken in Obsidian, which is the one outcome
[[Vault format]] exists to prevent: Obsidian resolves the name of a note and does not consult
aliases, so a link naming the old title draws no edge, produces no backlink and resolves to
nothing.

Reproduced on a fresh vault at DKT-61's HEAD:

```bash
docket new "Fix login redirect loop" --type bug
docket new "Session model" --type task
docket set ACME-1 blocked_by=ACME-2        # writes ["[[ACME-2 Session model]]"]

sed -i '' 's/^title: Session model$/title: The session model, rewritten/' \
  "ACME/ACME-2 Session model.md"

docket check        # 1 finding: rule 1, the file name no longer carries the title
docket check --fix  # renames the file, rewrites nothing else
docket check        # No findings.

grep blocked_by "ACME/ACME-1 Fix login redirect loop.md"
# blocked_by: ["[[ACME-2 Session model]]"]   ← names a note that no longer exists
```

The server does this correctly: a retitle through the web interface rewrites every link to the
renamed note, bodies and frontmatter alike, in the same commit as the rename — so no point in
the history has the vault pointing at nothing. `check --fix` is the path that does not, and it is
the path an agent and a person editing in Obsidian both take.

Two things are wrong and they are separable. `check --fix` should rewrite inbound links when it
renames, the way the server does. And rule 5 should check the note name as well as the key, so
that a vault in this state is a finding rather than silence — otherwise the same break arrives
by any other route and nothing reports it.

Found while writing the agent skill, by checking a claim the skill was about to make.

## Acceptance

- [x] `docket check --fix`, when it renames a file whose name drifted from its title, rewrites
      every link naming the old note — in bodies and in frontmatter — in the same pass.
- [x] `docket check` reports a link whose key resolves but whose note name does not, with the
      file, the line and the name it should carry.
- [x] A test covers the reproduction above: retitle by hand, `--fix`, and assert both that the
      inbound link was rewritten and that a vault left in the old state is a finding.
- [x] `docket check --fix` on the vaults in `docket-board`, `docket-demo`, `docket-showcase` and
      `docket-testbed` still reports no findings afterwards.

## Comments

**vadym · 2026-09-21 10:55** — Fixed in 525bc24 and b0d5c9d. Three things, and the third was the
one worth finding.

`check` now reports a link naming a title its task no longer has, and says what to write instead.
`Relink` rewrites such a link, for parents and for every declared relation. And `--fix` renames
before it relinks rather than after: a link names a note, so the names have to be right before
the links are written — relinking first wrote names the tasks were about to stop having.

Then the third: `Apply` was calling `vault.Rename` while the server's own retitle path calls
`vault.Retitle`, which moves the file *and* repoints every link that named it, in bodies as well
as frontmatter. Two implementations of one operation, and `--fix` had the worse of them. It uses
`Retitle` now, so a reference in prose — one task explaining itself by naming another — survives
a retitle as well.

Verified on the four vaults: no findings, and `--fix` changes nothing in any of them.
