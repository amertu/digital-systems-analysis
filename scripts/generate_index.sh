#!/bin/bash
set -e

cat > output/index.html <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>Digital Systems Analysis Articles</title>
</head>
<body>
  <h1>Articles</h1>
  <ul>
EOF

for f in output/*.html; do
  fname=$(basename "$f")
  if [[ "$fname" != "index.html" ]]; then
    echo "    <li><a href=\"$fname\">${fname%.html}</a></li>" >> output/index.html
  fi
done

echo "  </ul></body></html>" >> output/index.html
