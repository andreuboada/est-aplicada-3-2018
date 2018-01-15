#!/bin/sh

echo "P0"
set -e
echo "P1"

echo "P3"
git config --global user.email "andreuboada@me.com"
git config --global user.name "andreuboada"

echo "P4"
git clone -b gh-pages https://${GITHUB_PAT}@github.com/${TRAVIS_REPO_SLUG}.git book-output
cd book-output
echo "P5"
git rm -rf
echo "P6"
git status
echo $(ls)*
echo "P7"
cp -r ../docs/* ./
echo "P8"
echo $(ls)
git add --all *
echo "P9"
git commit -m "Actualizar notas" || true
echo "Push to corresponding github branch"
git push origin gh-pages
