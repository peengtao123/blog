---
title: docker
date: 2019-03-10 11:36:16
tags: 
- docker
---
这是摘要
<!-- more -->
# 常用网站：
[官网](https://docs.docker-cn.com/)
[菜鸟教程](http://www.runoob.com/docker/docker-tutorial.html)
# docker安装
docker支持以下centos版本：
* centos 6.5(64-bit)
* centos 7(64-bit)

docker要求centos内核版本高于3.10，通过uname -r命令查看内核版本
```bash
# uname -r
```
## docker安装
移除旧的版本
```bash
$ sudo yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine
```
安装一些必要的工具
```bash
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
```
添加软件源信息
```bash
sudo yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
```
更新yum缓存
```bash
sudo yum makecache fast
```
安装docker-ce
```bash
sudo yum -y install docker-ce
```
启动docker服务
```bash
sudo systemctl start docker
```
测试运行hello world
```bash
[root@runoob ~]# docker run hello-world
```
## Docker 安装 MySQL
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

## Docker之开启远程访问

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
## 进入容器执行
```bash
docker exec -it es /bin/bash
```
## 拷贝容器内 Nginx 默认配置文件到本地当前目录下的 conf 目录
```bash
docker cp 6dd4380ba708:/etc/nginx/nginx.conf ~/nginx/conf
```
# 二、docker compose
Dockerfile文件
```Dockerfile
FROM python:3.7-alpine
WORKDIR /code
ENV FLASK_APP app.py
ENV FLASK_RUN_HOST 0.0.0.0
RUN apk add --no-cache gcc musl-dev linux-headers
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt
COPY . .
CMD ["flask", "run"]
```
docker-compose.yml文件
```yml
version: '3'
services:
  web:
    build: .
    ports:
      - "5000:5000"
  redis:
    image: "redis:alpine"
```