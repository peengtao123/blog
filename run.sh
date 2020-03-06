#!/usr/bin/env bash
git pull
git add .
git commit -m "init"
git push

hexo clean && hexo deploy