mkdir -p output/articles

for d in articles/*; do
  if [ -f "$d/main.tex" ]; then
    name=$(basename "$d")
    mkdir -p "output/articles/$name"
    pandoc "$d/main.tex" -s -o "output/articles/$name/index.html" --mathjax
  fi
done
