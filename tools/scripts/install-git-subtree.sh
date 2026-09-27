#!/usr/bin/env bash
# Make `git subtree` available when git is built from source without contrib/subtree.
set -euo pipefail

if git subtree --help >/dev/null 2>&1; then
    exit 0
fi

BIN_DIR="$HOME/.local/bin"
for dir in /usr/lib/git-core /usr/libexec/git-core /usr/local/libexec/git-core /usr/share/doc/git/contrib/subtree; do
    if [ -x "$dir/git-subtree" ]; then
        mkdir -p "$BIN_DIR"
        ln -sf "$dir/git-subtree" "$BIN_DIR/git-subtree"
        break
    fi
done

case ":$PATH:" in
    *":$BIN_DIR:"*) ;;
    *) export PATH="$BIN_DIR:$PATH" ;;
esac

if ! git subtree --help >/dev/null 2>&1; then
    echo "Error: 'git subtree' is not available. Install git-subtree (e.g. the 'git' apt package)." >&2
    exit 1
fi
echo "Linked git-subtree into $BIN_DIR."
