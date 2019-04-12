---
title: 安装kubernetes 1.13
date: 2018-03-15 14:06:32
tags: kubernetes
categories:
- 设施
- 容器
---
这是摘要

<!-- more -->

# 1. 准备阶段
## 1.1组建规划
主机名|地址|角色|组件 |
--|--|--|--
master|10.16.32.85|master|etcd、kube-apiserver、kube-controller、kube-scheduler
node|10.16.32.86|node|kubelet、docker、kube_proxy
## 1.2软件下载
### Kubernetes二进制文件下载
https://github.com/kubernetes/kubernetes/releases

https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG-1.13.md#v1130-beta2
在/root/kubernetes/server/bin 路径下包含一些必须的组件
### etcd下载
https://github.com/coreos/etcd/releases/
这里选用的是最新版本v3.3.10。
# 2. Master安装
## 2.1 etcd数据库安装
### 安装
将下载的etcd文件包解压，解压后将etcd、etcdctl文件复制到/usr/bin
### 设置服务文件
创建etcd工作目录
```bash
mkdir /var/lib/etcd/
```
在/usr/lib/systemd/system/目录下创建文件etcd.service，内容为
```bash
[Unit]
Description=Etcd Server

[Service]
Type=notify
TimeoutStartSec=0
Restart=always
WorkingDirectory=/var/lib/etcd/
EnvironmentFile=-/etc/etcd/etcd.conf
ExecStart=/usr/bin/etcd 

[Install]
WantedBy=multi-user.target
```
创建配置文件/etc/etcd/etcd.conf
```bash
ETCD_NAME=ETCD Server
ETCD_DATA_DIR="/var/lib/etcd/"
ETCD_LISTEN_CLIENT_URLS="http://0.0.0.0:2379"
ETCD_ADVERTISE_CLIENT_URLS="http://10.16.32.85:2379"
```
配置开机启动并运行
```bash
systemctl daemon-reload
systemctl enable etcd.service
systemctl start etcd.service
```
检查etcd是否安装成功并运行
```bash
[root@localhost ~]# etcdctl cluster-health
member 8e9e05c52164694d is healthy: got healthy result from http://10.2.8.130:2379
cluster is healthy
```

# Node安装

中文社区
https://www.kubernetes.org.cn/
中文文档
http://docs.kubernetes.org.cn/