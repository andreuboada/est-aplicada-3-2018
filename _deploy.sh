a#!/bin/sh

set -e

[ -z "${GITHUB_PAT}" ] && exit 0
[ "${TRAVIS_BRANCH}" != "master" ] && exit 0

git config --global user.email "andreuboada@me.com"
git config --global user.name "andreuboada"

git clone -b gh-pages https://${GITHUB_PAT}@github.com/${TRAVIS_REPO_SLUG}.git book-output
cd book-output
echo $(ls)*
echo "Copying output from build"
cp -r ../docs/* ./
echo "List elements of docs/ directory"
echo $(ls)
git add --all *
echo "Output of git status"
git status
git commit -m "Actualizar notas" || true
echo "Push to corresponding github branch"
git push origin gh-pages
