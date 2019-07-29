#!/bin/bash
git pull
git add .
git commit -m "init"
git push

ssh root@47.89.13.13 "cd /root/nginx & rm -rf www & mkdir www"

hexo clean && hexo deploy