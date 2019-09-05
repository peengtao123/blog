---
title: 构建一个RESTful服务
categories:
  - 开源
date: 2019-08-25 20:19:56
tags:
---
这是摘要
<!-- more -->
这份指南将带你体验创建“hello world”RESTful服务的过程。
## 将要构建什么
你将构建一个服务，接受HTTP GET请求:
```bash
http://localhost:8080/greeting
```
并返回一个JSON传：
```json
{"id":1,"content":"hello, World"}
```
你可以定制结果，通过一个可选参数name在查询请求中：
```bash
http://localhost:8080/greeting?name=User
```
name参数值会覆盖默认值“world”，并注入到返回值中：
```bash
{"id":1,"content":"hello ,User"}
```
## 你需要什么
* 大约15分钟
* 一个你擅长的文本编辑器或开发工具
* JDK 1.8或更高
* Gradle 4+或者Maven 3.2+
* 你也可以直接导入代码到你的IDE：
  * STS
  * IDEA

## 如何完成这份指南
像其他“入门指南”，你可以从零开始并完成每一步，或者你可以。
从零开始，移步到“build with gradle”
略过基本步骤，如下：
* 下载并解压源码或者克隆
* 进入目录gs-rest-service/initial
* 跳转到

结束后，你可以检验结果对比gs-rest-service/complete