#!/bin/bash
set -e

# Usage:
# ./add_overleaf_submodule.sh <overleaf-git-url> <folder-name>

OVERLEAF_URL="$1"
FOLDER="$2"
REPO_IDS_FILE="overleaf_repos.txt"

if [[ -z "$OVERLEAF_URL" || -z "$FOLDER" ]]; then
  echo "Usage: $0 <overleaf-git-url> <folder-name>"
  exit 1
fi

# Add submodule
git submodule add "$OVERLEAF_URL" "articles/$FOLDER"

# Extract project ID from URL, assuming format https://git.overleaf.com/<project-id> or git@git.overleaf.com:<project-id>.git
PROJECT_ID=$(basename "$OVERLEAF_URL" .git)

# Append project ID and folder to overleaf_repos.txt if not already there
grep -q "$PROJECT_ID" "$REPO_IDS_FILE" 2>/dev/null || echo "$PROJECT_ID $FOLDER" >> "$REPO_IDS_FILE"

echo "Added submodule and updated $REPO_IDS_FILE:"
tail -n 1 "$REPO_IDS_FILE"


# usage example:
# ./add_overleaf_submodule.sh
# https://git.overleaf.com/12345678 my_overleaf_project
# or
# ./add_overleaf_submodule.sh
