#!/usr/bin/env bash
git pull
git add .
git commit -m "init"
git push

ssh root@47.89.13.13 "rm -rf /root/nginx/www/*"

hexo clean && hexo deploy