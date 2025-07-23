# This script initializes a Git submodule for an Overleaf project and updates the main repository.
git clone digital-systems-analysis-main-repo-url
cd digital-systems-analysis
git submodule update --init --recursive


# Make sure the folder doesn't already exist
cd digital-systems-analysis
# Remove the existing submodule if it exists
rm -rf articles/interview-barriers
# Add the Overleaf repo as a submodule
git submodule add https://git@git.overleaf.com/68800ce728ec6c212c8353ee articles/hiring-systems
# Commit the change to your main repo
git commit -m "Add ihiring-systems article as submodule"

# pull all articles (Overleaf repos) automatically into their subfolders.
cd digital-systems-analysis
git submodule update --init --recursive

# Push main repo with submodule references
git push origin main

# Remove the submodule if needed
git submodule deinit -f articles/hiring-systems
git rm -f articles/hiring-systems
rm -rf .git/modules/articles/hiring-systems
git commit -m "Remove submodule articles/hiring-systems"

#To pull latest changes from Overleaf for all submodules:
git submodule update --remote --merge
# To push changes to Overleaf for a specific submodule:
cd articles/hiring-systems
# edit your LaTeX files here
git add .
git commit -m "Edit article content"
git push origin master  # or your branch
# To update the main repo with the latest submodule changes:
git add articles/hiring-systems
git commit -m "Update submodule pointer for hiring-systems"
git push origin main
