#!/usr/bin/env bash
#
# install-slidepack-package.sh
#
# Installs the local "slidepack" Typst package (lib.typ + typst.toml) into
# Typst's local package directory, so it can be imported anywhere via:
#
#   #import "@local/slidepack:0.1.0": slidepack
#
# Works on Linux and macOS. Run this script from the directory that
# contains lib.typ and typst.toml, or pass that directory as an argument:
#
#   ./install-slidepack-package.sh
#   ./install-slidepack-package.sh /path/to/package/source
#
set -euo pipefail

# --- Locate source files -----------------------------------------------
SRC_DIR="${1:-$(pwd)}"
MANIFEST="$SRC_DIR/typst.toml"
ENTRYPOINT="$SRC_DIR/lib.typ"

if [[ ! -f "$MANIFEST" ]]; then
  echo "Error: typst.toml not found in $SRC_DIR" >&2
  exit 1
fi
if [[ ! -f "$ENTRYPOINT" ]]; then
  echo "Error: lib.typ not found in $SRC_DIR" >&2
  exit 1
fi

# --- Parse name/version from typst.toml ---------------------------------
# Extracts: name = "slidepack"  ->  slidepack
#           version = "0.1.0"  ->  0.1.0
PKG_NAME=$(grep -E '^\s*name\s*=' "$MANIFEST" | head -1 | sed -E 's/^[^"]*"([^"]*)".*/\1/')
PKG_VERSION=$(grep -E '^\s*version\s*=' "$MANIFEST" | head -1 | sed -E 's/^[^"]*"([^"]*)".*/\1/')

if [[ -z "$PKG_NAME" || -z "$PKG_VERSION" ]]; then
  echo "Error: could not parse 'name' or 'version' from $MANIFEST" >&2
  exit 1
fi

# --- Determine OS-specific Typst data directory --------------------------
OS_NAME="$(uname -s)"
case "$OS_NAME" in
  Darwin)
    DATA_DIR="$HOME/Library/Application Support"
    ;;
  Linux)
    DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}"
    ;;
  *)
    echo "Error: unsupported OS '$OS_NAME'. Use install-slidepack-package.ps1 on Windows." >&2
    exit 1
    ;;
esac

PACKAGE_DIR="$DATA_DIR/typst/packages/local/$PKG_NAME/$PKG_VERSION"

# --- Install --------------------------------------------------------------
echo "Detected OS:      $OS_NAME"
echo "Package name:     $PKG_NAME"
echo "Package version:  $PKG_VERSION"
echo "Installing to:    $PACKAGE_DIR"

mkdir -p "$PACKAGE_DIR"
cp "$MANIFEST" "$PACKAGE_DIR/"
cp "$ENTRYPOINT" "$PACKAGE_DIR/"

echo ""
echo "Done. In any Typst document you can now use:"
echo "  #import \"@local/$PKG_NAME:$PKG_VERSION\": $PKG_NAME"
