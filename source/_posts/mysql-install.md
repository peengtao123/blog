---
title: MySql Yum Respositroy使用指导
date: 2018-11-08 18:25:41
tags:
categories:
- 数据库
---
mysql安装教程
<!-- more -->
## 1、添加the MySQL Yum Repository
去官网下载页下载MySQL Yum Repository安装包
```bash
wget https://dev.mysql.com/get/mysql80-community-release-el7-2.noarch.rpm
```
安装
```bash
sudo rpm -Uvh mysql80-community-release-el7-2.noarch.rpm
```
## 2、选择发布版本
默认选择的是最新的版本，查看版本列表
```bash
yum repolist all | grep mysql
```
选择相应版本
```bash
shell> sudo yum-config-manager --disable mysql80-community
shell> sudo yum-config-manager --enable mysql57-community
```
## 3、安装mysql
```bash
 sudo yum install mysql-community-server
```
## 4、启动mysql
```bash
sudo service mysqld start
sudo systemctl start mysqld.service
```
验证启动状态
```bash
sudo systemctl status mysqld.service
```
## 5、管理mysql
msyql服务第一次启动时会执行以下步骤
1. 服务初始化
2. SSl认证文件在数据目录生成
3.  validate_password plugin插件被安装并启用
此插件会验证密码强度，在设置新密码过程中；密码最小长度、包含数字个数、字母个数等复杂度验证
4. 超级用户 'root'@'localhost'被创建，密码生成并保存在错误日志文件中，用下面命令查看
```bash
shell> sudo grep 'temporary password' /var/log/mysqld.log

```
尽快使用生成的密码登录系统，并修该
```bash
shell> mysql -uroot -p
mysql> ALTER USER 'root'@'localhost' IDENTIFIED BY 'MyNewPass4!';
```
