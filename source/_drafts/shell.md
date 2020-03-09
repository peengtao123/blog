---
title: shell
date: 2018-03-13 18:58:04
tags:
---
这是摘要
<!-- more -->
# shell
```bash
docker run -d -p 80:80 --name nginx -v ~/nginx/www:/usr/share/nginx/html -v ~/nginx/conf/nginx.conf:/etc/nginx/nginx.conf -v ~/nginx/logs:/var/log/nginx nginx
```