#!/bin/sh

set -e

[ -z "${GITHUB_PAT}" ] && exit 0
[ "${TRAVIS_BRANCH}" != "master" ] && exit 0

git config --global user.email "andreuboada@me.com"
git config --global user.name "andreuboada"

git clone https://${GITHUB_PAT}@github.com/${TRAVIS_REPO_SLUG}.git book-output
cd book-output
git rm -rf *
mkdir docs
cp -r ../docs/* ./docs
git add --all *
git commit -m"Actualizar notas" || true
git push -q origin master
