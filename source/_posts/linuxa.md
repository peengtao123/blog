---
title: linux优化
date: 2019-07-29 13:40:15
tags:
- linux
---
linux常用运维命令
<!-- more -->
# 1 关闭防火墙的方法

```bash 
systemctl stop firewalld.service #停止firewall
systemctl disable firewalld.service #禁止firewall开机启动
```