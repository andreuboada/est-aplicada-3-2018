#!/bin/sh

set -e

[ -z "${GITHUB_PAT}" ] && exit 0
[ "${TRAVIS_BRANCH}" != "master" ] && exit 0

git config --global user.email "andreuboada@me.com"
git config --global user.name "andreuboada"

git clone -b gh-pages https://${GITHUB_PAT}@github.com/${TRAVIS_REPO_SLUG}.git book-output
cd book-output
git rm -rf *
cp -r ../est-aplicada-3-2018/docs/* ./
echo $(ls)
git add --all *
git commit -m "Actualizar notas" || true
echo "Push to corresponding github branch"
git push origin gh-pages
