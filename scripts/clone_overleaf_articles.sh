#!/bin/bash
# set -e  # Disabled to allow processing all repos even if one fails

OVERLEAF_GIT_TOKEN="olp_2eGQuHiM7HGZ7H7nr2j1ygKBhRfhU40MuSBv"

#!/bin/bash
# set -e  # Disabled to allow continuing on errors

if [[ -z "$OVERLEAF_GIT_TOKEN" ]]; then
  echo "Error: OVERLEAF_GIT_TOKEN environment variable is not set"
  exit 1
fi

mkdir -p articles

while IFS= read -r line || [[ -n "$line" ]]; do
  # Remove carriage returns and trailing whitespace
  line="${line//$'\r'/}"          # remove all \r chars
  line="${line%"${line##*[![:space:]]}"}"  # trim trailing whitespace

  # Skip empty lines
  [[ -z "$line" ]] && continue

  # Extract project_id and folder by splitting on first space/tab
  project_id="${line%%[[:space:]]*}"
  folder="${line#*[[:space:]]}"

  # Trim trailing whitespace from folder and project_id (just in case)
  project_id="${project_id//$'\r'/}"
  project_id="${project_id%"${project_id##*[![:space:]]}"}"
  folder="${folder//$'\r'/}"
  folder="${folder%"${folder##*[![:space:]]}"}"

  # Skip if either is empty after trimming
  if [[ -z "$project_id" || -z "$folder" ]]; then
    continue
  fi

  echo "Cloning $folder from project $project_id"
  git clone "https://git:${OVERLEAF_GIT_TOKEN}@git.overleaf.com/$project_id" "articles/$folder" || echo "Warning: failed to clone $folder"

done < overleaf_repos.txt
