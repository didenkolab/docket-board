---
key: DKT-57
title: The Run-the-scenarios button cannot land a result on a test
type: bug
status: Backlog
status_category: todo
priority: normal
assignee: vadym
labels: ["[[apps]]"]
created: 2026-09-07T19:56:39Z
updated: 2026-09-07T19:56:39Z
aliases: []
tags: [area/tests]
---

`hooks/run-tests.sh` (the tests app's "Run the scenarios" button) collects every gherkin block in the vault into one feature file, hands it to the repository's `./run-tests <feature> <junit-out>`, and imports whatever is at `<junit-out>`. Three things in that chain do not meet:

1. The example `run-tests` the hook itself prints — `behave "$1" --junit --junit-directory "$(dirname "$2")"` — writes `TESTS-<feature>.xml` into the directory, never to `$2`, so `[ -s "$results" ]` is false and the hook says it wrote no JUnit.
2. Even with the file in place, `import-junit.sh` matches `classname.name` against `automation_id`, and a runner's JUnit carries the feature name and the scenario title, not the tag. Nothing in JUnit can name the test.
3. The collected feature tags each scenario `@<automation_id>`, but a derived id (`ACME-GEN-1A2B3C`) does not match `caseid.WRITTEN`, and the collected file's name is not the scenario's original file, so the JSON route would derive a different id too.

Found while building the showcase, which imports results through behave's JSON and `import-cucumber.sh` instead and never presses the button. The fix is a decision: make the button's contract `./run-tests <feature> <json-out>` and match on the tag the collector wrote (tag by task key, and let `import-cucumber` accept a key as an identity), or drop the button and document the two working routes — a commit from CI, or the `/in/junit` inbox.

## Acceptance

- [ ] A vault with two imported tests and a `run-tests` written from the hook's own example gets two runs from one press.
- [ ] The hook's usage text and `apps/tests/docs/testing.md` say which contract the runner must meet.

## Comments
