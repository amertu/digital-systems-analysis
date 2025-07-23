#!/bin/bash
set -e

mkdir -p output

for d in articles/*; do
  if [ -f "$d/main.tex" ]; then
    name=$(basename "$d")
    pandoc "$d/main.tex" -s -o "output/${name}.html" --mathjax
  fi
done
