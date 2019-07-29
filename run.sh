#!/bin/bash
git pull
git add .
git commit -m "init"
git push

ssh root@47.89.13.13 "cd /root/nginx/www & rm -rf *"

hexo clean && hexo deploy