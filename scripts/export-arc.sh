#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage: $0 <proto-file>"
  echo ""
  echo "Exports a proto proposal to ARC-ready format in exports/"
  echo ""
  echo "Example:"
  echo "  $0 proto/token-gated-voting.md"
  exit 1
}

if [[ $# -ne 1 ]]; then
  usage
fi

SOURCE="$1"

if [[ ! -f "$SOURCE" ]]; then
  echo "Error: Source file '${SOURCE}' not found"
  exit 1
fi

if ! head -1 "$SOURCE" | grep -q '^---'; then
  echo "Error: Source file has no frontmatter"
  exit 1
fi

FILENAME=$(basename "$SOURCE")
TITLE=$(sed -n '/^---$/,/^---$/p' "$SOURCE" | grep '^title:' | sed 's/title:[[:space:]]*//' | tr -d '"')

if [[ -z "$TITLE" ]]; then
  echo "Error: No title found in frontmatter"
  exit 1
fi

mkdir -p exports

TODAY=$(date +%Y-%m-%d)
EXPORT_FILE="exports/${FILENAME}"

cp "$SOURCE" "$EXPORT_FILE"

if grep -q '^status:' "$EXPORT_FILE"; then
  sed -i.bak "s/^status:.*/status: submitted/" "$EXPORT_FILE"
fi

if grep -q '^exported:' "$EXPORT_FILE"; then
  sed -i.bak "s/^exported:.*/exported: ${TODAY}/" "$EXPORT_FILE"
else
  sed -i.bak "s/^status:.*/status: submitted\nexported: ${TODAY}/" "$EXPORT_FILE"
fi

rm -f "${EXPORT_FILE}.bak"

echo "Exported: ${SOURCE} → ${EXPORT_FILE}"
echo "Title: ${TITLE}"
echo "Date: ${TODAY}"
echo ""
echo "Next steps:"
echo "  1. Review ${EXPORT_FILE}"
echo "  2. Submit to the ARC repository"
