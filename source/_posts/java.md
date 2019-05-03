---
title: java
date: 2019-04-19 14:19:40
tags:
---
java主要概念
<!-- more -->
## 数组
### 数组定义
java支持两种语法来定义数组：
1. type[] arrayName;
2. type arrayName[];
数组初始化：
java语言中的数组必须先初始化，才可以使用。所谓初始化就是为数组元素分配内存空间，并为每个元素赋初始值。
有两种初始化方式：
1. 静态初始化
arrayName = new type[]{element1,element2...};
2. 动态初始化
## java泛型
### 定义泛型
### 使用泛型
## 8、java集合
### 集合概述
### Annotation(注解)
从JDK 5开始，Java增加了对元数据（MetaData）的支持，也就是Annotation，这种Annotation与第三章所介绍的注释有区别。Annotation是代码里的特殊标记，这些标记可以在编译、类加载、运行时被读取，并执行相应处理。通过使用Annotation，程序开发人员可以在不改变原有逻辑的情况下，在源文件中嵌入一些补充信息。代码分析工具、开发工具和部署工具可以通过这些补充信息进行验证或者进行部署。