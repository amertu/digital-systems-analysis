#!/bin/bash
set -e

# ========== CONFIGURATION ==========
SRC_DIR="articles"
OUT_DIR="output/articles"
MAIN_TEX="main.tex"
BIB_FILE="references.bib"
TEMPLATE_FILE="embedded-template.html"

# ========== EMBEDDED LATEX-LIKE STYLE ==========
LATEX_CSS=$(cat <<'EOF'
<style>
body {
  font-family: "Latin Modern Roman", Georgia, serif;
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
</style>
EOF
)

# ========== CREATE TEMPLATE ==========
mkdir -p "$(dirname "$TEMPLATE_FILE")"

cat <<EOF > "$TEMPLATE_FILE"
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8"/>
  <title>\$title\$</title>
  $LATEX_CSS
  <script src="https://polyfill.io/v3/polyfill.min.js?features=es6"></script>
  <script src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js"></script>
</head>
<body>
\$body\$
</body>
</html>
EOF

# ========== CONVERT ARTICLES ==========
mkdir -p "$OUT_DIR"

for dir in "$SRC_DIR"/*; do
  [ -d "$dir" ] || continue
  [ -f "$dir/$MAIN_TEX" ] || continue

  name=$(basename "$dir")
  out_dir="$OUT_DIR/$name"
  out_file="$out_dir/index.html"
  mkdir -p "$out_dir"

  echo "🔄 Converting $name → $out_file"

  if [ -f "$dir/$BIB_FILE" ]; then
    pandoc "$dir/$MAIN_TEX" \
      --citeproc \
      --bibliography="$dir/$BIB_FILE" \
      -s \
      --mathjax \
      --template="$TEMPLATE_FILE" \
      --metadata title="$name" \
      -o "$out_file"
  else
    pandoc "$dir/$MAIN_TEX" \
      -s \
      --mathjax \
      --template="$TEMPLATE_FILE" \
      --metadata title="$name" \
      -o "$out_file"
  fi
done

echo "✅ Done: All HTML articles are in $OUT_DIR/"
