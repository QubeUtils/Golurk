#!/usr/bin/env bash
set -euo pipefail

# golurk - One-line installer
# Usage: curl -fsSL https://raw.githubusercontent.com/QubeUtils/golurk/main/install.sh | bash

INSTALL_DIR="${INSTALL_DIR:-$HOME/.local/bin}"
REPO="QubeUtils/golurk"

echo "Fetching latest version of golurk from $REPO..."
VERSION="${1:-$(curl -s "https://api.github.com/repos/$REPO/releases/latest" | grep '"tag_name"' | cut -d'"' -f4)}"

if [[ -z "$VERSION" ]]; then
  echo "Error: Could not determine latest release. Make sure the repo has a release." >&2
  exit 1
fi

mkdir -p "$INSTALL_DIR"

echo "Downloading golurk $VERSION..."
curl -fsSL "https://github.com/$REPO/releases/download/$VERSION/golurk" \
  -o "$INSTALL_DIR/golurk"

chmod +x "$INSTALL_DIR/golurk"

# ── SHA256 checksum verification ─────────────────────────────────────
CHECKSUM_URL="https://github.com/$REPO/releases/download/$VERSION/golurk.sha256"
if curl -fsSL "$CHECKSUM_URL" -o "${TMPDIR:-/tmp}/golurk.sha256" 2>/dev/null; then
  EXPECTED_SHA="$(awk '{print $1}' "${TMPDIR:-/tmp}/golurk.sha256")"
  if command -v sha256sum &>/dev/null; then
    ACTUAL_SHA="$(sha256sum "$INSTALL_DIR/golurk" | awk '{print $1}')"
  elif command -v shasum &>/dev/null; then
    ACTUAL_SHA="$(shasum -a 256 "$INSTALL_DIR/golurk" | awk '{print $1}')"
  else
    echo "Warning: No sha256sum or shasum found — skipping checksum verification." >&2
    ACTUAL_SHA="$EXPECTED_SHA"
  fi
  if [[ "$ACTUAL_SHA" != "$EXPECTED_SHA" ]]; then
    echo "Error: Checksum mismatch! Expected $EXPECTED_SHA, got $ACTUAL_SHA" >&2
    echo "Removing potentially corrupted binary." >&2
    rm -f "$INSTALL_DIR/golurk"
    exit 1
  fi
  echo "✅ Checksum verified."
  rm -f "${TMPDIR:-/tmp}/golurk.sha256"
else
  echo "Warning: No checksum file found for $VERSION — skipping verification." >&2
fi

echo ""
echo "✅ golurk $VERSION installed successfully to $INSTALL_DIR/golurk"
echo "   Make sure $INSTALL_DIR is in your PATH."
echo "   Run 'golurk --help' to get started."
