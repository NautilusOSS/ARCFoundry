#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage: $0 <source-file> <target-stage>"
  echo ""
  echo "Stages: draft, proto, submitted, archived"
  echo ""
  echo "Examples:"
  echo "  $0 drafts/my-idea.md proto"
  echo "  $0 proto/my-idea.md submitted"
  exit 1
}

if [[ $# -ne 2 ]]; then
  usage
fi

SOURCE="$1"
TARGET_STAGE="$2"

VALID_STAGES=("draft" "proto" "submitted" "archived")
if [[ ! " ${VALID_STAGES[*]} " =~ " ${TARGET_STAGE} " ]]; then
  echo "Error: Invalid target stage '${TARGET_STAGE}'"
  echo "Valid stages: ${VALID_STAGES[*]}"
  exit 1
fi

if [[ ! -f "$SOURCE" ]]; then
  echo "Error: Source file '${SOURCE}' not found"
  exit 1
fi

FILENAME=$(basename "$SOURCE")

case "$TARGET_STAGE" in
  draft)     TARGET_DIR="drafts" ;;
  proto)     TARGET_DIR="proto" ;;
  submitted) TARGET_DIR="submitted" ;;
  archived)  TARGET_DIR="archived" ;;
esac

DEST="${TARGET_DIR}/${FILENAME}"

if [[ -f "$DEST" ]]; then
  echo "Error: '${DEST}' already exists"
  exit 1
fi

TODAY=$(date +%Y-%m-%d)

cp "$SOURCE" "$DEST"

if head -1 "$DEST" | grep -q '^---'; then
  sed -i.bak "s/^status:.*/status: ${TARGET_STAGE}/" "$DEST"

  if grep -q '^updated:' "$DEST"; then
    sed -i.bak "s/^updated:.*/updated: ${TODAY}/" "$DEST"
  else
    sed -i.bak "s/^status:.*/status: ${TARGET_STAGE}\nupdated: ${TODAY}/" "$DEST"
  fi

  rm -f "${DEST}.bak"
fi

echo "Promoted: ${SOURCE} → ${DEST}"
echo "Status set to: ${TARGET_STAGE}"
echo ""
echo "Next steps:"
echo "  1. Review and edit ${DEST}"
echo "  2. git add ${DEST} && git commit"
