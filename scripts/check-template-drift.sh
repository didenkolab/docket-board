#!/usr/bin/env bash
#
# Compare this vault's shared files against what `docket init` generates.
#
# The templates baked into the docket binary and this vault hold copies of the
# same files. They will drift: the first time a board gains a column here and
# the template does not, every vault created afterwards is subtly wrong and
# nothing says so. This is what says so.
#
# The template is the source of truth. When this script reports a difference,
# the fix is normally to copy the generated file over this one — unless the
# change belongs in the template, in which case make it there and rerun.
#
# Usage:
#   scripts/check-template-drift.sh /path/to/docket   # a checkout of the tool
#
# The vault itself needs none of this. It is a plain folder of Markdown and
# works with no binary installed; this only guards the copies.

set -euo pipefail

TOOL=${1:-}
if [ -z "$TOOL" ] || [ ! -f "$TOOL/go.mod" ]; then
	echo "usage: $0 /path/to/docket (a checkout of the tool repository)" >&2
	exit 2
fi

VAULT=$(cd "$(dirname "$0")/.." && pwd)
# The first project key, and the vault name — the two values `docket init`
# stamps into the files being compared.
KEY=$(sed -n 's/^ *- *{* *key: *\([A-Z0-9]*\).*/\1/p' "$VAULT/docket.yaml" | head -1)
NAME=$(sed -n 's/^name: *//p' "$VAULT/docket.yaml" | head -1)

# Files that must be identical in both places. AGENTS.md is deliberately not
# here: inside this vault it links to the specification by path, and the
# template cannot, because a generated vault has no copy of the specification.
SHARED=(
	docket.yaml
	.gitignore
	.obsidian/app.json
	.obsidian/core-plugins.json
	boards/board.base
	boards/backlog.base
	boards/my-tasks.base
	templates/task.md
	templates/page.md
)

GENERATED=$(mktemp -d)
trap 'rm -rf "$GENERATED"' EXIT

BINARY="$GENERATED/docket"
(cd "$TOOL" && go build -o "$BINARY" ./cmd/docket)
"$BINARY" init --key "$KEY" --name "$NAME" "$GENERATED/vault" >/dev/null

drifted=0
for file in "${SHARED[@]}"; do
	mine="$VAULT/$file"
	theirs="$GENERATED/vault/$file"

	if [ ! -f "$mine" ]; then
		echo "MISSING HERE     $file — the template has it, this vault does not"
		drifted=1
		continue
	fi
	if [ ! -f "$theirs" ]; then
		echo "MISSING UPSTREAM $file — this vault has it, the template does not"
		drifted=1
		continue
	fi
	if ! diff -u "$theirs" "$mine" >/dev/null; then
		echo "DRIFTED          $file"
		echo "  here:     $mine"
		echo "  template: $TOOL/internal/vault/template/$file"
		diff -u --label "template" "$theirs" --label "this vault" "$mine" | sed 's/^/  /'
		drifted=1
	fi
done

if [ "$drifted" -ne 0 ]; then
	echo
	echo "The vault and the templates have drifted. See the paths above." >&2
	exit 1
fi

echo "The vault and the templates agree on all ${#SHARED[@]} shared files."
