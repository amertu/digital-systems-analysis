#!/bin/bash
set -e

# Create required folders
mkdir -p output/articles
mkdir -p css templates

# Create default CSS if missing
if [ ! -f css/latex-style.css ]; then
  cat <<EOF > css/latex-style.css
body {
  font-family: "Latin Modern Roman", serif;
  font-size: 14px;
  line-height: 1.6;
  max-width: 700px;
  margin: auto;
  padding: 2em;
  background: #fff;
  color: #111;
}
h1, h2, h3 {
  font-weight: bold;
  margin-top: 1.5em;
}
section {
  margin-bottom: 2em;
}
EOF
  echo "Created css/latex-style.css"
fi

# Create default HTML template if missing
if [ ! -f templates/latex-to-html.html ]; then
  cat <<EOF > templates/latex-to-html.html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8"/>
  <title>\$title\$</title>
  <link rel="stylesheet" href="../../css/latex-style.css"/>
  <script src="https://polyfill.io/v3/polyfill.min.js?features=es6"></script>
  <script src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js"></script>
</head>
<body>
\$body\$
</body>
</html>
EOF
  echo "Created templates/latex-to-html.html"
fi

# Convert each article
for d in articles/*; do
  if [ -f "$d/main.tex" ]; then
    name=$(basename "$d")
    outdir="output/articles/$name"
    mkdir -p "$outdir"
    echo "Converting $name..."

    # Check for refs.bib
    if [ -f "$d/refs.bib" ]; then
      pandoc "$d/main.tex" \
        --citeproc \
        --bibliography="$d/refs.bib" \
        -s \
        --mathjax \
        --template=templates/latex-to-html.html \
        --metadata title="$name" \
        -o "$outdir/index.html"
    else
      pandoc "$d/main.tex" \
        -s \
        --mathjax \
        --template=templates/latex-to-html.html \
        --metadata title="$name" \
        -o "$outdir/index.html"
    fi
  fi
done

echo "✅ Done. HTML files are in output/articles/"
