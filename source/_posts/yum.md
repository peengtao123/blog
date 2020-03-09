---
title: yum
date: 2018-08-08 18:28:16
tags: 
- linux
---
这是摘要
<!-- more -->

# yum介绍
Yum是一个在centos和redhat中的前端软件包管理器。基于RPM包管理，能够从指定服务器自动下载RPM包并且安装，可以自动处理依赖关系，并且一次性安装所有软件包，无需频繁的一次次下载、安装。
yum语法
```
yum [options] [command] [package ...]
```
* options: 可选参数
* 进行的操作
* 包名
---
# yum常用命令
# 国内yum源
网易yum源是国内最好的yum源之一，无论速度还是软件版本，都非常不错。
## 安装步骤
首相备份/etc/yum.repos.d/CentOS-Base.repo
```
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
```
下载对应版本 repo 文件, 放入 /etc/yum.repos.d/ (操作前请做好相应备份)
* CentOS5 ：http://mirrors.163.com/.help/CentOS5-Base-163.repo
* CentOS6 ：http://mirrors.163.com/.help/CentOS6-Base-163.repo
* CentOS7 ：http://mirrors.163.com/.help/CentOS7-Base-163.repo

```
wget http://mirrors.163.com/.help/CentOS6-Base-163.repo
mv CentOS6-Base-163.repo CentOS-Base.repo
```
运行以下命令生成缓存
```
yum clean all
yum makecache
```
除了网易之外，国内还有其他不错的 yum 源，比如中科大和搜狐。

中科大的 yum 源，安装方法查看：https://lug.ustc.edu.cn/wiki/mirrors/help/centos

sohu 的 yum 源安装方法查看: http://mirrors.sohu.com/help/centos.html


>参考文章：http://www.runoob.com/linux/linux-yum.html