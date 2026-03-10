#!/usr/bin/env bash
set -euo pipefail

ERRORS=0

validate_frontmatter() {
  local file="$1"
  local stage="$2"

  if ! head -1 "$file" | grep -q '^---'; then
    echo "  FAIL: Missing frontmatter opening '---'"
    ERRORS=$((ERRORS + 1))
    return
  fi

  FRONTMATTER=$(sed -n '/^---$/,/^---$/p' "$file")

  if [[ -z "$FRONTMATTER" ]]; then
    echo "  FAIL: Malformed frontmatter (missing closing '---')"
    ERRORS=$((ERRORS + 1))
    return
  fi

  for field in title author status; do
    if ! echo "$FRONTMATTER" | grep -q "^${field}:"; then
      echo "  FAIL: Missing required field '${field}'"
      ERRORS=$((ERRORS + 1))
    fi
  done

  FILE_STATUS=$(echo "$FRONTMATTER" | grep '^status:' | sed 's/status:[[:space:]]*//')
  if [[ -n "$FILE_STATUS" && "$FILE_STATUS" != "$stage" ]]; then
    echo "  WARN: Status '${FILE_STATUS}' does not match directory stage '${stage}'"
  fi
}

check_stage() {
  local dir="$1"
  local stage="$2"

  if [[ ! -d "$dir" ]]; then
    return
  fi

  local files
  files=$(find "$dir" -name '*.md' -not -name '.gitkeep' 2>/dev/null || true)

  if [[ -z "$files" ]]; then
    return
  fi

  echo "Validating ${stage} proposals in ${dir}/..."

  while IFS= read -r file; do
    echo "  Checking: $(basename "$file")"
    validate_frontmatter "$file" "$stage"
  done <<< "$files"

  echo ""
}

echo "=== ARCFoundry Validation ==="
echo ""

check_stage "drafts" "draft"
check_stage "proto" "proto"
check_stage "submitted" "submitted"

if [[ $ERRORS -gt 0 ]]; then
  echo "Validation complete: ${ERRORS} error(s) found"
  exit 1
else
  echo "Validation complete: all checks passed"
  exit 0
fi
