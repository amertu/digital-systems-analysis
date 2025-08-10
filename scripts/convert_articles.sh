#!/bin/bash
set -e

# ========== CONFIGURATION ==========
SRC_DIR="articles"
OUT_DIR="output/articles"
MAIN_TEX="main.tex"
BIB_FILE="references.bib"
META_FILE="metadata.json"
CSL_FILE="apa.csl"
TEMPLATE_FILE="scrartcl-template.html"
CONFIG_SUBDIR="config"

# Get the parent folder name of SRC_DIR (project folder)
abs_src_dir=$(realpath "$SRC_DIR")
project_name=$(basename "$(dirname "$abs_src_dir")")

# ========== CREATE OUTPUT DIR ==========
mkdir -p "$OUT_DIR"

for dir in "$SRC_DIR"/*; do
  [ -d "$dir" ] || continue
  [ -f "$dir/$MAIN_TEX" ] || continue

  name=$(basename "$dir")
  out_dir="$OUT_DIR/$name"
  out_index_file="$out_dir/index.html"
  out_metadata_file="$out_dir/metadata.json"
  mkdir -p "$out_dir"

  # Set paths to config files
  config_dir="$dir/$CONFIG_SUBDIR"
  meta_data="$config_dir/$META_FILE"
  csl_file="$config_dir/$CSL_FILE"
  template_file="$config_dir/$TEMPLATE_FILE"
  bib_file="$dir/$BIB_FILE"

  echo "Metadata file: ${meta_data}"
  # Load metadata from JSON
  metadata_args=()
  if [ -f "$meta_data" ]; then
  cp "$meta_data" "$out_metadata_file"
  while IFS=$'\t' read -r key val; do
    val=$(echo "$val" | tr -d '\r\n' | xargs)
    if [[ -n "$val" && "$val" != "null" ]]; then
      metadata_args+=(--metadata "$key=$val")
    fi
  done < <(jq -r 'to_entries | .[] | "\(.key)\t\(.value)"' "$meta_data")
  fi

  metadata_args+=(--metadata "path=/$project_name/articles/$name/index.html")

  echo "🔄 Converting $name → $out_index_file"

  # Build pandoc command
  pandoc_args=(
    "$dir/$MAIN_TEX"
    --standalone
    --wrap=auto
    --mathjax
    --template="$template_file"
    --shift-heading-level-by=1
    "${metadata_args[@]}"
    --toc
    -o "$out_index_file"
  )

  if [ -f "$bib_file" ]; then
    pandoc_args+=(--citeproc --bibliography="$bib_file" --metadata link-citations=true)
    [ -f "$csl_file" ] && pandoc_args+=(--csl="$csl_file")
  fi

  pandoc "${pandoc_args[@]}"
done

echo "✅ Done: All HTML articles are in $OUT_DIR/"
