---
title: linux-bash
date: 2019-05-03 18:39:20
tags:
---
bash教程
<!-- more -->
# 临时和永久关闭SELINUX
1. 查看selinux状态
```bash
[root@izj6c9x98x8whxu9wx6d4pz ~]# getenforce
Disabled
```

2. 临时关闭
```bash
[root@izj6c9x98x8whxu9wx6d4pz ~]# setenforce 0
setenforce: SELinux is disabled
```

3. 永久关闭
编辑/etc/sysconfig/selinux文档,将SELINUX=enforcing改为SELINUX=disabled,重启服务器即可
或者
```bash
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
```