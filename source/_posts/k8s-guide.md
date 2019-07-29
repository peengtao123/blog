---
title: k8s-guide
date: 2019-07-28 10:44:44
tags:
---
安装后体验k8s基本功能
<!-- more -->
# 1、pod管理
```bash
apiVersion: v1
kind: Pod
metadata:
    name: hello-world
    spec:
        restartPolicy: OnFailure
        containers:
        - name: hello
          image: "ubuntu:14.04"
          command: ["/bin/echo","hello","world"]
```
# 2、搭建Harbor企业级docker仓库
# 3、[k8s安装traefik作为ingress](https://blog.csdn.net/java_zyq/article/details/82496842)