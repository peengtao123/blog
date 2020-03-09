---
title: shell 教程
categories:
  - 开源
date: 2019-09-07 19:32:21
tags: 
- linux
---
shell参考教程
<!-- more -->
# BASH变量

## 比较运算
对应操作|整数操作|字符串操作
:--:|:--|:--:|
相同|-eq|=
不同|-ne|!=
大于|-gt|>
小于|-lt|<
大于或等于|-ge|
小于或等于|-le|
为空|骂|-z
不为空|打|-n

bash中的变量除了可以整数和字符串操作外，另一个作用是作为文件变量。如何if[-x /root]可以用于判断/root目录是否可以被当前用户进入。下表列出用于文件属性判断的操作符：

运算符|含义（满足下面条件返回true）
:--|:--
-e file | 文件file已经存在
-f file | 文件file是普通文件
-s file | 文件file大小不为零
-d file | 文件file是一个目录
-r file | 文件file对当前用户可读
-w file | 文件file对当前用户可以写入
-x file | 文件file对当前用户可以执行
-g file | 文件file的GID标志被设置
-u file | 文件file为UID标志被设置
-O file | 文件file 属于当前用户的
-G file | 文件file的组ID和当前用户相同
file1 -nt file2|文件file1比file2更新
file1 -ot file2|文件file1比file2更老
