#!/bin/bash
set -e

OUTPUT_DIR="docs"

echo "🧼 Cleaning output dir..."
rm -rf $OUTPUT_DIR
mkdir -p $OUTPUT_DIR

echo "🔄 Updating submodules..."
git submodule update --remote --merge

echo "📄 Converting LaTeX to HTML..."

for ARTICLE_DIR in articles/*; do
    NAME=$(basename "$ARTICLE_DIR")
    TEX="$ARTICLE_DIR/main.tex"

    if [ -f "$TEX" ]; then
        mkdir -p "$OUTPUT_DIR/$NAME"
        pandoc "$TEX" \
            --from=latex \
            --to=html5 \
            --output="$OUTPUT_DIR/$NAME/index.html" \
            --standalone \
            --mathjax \
            --metadata title="$NAME"
        echo "✅ Converted $NAME"
    else
        echo "⚠️ Skipped $NAME (main.tex not found)"
    fi
done
