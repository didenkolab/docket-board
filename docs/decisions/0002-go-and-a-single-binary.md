---
title: Go, and a single binary
type: decision
status: accepted
date: 2026-08-30
updated: 2026-08-31
---

# ADR-0002 — Go, and a single binary

## Context

[[DKT-3 Pick the language for the tool and set up its repository]]. The `docket` repository holds a README and nothing else. Before any command is
written, two things need settling: what the tool is written in, and how someone gets it.

Distribution is the harder half. `docket check` only protects the format if it actually runs —
in a pre-commit hook, in CI, on the machine of someone who cloned a vault an hour ago. Any
install step that starts with "first install a runtime" means it will not run, people will keep
editing by hand, and the validation rules in [[vault-format]] become decoration.

## Decision

**Go, distributed as a single static binary.**

Reasons, in the order they carry weight:

**Installation is one file.** A Go binary has no runtime to install and no dependency tree to
resolve. Downloading one file and putting it on `PATH` is the entire procedure, on every
platform we care about. Nothing else on the shortlist matches that.

**Stages 3 and 4 are ports, not rewrites.** An earlier private prototype already has, in Go, a
working Jira and Confluence extractor, an ADF-to-Markdown converter, an attachment store, an
HTTP server with a board UI, an MCP server, and its tests. [[DKT-8 Server and web UI]] and [[DKT-9 Import from Jira and Confluence]] are planned
as ports of that code. Choosing another language turns them into rewrites and buys nothing in
return.

**The standard library covers what a vault tool does.** Files, YAML-adjacent parsing, HTTP,
subprocess calls to git. Go needs no framework to do any of it.

### How it is distributed

- **GitHub Releases** — cross-compiled binaries for macOS, Linux and Windows on amd64 and
  arm64. This is the path we point people at.
- **`go install github.com/didenkolab/docket/cmd/docket@latest`** — for people who already
  have Go and would rather not download anything.
- **A Homebrew tap** later, once there is a command worth tapping for.

The version is stamped at build time with `-ldflags -X main.version=...`, and falls back to
Go's embedded build info so that a `go install` build still reports something truthful rather
than `dev`.

Automating the release build is [[DKT-10 Release automation — tagged binaries people can download]].

## What this costs

**Every release is six artefacts.** Three operating systems on two architectures means six
binaries built and published every time a version is cut, and no package manager is doing it for
us. That is work an install step through a package index never asks of anybody, and it is exactly
what buys the install step being one file.

**No dependency arrives for free.** The CLI ships with an empty `go.mod` require block, and the
first entry will be a YAML parser, when [[DKT-6 docket check — validate a vault]] needs to read
frontmatter — added then, not now. Keeping it that way means the claim above, that the standard
library covers what a vault tool does, has to keep being true, and where it stops being true the
code is written rather than imported.

**The tool never becomes a gate.** [[0001-vault-as-source-of-truth]] says a vault is usable by
writing files, and that still holds: everything the binary does can be done by hand, and a vault
where nobody has it installed is a working vault. So this decision can make the convenient path
available and can never make it mandatory. `docket check` protects the format only where somebody
chose to run it, which is why the distribution half of this decision mattered more than the
language half.

**Nothing is ever shared with an Obsidian plugin.** The one thing the language choice forfeits,
and it is forfeit only for as long as ADR-0001 holds. If this project ever does write a plugin,
the plugin is TypeScript and shares no code with the binary.

## Alternatives considered

**TypeScript.** The one real argument for it: Obsidian plugins are TypeScript, so a future
docket plugin could share code. That argument has no claim here, because we decided in
[[0001-vault-as-source-of-truth]] not to write our own plugin — Bases is core and renders the
boards already. What TypeScript costs is exactly what we are trying to avoid: Node on every
machine that wants to run a validator in a git hook.

**Rust.** The same single-binary story as Go, and a nicer CLI ecosystem. But there is nothing
to port, and it is slower to write. Distribution parity plus a rewrite is not a trade.

**Python.** Fastest to write, worst to hand to someone. A validator that requires a virtualenv
is a validator that runs on one machine.
