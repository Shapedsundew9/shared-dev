#!/usr/bin/env bash
set -euo pipefail

# Configuration
REMOTE_NAME="shared-dev"
REMOTE_URL="git@github.com:shapedsundew9/shared-dev.git"
PREFIX=".shared"
BRANCH="main"

# 1. Ensure we are inside a Git worktree and operate from repo root
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "Error: Not inside a Git repository." >&2
    exit 1
fi
cd "$(git rev-parse --show-toplevel)"

# 2. Check for uncommitted changes (git subtree requires a clean tree)
if ! git diff-index --quiet HEAD -- 2>/dev/null; then
    echo "Error: Working directory has uncommitted changes. Commit or stash them first." >&2
    exit 1
fi

# 3. Check / Add the remote alias
if git remote | grep -qx "$REMOTE_NAME"; then
    echo "Notice: Remote '$REMOTE_NAME' already exists. Skipping remote addition."
else
    echo "Adding remote '$REMOTE_NAME' ($REMOTE_URL)..."
    git remote add -f "$REMOTE_NAME" "$REMOTE_URL"
fi

# 4. Check if the subtree folder already exists
if [ -d "$PREFIX" ] || git ls-tree -d HEAD "$PREFIX" | grep -q "$PREFIX"; then
    echo "Notice: Directory '$PREFIX' already exists. Subtree is already initialized."
    exit 0
fi

# 5. Fetch and add the subtree
echo "Fetching latest refs from '$REMOTE_NAME'..."
git fetch "$REMOTE_NAME" "$BRANCH"

echo "Adding subtree into '$PREFIX'..."
git subtree add --prefix="$PREFIX" "$REMOTE_NAME" "$BRANCH" --squash

echo "Success: Subtree initialized at '$PREFIX'."

