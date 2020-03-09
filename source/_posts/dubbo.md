---
title: dubbo
categories:
  - 开源
date: 2019-08-17 12:17:43
tags:
- 分布式
---
这是摘要
<!-- more -->
## zookeeper启动占用8080端口
zookeeper最近的版本中有个内嵌的管理控制台是通过jetty启动，也会占用8080 端口。
通过查看zookeeper的官方文档，发现有3种解决途径：

1. .删除jetty。
2. 修改端口。
  修改方法的方法有两种，一种是在启动脚本中增加 -Dzookeeper.admin.serverPort=你的端口号.一种是在zoo.cfg中增加admin.serverPort=没有被占用的端口号
3. 停用这个服务，在启动脚本中增加"-Dzookeeper.admin.enableServer=false"
