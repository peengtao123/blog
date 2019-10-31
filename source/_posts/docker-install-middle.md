---
title: docker-install-middle
date: 2019-07-26 16:48:09
tags:
- 容器
---
docker有用网站资源汇总及常用服务器中间件容器安装方法

<!-- more -->
# docker 资源汇总
## Docker官方英文资源
docker官网：http://www.docker.com
docker官方文档：https://docs.docker.com/
Docker Windows 入门：https://docs.docker.com/docker-for-windows/
Docker CE(社区版) Ubuntu：https://docs.docker.com/install/linux/docker-ce/ubuntu/
Docker mac 入门：https://docs.docker.com/docker-for-mac/
Docker 用户指引：https://docs.docker.com/config/daemon/
Docker 官方博客：http://blog.docker.com/
Docker Hub: https://hub.docker.com/
Docker开源： https://www.docker.com/open-source
## Docker中文资源
Docker中文网站：https://www.docker-cn.com/
Docker安装手册：https://docs.docker-cn.com/engine/installation/
## Docker国内镜像
阿里云的加速器：https://help.aliyun.com/document_detail/60750.html
网易加速器：http://hub-mirror.c.163.com
官方中国加速器：https://registry.docker-cn.com
ustc的镜像：https://docker.mirrors.ustc.edu.cn
daocloud：https://www.daocloud.io/mirror#accelerator-doc（注册后使用）
# 1、rabbitmq
```bash
docker run -d --hostname my-rabbit --name rabbit -p 15672:15672 -p 5672:5672 -p 25672:25672 -p 61613:61613 -p 1883:1883 rabbitmq:management
```

# 2、docker 安装kafka

1. 下载镜像

这里使用了wurstmeister/kafka和wurstmeister/zookeeper这两个版本的镜像
```bash
docker pull wurstmeister/zookeeper
docker pull wurstmeister/kafka
```
在命令中运行docker images验证两个镜像已经安装完毕
2. 启动

启动zookeeper容器
```bash
docker run -d --name zookeeper -p 2181:2181 -t wurstmeister/zookeeper
```
启动kafka容器
```bash
docker run -d --name kafka --publish 9092:9092 --link zookeeper --env KAFKA_ZOOKEEPER_CONNECT=zookeeper:2181 --env KAFKA_ADVERTISED_HOST_NAME=192.168.59.101 --env KAFKA_ADVERTISED_PORT=9092 --volume /etc/localtime:/etc/localtime wurstmeister/kafka:latest
```
192.168.59.101 改为宿主机器的IP地址，如果不这么设置，可能会导致在别的机器上访问不到kafka。

3. 测试kafka

进入kafka容器的命令行
运行 docker ps，找到kafka的 CONTAINER ID，运行 docker exec -it ${CONTAINER ID} /bin/bash，进入kafka容器。
进入kafka默认目录 /opt/kafka_2.11-0.10.1.0
# 3、redis

```bash
$ docker run -p 6379:6379 -v $PWD/data:/data  -d redis:3.2 redis-server --appendonly yes
43f7a65ec7f8bd64eb1c5d82bc4fb60e5eb31915979c4e7821759aac3b62f330
```
命令说明：
* -p 6379:6379 : 将容器的6379端口映射到主机的6379端口
* -v $PWD/data:/data : 将主机中当前目录下的data挂载到容器的/data
* redis-server --appendonly yes : 在容器执行redis-server启动命令，并打开redis持久化配置

使用redis镜像执行redis-cli命令连接到刚启动的容器,主机IP为172.17.0.1

```bash
$ docker exec -it 43f7a65ec7f8 redis-cli
172.17.0.1:6379> info
# Server
redis_version:3.2.0
redis_git_sha1:00000000
redis_git_dirty:0
redis_build_id:f449541256e7d446
redis_mode:standalone
os:Linux 4.2.0-16-generic x86_64
arch_bits:64
multiplexing_api:epoll
...
```