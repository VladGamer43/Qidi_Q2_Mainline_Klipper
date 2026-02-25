#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

KLIPPER_DIR="${KLIPPER_DIR:-$HOME/klipper}"
KATAPULT_DIR="${KATAPULT_DIR:-$HOME/katapult}"

KLIPPER_PATCH="$SCRIPT_DIR/patches/klipper/0001-q2-mainboard-usb-and-cs1237.patch"
KATAPULT_PATCH="$SCRIPT_DIR/patches/katapult/0001-q2-mainboard-usb.patch"

KLIPPER_FALLBACK_COMMIT="187481e2514f30fbaa19241869f4485ab4289cea"
KATAPULT_FALLBACK_COMMIT="b0bf421069e2aab810db43d6e15f38817d981451"

die() {
  echo "ERROR: $*" >&2
  exit 1
}

require_git_repo() {
  local repo="$1"
  if [ ! -d "$repo/.git" ]; then
    die "Not a git repository: $repo"
  fi
}

require_clean_repo() {
  local repo="$1"
  if [ -n "$(git -C "$repo" status --porcelain)" ]; then
    die "Repository has local changes: $repo (clean it first, then rerun)"
  fi
}

echo "Using Klipper repo:  $KLIPPER_DIR"
echo "Using Katapult repo: $KATAPULT_DIR"

[ -f "$KLIPPER_PATCH" ] || die "Missing patch file: $KLIPPER_PATCH"
[ -f "$KATAPULT_PATCH" ] || die "Missing patch file: $KATAPULT_PATCH"

require_git_repo "$KLIPPER_DIR"
require_git_repo "$KATAPULT_DIR"
require_clean_repo "$KLIPPER_DIR"
require_clean_repo "$KATAPULT_DIR"

echo
echo "Checking Klipper patch applicability..."
if ! git -C "$KLIPPER_DIR" apply --check "$KLIPPER_PATCH"; then
  cat <<EOF
Klipper patch did not apply cleanly to $KLIPPER_DIR.
Try checking out the known-good fallback commit and rerun:

  cd "$KLIPPER_DIR" && git checkout $KLIPPER_FALLBACK_COMMIT
EOF
  exit 1
fi

echo "Checking Katapult patch applicability..."
if ! git -C "$KATAPULT_DIR" apply --check "$KATAPULT_PATCH"; then
  cat <<EOF
Katapult patch did not apply cleanly to $KATAPULT_DIR.
Try checking out the known-good fallback commit and rerun:

  cd "$KATAPULT_DIR" && git checkout $KATAPULT_FALLBACK_COMMIT
EOF
  exit 1
fi

echo
echo "Applying Klipper patch..."
git -C "$KLIPPER_DIR" apply "$KLIPPER_PATCH"

echo "Applying Katapult patch..."
git -C "$KATAPULT_DIR" apply "$KATAPULT_PATCH"

echo
echo "Patch apply complete."
echo "Next steps: build/flash Katapult and Klipper per docs/INSTALL.md."
