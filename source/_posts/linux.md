---
title: linux运维常见问题
date: 2018-03-09 19:35:53
tags:
categories:
- 设施
- 操作系统
---
这是摘要

<!-- more -->

# linux桌面安装
1、查看可以安装的软件包
```bash
yum grouplist
```
2、开机进入桌面配置
```bash
ln -sf /lib/systemd/system/runlevel5.target /etc/systemd/system/default.target
```
# 用户管理
## linux下用户添加、删除、修改
### 用户组的管理
1、增加一个组test
```bash
groupadd test
```
2、将test组的名字改成test2
```bash
groupmod -n test2 test
```
3、删除组test2
```bash
groupdel test2
```
4、当前用户组
```bash
groups
```
5、查看用户test所在组
```bash
groups test
```
### 用户管理
1、添加用户
```bash
useradd -g test2 -m  utest                       #添加utest到test2组并创建用户目录（要先创建test2组）
useradd -g test2 -M -s /sbin/nologin  qtest      #添加qtest到test2组不创建用户目录，并且不可用于登录
```
2、修改用户test密码
```bash
passwd test
```
3、修改用户
```bash
id utest                                 #查看utest用户的UID和GID
usermod -d /home/test -G test2 utest     #将utest用户的登录目录改成/home/test，并加入test2组，注意这里是大G。
usermod -s /bin/bash qtest               #修改qtest用户可登录   


gpasswd -a utest test3    #将用户utest加入到test3组(用户可以属于多个组)
gpasswd -d utest test3     #将用户utest从test3组中移出
```
4、删除用户
```bash
userdel qtest         #删除用户qtest
userdel -r utest      #删除用户utest，同时删除他的工作目录
```
# 包管理rpm
```bash
rpm -ivh #安装一个包
rpm -Uvh #升级一个包
rpm e 3 # 移除一个包
```
## 包管理工具
安装rpm-build

```bash
# yum -y install rpm-build
```