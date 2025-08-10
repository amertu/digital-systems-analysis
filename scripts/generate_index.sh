#!/bin/bash

set -e

OUTPUT_DIR="output"
OUTPUT_ARTICLES_DIR="$OUTPUT_DIR/articles"
OUTPUT_MAIN_FILE="$OUTPUT_DIR/index.html"
ARTICLE_META_FILE="metadata.json"

mkdir -p "$OUTPUT_DIR"

  declare -A year_groups
  for dir in "$OUTPUT_ARTICLES_DIR"/*; do
    echo "Processing directory: $dir"
    [ -d "$dir" ] || continue

    meta_data="$dir/$ARTICLE_META_FILE"
    html_file="$dir/index.html"
    slug=$(basename "$dir")

    # Default values
    title="${slug//-/ }"
    description="No description available."
    date=$(date +"%Y-%m-%d")
    read_time=1

    echo "Load metadata if available"
    if [[ -f "$meta_data" ]]; then
      title=$(jq -r '.title // empty' "$meta_data")
      description=$(jq -r '.description // empty' "$meta_data")
      date=$(jq -r '.date // empty' "$meta_data")
    else
      echo "⚠️  No metadata for $slug"
    fi

    echo "Read time estimation"

    if [[ -f "$html_file" ]]; then
      text=$(lynx -dump -nolist "$html_file" 2>/dev/null || true)
      if [[ -n "$text" ]]; then
        word_count=$(echo "$text" | wc -w)
        if [[ $word_count -gt 0 ]]; then
          read_time=$(awk -v words="$word_count" 'BEGIN { print int((words + 199) / 200) }')
        fi
      fi
    else
      echo "⚠️  No HTML for $slug"
      continue
    fi

    echo "Read time: $read_time min"

    if ! year=$(date -d "$date" +%Y 2>/dev/null); then
      echo "⚠️  Invalid date format in $meta_data: $date"
      year="unknown"
    fi

    article_html="<article>
      <h2><a href=\"articles/$slug/index.html\">$title</a></h2>
      <p>$description</p>
      <p class=\"meta\">Published: $date &bull; Read time: ${read_time} min</p>
      </article>"

    year_groups[$year]+="$article_html"$'\n'
  done

echo "Sort years descending"
sorted_years=$(printf "%s\n" "${!year_groups[@]}" | sort -r)

article_list=""
for year in $sorted_years; do
  article_list+=$'\n<h2 class="year-heading">'"$year"'</h2>\n<section class="articles">\n'"${year_groups[$year]}"'</section>\n'
done

# Generate index.html with embedded template
cat > "$OUTPUT_MAIN_FILE" <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>Digital Systems Analysis</title>
  <style>
    * { box-sizing: border-box; }
    html, body { height: 100%; margin: 0; }
    body {
      display: flex;
      flex-direction: column;
      min-height: 100vh;
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      background-color: #f9fafb;
      color: #1a202c;
    }
    main { flex: 1 0 auto; max-width: 900px; margin: 2rem auto 3rem auto; padding: 0 1rem; }
    header {
      text-align: center;
      padding: 2rem 1rem 1rem;
      background-color: #2d3748;
      color: white;
      box-shadow: 0 2px 5px rgb(0 0 0 / 0.1);
    }
    header h1 { margin: 0; font-weight: 700; font-size: 2.5rem; }
    header p {
      margin-top: 0.3rem;
      font-style: italic;
      font-weight: 300;
      color: #a0aec0;
      font-size: 1.2rem;
    }
    #search-input {
      display: block;
      width: 100%;
      max-width: 900px;
      margin: 1rem auto 2rem auto;
      padding: 0.5rem 1rem;
      font-size: 1.1rem;
      border: 1px solid #cbd5e0;
      border-radius: 6px;
      box-shadow: inset 0 1px 2px rgb(0 0 0 / 0.1);
    }
    section.articles article {
      background: white;
      padding: 1.2rem 1.5rem;
      margin-bottom: 1.5rem;
      border-radius: 8px;
      box-shadow: 0 1px 3px rgb(0 0 0 / 0.1);
      transition: box-shadow 0.2s ease-in-out;
    }
    section.articles article:hover {
      box-shadow: 0 4px 8px rgb(0 0 0 / 0.15);
    }
    section.articles h2 {
      margin: 2rem 0 1rem;
      font-weight: 700;
      font-size: 1.8rem;
      color: #2d3748;
    }
    section.articles a {
      color: #2b6cb0;
      text-decoration: none;
    }
    section.articles a:hover {
      text-decoration: underline;
    }
    section.articles p {
      margin: 0.5rem 0 0.8rem 0;
      color: #4a5568;
      font-size: 1rem;
      line-height: 1.4;
    }
    section.articles .meta {
      font-size: 0.85rem;
      color: #718096;
    }
    footer {
      flex-shrink: 0;
      text-align: center;
      padding: 1rem;
      font-size: 0.9rem;
      color: #a0aec0;
      background-color: #f7fafc;
      border-top: 1px solid #e2e8f0;
    }
  </style>
</head>
<body>
  <header>
    <h1>Digital Systems Analysis</h1>
    <p>Personal articles on tech, systems, and society</p>
  </header>

  <main>
    <input type="text" id="search-input" placeholder="Search articles..." aria-label="Search articles" />
    $(echo -e "$article_list")
  </main>

  <footer>
    &copy; $(date +%Y) Amer Alkojjeh
  </footer>

  <script async src="https://www.googletagmanager.com/gtag/js?id=G-WY4R9HJVCY"></script>
  <script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', 'G-WY4R9HJVCY');
  </script>

  <script>
    const searchInput = document.getElementById('search-input');
    searchInput.addEventListener('input', () => {
      const filter = searchInput.value.toLowerCase();
      const articles = document.querySelectorAll('section.articles article');
      articles.forEach(article => {
        const text = article.textContent.toLowerCase();
        article.style.display = text.includes(filter) ? '' : 'none';
      });

      // Hide year heading if no articles visible in that section
      const yearSections = document.querySelectorAll('section.articles');
      yearSections.forEach(section => {
        const visibleArticles = Array.from(section.querySelectorAll('article')).filter(a => a.style.display !== 'none');
        const yearHeading = section.previousElementSibling; // <h2> before the section
        if (visibleArticles.length === 0) {
          if (yearHeading) yearHeading.style.display = 'none';
          section.style.display = 'none';
        } else {
          if (yearHeading) yearHeading.style.display = '';
          section.style.display = '';
        }
      });
    });
  </script>
</body>
</html>
EOF

echo "✅ Generated $OUTPUT_MAIN_FILE"
