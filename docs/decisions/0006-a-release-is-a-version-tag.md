---
title: A release is a version tag
type: decision
status: accepted
date: 2026-09-21
updated: 2026-09-21
---

# A release is a version tag

## Context

A release here is a git tag and nothing else — no version object, no `fixVersion`, no notes to
generate. The Releases page reads the tags out of the repository each time it is opened and works
out what went into each one from the task files that changed since the tag before it. That is the
whole feature, and it is the strongest argument the product has.

It listed every tag. A repository carries tags that are not releases: a build marker, `latest`,
`nightly`, a bookmark somebody left on a commit they wanted to find again.

The showcase made it plain. Its release page opened with `scaffold` — the tag its generator
replays the story onto — dated, ranked above five real releases, captioned *No task changed in
this release*. The first thing a reader saw on the page meant to prove the idea was a build
marker claiming to have shipped nothing.

It was found by taking a screenshot. No test could have failed on it: every tag was listed, which
is exactly what the code was written to do.

## Decision

**A tag names a release when it names a version.** `v1.2.3`, `1.2`, `v2`, `v1.2.3-rc1`,
`v1.0.0+build7`, `2026.9` — a leading `v` optional, dot-separated numbers, an optional
pre-release or build suffix. Anything else is a tag, and a tag is a bookmark.

`gitvcs.isVersion` is the line, and it is one regular expression with a test that names both
sides of it.

## What this costs

**A team that tags releases some other way sees an empty page.** `release-2026-09` and
`ship/august` are real conventions and they now produce nothing, with no message explaining why.
That is a worse failure than a stray row: a missing page reads as a broken feature, while a stray
row reads as a stray tag.

We accept it for now because every convention we have actually seen is version-shaped, and
because the alternative costs a configuration surface we would rather not open until somebody
needs it. If somebody does, the vault should say so — see below.

**It is a silent behaviour change.** A vault whose releases were listed yesterday may list none
today, and the only notice is the changelog.

## Alternatives considered

**List every tag, as before.** Honest — a tag is a tag — and it costs the showcase its front
page, which is the page the product is argued from. Rejected for that, not for correctness.

**Let the vault say which tags are releases**, a glob in `docket.yaml` defaulting to everything.
The most flexible and the most honest about the disagreement. Rejected for now: it adds a
configuration key, a validation rule, a settings field and a paragraph of documentation to solve
a problem nobody has reported, and the default would reproduce today's bug for everyone who never
sets it. This is the answer if a real vault turns up that needs it, and the regular expression
above becomes the default rather than the rule.

**Hide tags with no tasks in them.** Treats the symptom: `scaffold` was empty, so it would have
gone. But a genuine release can be empty — a tag cut on a documentation-only commit — and it
should still be listed. Rejected as a coincidence rather than a rule.
