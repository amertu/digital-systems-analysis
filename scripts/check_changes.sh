#!/bin/bash
set -e

# Stage changes in articles folder
git add articles/

# Check if staged changes exist
if git diff --cached --quiet; then
  echo "No changes in Overleaf articles."
  echo "changed=false" >> "$GITHUB_OUTPUT"
else
  echo "Detected changes in Overleaf articles."
  echo "changed=true" >> "$GITHUB_OUTPUT"
fi
