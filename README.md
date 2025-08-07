# Digital Systems Analysis - Build & Deploy Articles

## Project Overview

This project automates the process of managing, converting, and publishing academic and technical articles written in LaTeX (Overleaf projects) as clean, styled HTML pages on GitHub Pages. It integrates Overleaf private project repositories as git submodules or cloned repos, converts LaTeX sources to HTML using Pandoc with citation support and math rendering, generates an index page with article metadata, and deploys the output automatically via GitHub Actions.

## Tech Stack
[![GitHub Actions](https://img.shields.io/github/actions/workflow/status/amertu/digital-systems-analysis/build.yml?branch=main&label=GitHub%20Actions&logo=github)](https://github.com/amertu/digital-systems-analysis/actions/workflows/build.yml)


![Shell Script](https://img.shields.io/badge/Scripting-Unix%20Shell-blue?logo=gnu-bash&logoColor=white)
![LaTeX](https://img.shields.io/badge/Markup-LaTeX-008080?logo=latex&logoColor=white)
![JSON](https://img.shields.io/badge/Format-JSON-blue?logo=json&logoColor=white)
![HTML](https://img.shields.io/badge/Markup-HTML5-orange?logo=html5&logoColor=white)


## Key Features

- **Automated cloning** of multiple Overleaf private projects using a personal access token.
- **Change detection** in Overleaf sources to avoid unnecessary rebuilds.
- **Pandoc-based conversion** from LaTeX (including bibliography and citations) to standalone HTML files.
- **MathJax integration** for rendering LaTeX math formulas.
- **Styled output** consistent with academic readability (using Latin Modern fonts and clean CSS).
- **Dynamic index generation** grouping articles by year, with metadata and estimated read time.
- **Continuous deployment** to GitHub Pages on changes or scheduled intervals (via GitHub Actions).
- **Graceful workflow stops** when no Overleaf content changed to save CI resources.

## Repository Structure

```
                digital-systems-analysis/
                │
                ├── .github/
                │   └── workflows/
                │       └── build.yml
                ├── articles/
                ├── scripts/
                │   ├── convert_articles.sh
                │   └── generate_index.sh
                ├── overleaf_repos.txt   ← Here, at root
                ├── _config.yml
                ├── LICENSE
                └── README.md
```

## Setup Instructions

### 1. Configure Overleaf Access

- Create a personal git access token on Overleaf.
- Store it as a GitHub secret `OVERLEAF_GIT_TOKEN`.

### 2. Prepare `overleaf_repos.txt`
Each line corresponds to an Overleaf project ID and the local folder name where it will be cloned.

Format each line as:
```
<overleaf-project-id> <folder-name>
```
Example:
```
1234567890abcdefg my-article
1234567890hijklmn another-article
```
### 3. Clone and Convert Articles

- Run `./scripts/clone_overleaf_articles.sh` to clone/update Overleaf repos locally.
- Run `./scripts/convert_articles.sh` to convert all LaTeX projects to HTML.
- Run `./scripts/generate_index.sh` to create the main index page with metadata.

### 4. Deploying with GitHub Actions

- The workflow `build.yml` automates all above steps on pushes to `main`, on schedule (every 30 minutes), or manual dispatch.
- It also skips processing if no Overleaf content changed.
- Deployment is done to GitHub Pages, publishing the `/output` directory.

## Scripts Summary

- **clone_overleaf_articles.sh**  
  Clones all projects listed in `overleaf_repos.txt` into `articles/` folder.

- **check_changes.sh**
  Checks if there were any changes in the Overleaf articles compared to previous run.

- **convert_articles.sh**  
  Converts each article’s `main.tex` to an HTML file in the `output/` folder, preserving bibliography and math rendering.

- **generate_index.sh**  
  Scans metadata files in each article folder to generate an overview `index.html` page grouping articles by publication year, including estimated read time.

## Technical Details

- Uses **Pandoc** with `--citeproc` for citation processing.
- Uses **MathJax** for rendering math formulas in the browser.
- Read time is estimated based on word count (average 200 words per minute).
- Articles are styled using a clean, readable CSS with Latin Modern fonts.
- The index page dynamically groups articles by year (descending).

## Contribution

Contributions, issues, and feature requests are welcome.  
Feel free to fork the repo and submit pull requests.

## License

This project is licensed under the [MIT License](LICENSE).

---

© 2025 Amer Alkojjeh
