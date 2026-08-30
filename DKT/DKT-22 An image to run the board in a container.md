---
key: DKT-22
title: An image to run the board in a container
type: task
status: Dropped
status_category: done
priority: high
assignee: agent/claude
labels: [server, release]
created: 2026-08-30T19:31:34Z
updated: 2026-08-30T21:57:06Z
aliases: []
---

**Dropped.** This was on a list of gaps nobody asked for, and it did not survive being asked
what it was for.

docket is one static binary with no runtime. Putting it in a container adds a registry, a login,
a build on every push, and a README paragraph explaining why the pull fails — in exchange for
nothing the binary could not already do. Deploying it is: copy the binary, clone the vault,
run `docket serve`. That is the whole of it, and the README says so now.

The Dockerfile, compose.yaml and the Image workflow are removed. Git keeps them if a reason to
have them ever turns up — a container platform somebody is already committed to would be one.

## Acceptance

- [x] The Dockerfile, compose.yaml and the Image workflow are gone.
- [x] The README says how to run a server without any of them.

## Comments
