#!/bin/bash

OUTPUT_FILE="index.html"

cat <<EOF > "$OUTPUT_FILE"
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Digital Systems Analysis</title>
  <link rel="stylesheet" href="style.css" />
</head>
<body>
  <header>
    <h1>Digital Systems Analysis</h1>
    <p>Critical perspectives on software, systems, and society</p>
  </header>
  <main>
    <section class="articles">
EOF

for dir in articles/*; do
  [ -d "$dir" ] || continue
  title=$(sed -n '1p' "$dir/title.txt" 2>/dev/null || echo "Untitled")
  desc=$(sed -n '2p' "$dir/title.txt" 2>/dev/null || echo "")
  date=$(sed -n '3p' "$dir/title.txt" 2>/dev/null || echo "")
  art_link=$(basename "$dir")/index.html

  cat <<EOF >> "$OUTPUT_FILE"
      <article>
        <h2><a href="articles/$art_link">$title</a></h2>
        <p>$desc</p>
        <p class="meta">Published: $date</p>
      </article>
EOF
done

cat <<EOF >> "$OUTPUT_FILE"
    </section>
  </main>
  <footer>
    © 2025 Amer Alkojjeh — Powered by GitHub Pages and Overleaf
  </footer>
</body>
</html>
EOF

echo "[✔] Generated index.html with links to all articles."
