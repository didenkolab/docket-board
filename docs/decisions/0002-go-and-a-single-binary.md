---
title: Go, and a single binary
type: decision
status: accepted
date: 2026-08-30
updated: 2026-08-30
---

# ADR-0002 — Go, and a single binary

## Context

[[DKT/3]]. The `docket` repository holds a README and nothing else. Before any command is
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
HTTP server with a board UI, an MCP server, and its tests. [[DKT/8]] and [[DKT/9]] are planned
as ports of that code. Choosing another language turns them into rewrites and buys nothing in
return.

**The standard library covers what a vault tool does.** Files, YAML-adjacent parsing, HTTP,
subprocess calls to git. Go needs no framework to do any of it.

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

## How it is distributed

- **GitHub Releases** — cross-compiled binaries for macOS, Linux and Windows on amd64 and
  arm64. This is the path we point people at.
- **`go install github.com/vadymdidenkolab/docket/cmd/docket@latest`** — for people who already
  have Go and would rather not download anything.
- **A Homebrew tap** later, once there is a command worth tapping for.

The version is stamped at build time with `-ldflags -X main.version=...`, and falls back to
Go's embedded build info so that a `go install` build still reports something truthful rather
than `dev`.

Automating the release build is [[DKT/10]].

## Consequences

**No dependencies until one is earned.** The CLI ships with an empty `go.mod` require block.
The first dependency will be a YAML parser, when [[DKT/6]] needs to read frontmatter — added
then, not now.

**The tool never becomes a gate.** ADR-0001 says a vault is usable by writing files. That
still holds: everything the binary does can be done by hand, and a vault where nobody has the
binary installed is a working vault. This decision is about making the convenient path
available, not about making it mandatory.
