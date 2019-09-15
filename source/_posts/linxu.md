---
title: linux
categories:
  - 开源
date: 2019-09-13 09:44:36
tags:
- linux
---
java开发人员linux常用操作
<!-- more -->
## 设置ip
centos系统的ip配置文件路径：
```bash
vim /etc/sysconfig/network-scripts/ifcfg-enp0s3

ONBOOT=yes	#系统启动时是否激活此设备
IPADDR=192.168.0.1	#ip地址
BOOTPROTO=static	#ip地址的分配方式（static表示静态ip地址，dhcp表示自动分配ip地址）
NETMASK=255.255.255.0	#子网掩码
GATEWAY=192.168.0.2	#默认网关
DNS1=192.168.12.15	#DNS域名解析服务器
DNS2=125.168.12.5
```
配置完成后重启网卡：
```bash
systemctl restart network

```
或者重启单个网卡
```bash
ifdown eth0
ifup eth0
```
## 关闭防火墙
centos关闭防火墙的方法：
查看防火墙状态：systemctl statuc firewalld.service
关闭防火墙：systemctl stop firewalld
启动防火墙：systemctl start firewalld
开机自动关闭：systemctl disable firewalld
开启自动启动：systemctl enable firewalld
## yum常用操作
Yum（全称为 Yellow dog Updater, Modified）是一个在Fedora和RedHat以及CentOS中的Shell前端软件包管理器。
yum源配置目录：
/etc/yum.repos.d/

# 常用工具
## sed