---
title: docker
date: 2019-03-10 11:36:16
categories:
- 设施
- 容器
tags: 
- docker
- 容器
---
这是摘要
<!-- more -->
[官网](https://docs.docker-cn.com/)
[菜鸟教程](http://www.runoob.com/docker/docker-tutorial.html)
# Docker 安装 MySQL
```bash
runoob@runoob:~$ mkdir -p ~/mysql/data ~/mysql/logs ~/mysql/conf
runoob@runoob:~/mysql$ docker pull mysql:5.7

docker run -p 3306:3306 --name mymysql -v $PWD/conf:/etc/mysql/conf.d -v $PWD/logs:/logs -v $PWD/data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=123456 -d mysql:5.6

```
命令说明：
* -p 3306:3306：将容器的 3306 端口映射到主机的 3306 端口。
* -v -v $PWD/conf:/etc/mysql/conf.d：将主机当前目录下的 conf/my.cnf 挂* 载到容器的 /etc/mysql/my.cnf。
* -v $PWD/logs:/logs：将主机当前目录下的 logs 目录挂载到容器的 /logs。
* -v $PWD/data:/var/lib/mysql ：将主机当前目录下的data目录挂载到容器的 /var/lib/mysql 。
* -e MYSQL_ROOT_PASSWORD=123456：初始化 root 用户的密码。

# Docker之开启远程访问

```
vim /usr/lib/systemd/system/docker.service

ExecStart=/usr/bin/dockerd  -H tcp://0.0.0.0:2375  -H unix:///var/run/docker.sock

#重新加载配置文件
systemctl daemon-reload    

#重启服务
systemctl restart docker.service 

#查看端口是否开启
netstat -nptl

#直接curl看是否生效
curl http://127.0.0.1:2375/info

```
# 进入容器执行
```bash
docker exec -it es /bin/bash
```
