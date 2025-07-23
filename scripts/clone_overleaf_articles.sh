#!/bin/bash
set -e

if [[ -z "$OVERLEAF_GIT_TOKE" ]]; then
  echo "Error: OVERLEAF_GIT_TOKEN environment variable is not set"
  exit 1
fi

mkdir -p articles

while read -r project_id folder; do
  echo "Cloning $folder from project $project_id"
  git clone https://git:${OVERLEAF_GIT_TOKEN}@git.overleaf.com/$project_id articles/$folder || echo "Warning: failed to clone $folder"
done < overleaf_repos.txt
