#!/bin/bash

# Usage: ./init-article.sh hiring-systems

ARTICLE="$1"

if [[ -z "$ARTICLE" ]]; then
  echo "❌ Usage: $0 <article-name>"
  exit 1
fi

mkdir -p "$ARTICLE"/{figures,output}

cat > "$ARTICLE/main.tex" <<EOF
\\documentclass{article}
\\usepackage{graphicx}
\\usepackage[backend=bibtex]{biblatex}
\\addbibresource{references.bib}

\\title{Title Goes Here}
\\author{Your Name}
\\date{\\today}

\\begin{document}
\\maketitle

\\begin{abstract}
Your abstract here.
\\end{abstract}

\\section{Introduction}
Start writing here...

\\printbibliography
\\end{document}
EOF

cat > "$ARTICLE/references.bib" <<EOF
@article{sample2025,
  title={Sample Entry},
  author={Doe, Jane},
  journal={Example Journal},
  year={2025}
}
EOF

cat > "$ARTICLE/post_config.yml" <<EOF
---
layout: post
title: "Title Goes Here"
date: $(date +%Y-%m-%d)
author: Your Name
categories: [Category1, Category2]
tags: [tag1, tag2]
abstract: >
  Write a short abstract here.
keywords:
  - example
  - keyword
---
EOF

cat > "$ARTICLE/Makefile" <<'EOF'
ARTICLE = $(shell basename $(CURDIR))
OUTPUT_DIR = output
PDF_NAME = $(ARTICLE).pdf
MARKDOWN_NAME = index.md
POST_CONFIG = post_config.yml
BIB = references.bib

all: pdf markdown

pdf:
	latexmk -pdf -output-directory=$(OUTPUT_DIR) main.tex
	cp $(OUTPUT_DIR)/main.pdf $(OUTPUT_DIR)/$(PDF_NAME)

markdown:
	pandoc main.tex \
		--from=latex \
		--to=gfm \
		--citeproc \
		--bibliography=$(BIB) \
		--output=$(OUTPUT_DIR)/$(MARKDOWN_NAME)
	yq eval-all 'select(fileIndex == 0) * select(fileIndex == 1)' $(POST_CONFIG) $(OUTPUT_DIR)/$(MARKDOWN_NAME) > $(OUTPUT_DIR)/tmp && mv $(OUTPUT_DIR)/tmp $(OUTPUT_DIR)/$(MARKDOWN_NAME)

clean:
	latexmk -C
	rm -f $(OUTPUT_DIR)/*.pdf $(OUTPUT_DIR)/$(MARKDOWN_NAME)
EOF

cat > "$ARTICLE/.gitignore" <<EOF
*.aux
*.log
*.out
*.toc
*.fls
*.fdb_latexmk
*.synctex.gz
/output/*.pdf
/output/*.md
.DS_Store
*.swp
EOF

cat > "$ARTICLE/README.md" <<EOF
# $ARTICLE — Academic Article

This repo contains the LaTeX source, bibliography, and automation to generate:

- 📄 PDF: \`output/$ARTICLE.pdf\`
- 📝 Markdown blog post: \`output/index.md\`

## Quick Start

\`\`\`bash
make
\`\`\`

## Structure

- \`main.tex\`
- \`references.bib\`
- \`post_config.yml\`
- \`figures/\`
- \`output/\`
EOF

echo "✅ Created article skeleton in '$ARTICLE/'"
