OUTPUT_FILE="output/index.html"

cat <<EOF > "$OUTPUT_FILE"
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>Digital Systems Analysis</title>
  <link rel="stylesheet" href="style.css" />
</head>
<body>
  <h1>Digital Systems Analysis</h1>
  <section class="articles">
EOF

for dir in output/articles/*; do
  [ -d "$dir" ] || continue
  title=$(sed -n '1p' "${dir}/title.txt" 2>/dev/null || echo "Untitled")
  desc=$(sed -n '2p' "${dir}/title.txt" 2>/dev/null || echo "")
  date=$(sed -n '3p' "${dir}/title.txt" 2>/dev/null || echo "")
  art_link=$(basename "$dir")/index.html

  cat <<EOF >> "$OUTPUT_FILE"
    <article>
      <h2><a href="articles/$art_link">$title</a></h2>
      <p>$desc</p>
      <p>Published: $date</p>
    </article>
EOF
done

cat <<EOF >> "$OUTPUT_FILE"
  </section>
</body>
</html>
EOF
