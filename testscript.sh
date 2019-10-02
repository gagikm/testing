#!/bin/sh
set -e

read -p "Ready to begin release process for Release $1?" -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
  read -p "Create release branch from develop?" -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]
  then
    git checkout develop
    git pull
    git checkout -b release-$1 develop
    git commit --quiet -a -m "Release-$1" || true
  fi

  read -p "Merge release branch into master?" -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]
  then
    git checkout master
    git merge --no-ff release-$1
    git tag -a Release-$1
    git push
    echo "Master branch is now ready to be deployed."
  fi

  read -p "Merge release branch into develop?" -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]
  then
    git checkout develop
    git merge --no-ff release-$1
    git push
  fi

  read -p "Delete release branch?" -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]
  then
    git branch -d release-$1
  fi
fi
