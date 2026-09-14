#!/usr/bin/env bash

git init
git add .
git commit -m "first commit"
git log --oneline
git remote add origin git@github.com:yourname/git-slides.git
git push -u origin main
