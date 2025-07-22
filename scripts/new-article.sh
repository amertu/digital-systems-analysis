#!/bin/bash

set -e

ARTICLE_NAME=$1
OVERLEAF_REMOTE=$2  # e.g., https://git.overleaf.com/abcdef123456

if [ -z "$ARTICLE_NAME" ] || [ -z "$OVERLEAF_REMOTE" ]; then
  echo "Usage: $0 <article-name> <overleaf-remote-url>"
  exit 1
fi

echo "Creating article: $ARTICLE_NAME"

mkdir -p "$ARTICLE_NAME"/{figures,output}

cat > "$ARTICLE_NAME/post_config.yml" <<EOF
title: "${ARTICLE_NAME//-/ }"
date: "$(date +%Y-%m-%d)"
categories: [research]
tags: [${ARTICLE_NAME//-/, }]
pdf: output/${ARTICLE_NAME}.pdf
EOF

cat > "$ARTICLE_NAME/Makefile" <<EOF
ARTICLE=${ARTICLE_NAME}
OUT=output/\$(ARTICLE).pdf

all:
	pdflatex -output-directory=output main.tex
	bibtex output/main.aux || true
	pdflatex -output-directory=output main.tex
	pdflatex -output-directory=output main.tex
EOF

cat > "$ARTICLE_NAME/.gitignore" <<EOF
output/*.aux
output/*.log
output/*.bbl
output/*.blg
output/*.toc
output/*.out
EOF

cat > "$ARTICLE_NAME/README.md" <<EOF
# $ARTICLE_NAME

This is the source for the article "$ARTICLE_NAME", synced with Overleaf.

## Compile locally

\`\`\`bash
make
\`\`\`

## Sync

\`\`\`bash
git push overleaf master
\`\`\`
EOF

# Git init & sync
cd "$ARTICLE_NAME"
git init
git remote add overleaf "$OVERLEAF_REMOTE"
git add .
git commit -m "Initial commit for $ARTICLE_NAME"
git push -u overleaf master

echo "✅ Done. Article '$ARTICLE_NAME' initialized and pushed to Overleaf."
