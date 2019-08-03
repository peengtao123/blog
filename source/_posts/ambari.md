---
title: ambari
date: 2019-03-31 23:00:58
tags: 大数据
---
这是摘要

<!-- more -->

# Ambari(2.7.3)安装
```bash
curl --silent --location https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo
curl --silent --location https://rpm.nodesource.com/setup_8.x | sudo bash -
sudo yum install yarn
yum install nodejs

yum install git

tar xfvz apache-ambari-2.7.3-src.tar.gz
cd apache-ambari-2.7.3-src
mvn versions:set -DnewVersion=2.7.3.0.0
 
pushd ambari-metrics
mvn versions:set -DnewVersion=2.7.3.0.0
popd

mvn -B clean install rpm:rpm -DnewVersion=2.7.3.0.0 -DbuildNumber=4295bb16c439cbc8fb0e7362f19768dde1477868 -DskipTests -Dpython.ver="python >= 2.6"


```