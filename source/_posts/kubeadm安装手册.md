---
title: kubeadm安装手册
date: 2019-03-22 12:38:04
tags:
---
这是摘要

<!-- more -->

## 环境准备
在/etc/sysctl.conf中添加：
```bash
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
```
关闭防火墙以及selinux
```bash
[root@C7-1 ~] systemctl stop firewalld && setenforce 0 && swapoff -a
[root@C7-1 ~] yum install yum-utils
```
## yum源docker，k8s
```bash
[root@C7-1 ~] yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
[root@C7-1 ~] cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF
setenforce 0
yum install -y kubelet kubeadm kubectl docker-ce
systemctl enable kubelet && systemctl start kubelet
```
## 初始化集群

```bash
[root@C7-1 ~] cat /etc/sysconfig/kubelet
KUBELET_EXTRA_ARGS="--fail-swap-on=false" #K8S默认不允许Swap，此处是让初始化的时候可以通过
[root@C7-1 ~] systemctl start docker && systemctl restart kubelet && systemctl enable docker

[root@C7-1 ~] cat /proc/sys/net/bridge/bridge-nf-call-ip6tables
1
[root@C7-1 ~] cat /proc/sys/net/bridge/bridge-nf-call-iptables
1
#一定要保证上面两部的结果 都是1 如不是使用echo "1” > 覆盖过去（注意双引号）

[root@C7-1 ~] cat /etc/docker/daemon.json
{
  "registry-mirrors": ["https://xxxxxx.mirror.aliyuncs.com"]
}
#上述使用阿里云的加速器,前往阿里云免费开通

[root@C7-1 ~] systemctl daemon-reload
[root@C7-1 ~] systemctl restart docker
#使配置生效

[root@C7-1 ~] kubeadm init  --pod-network-cidr=10.244.0.0/16 --service-cidr=10.96.0.0/12 --ignore-preflight-errors=Swap 
```
## 下载k8s用到的镜像
```bash
[root@C7-1 ~]# cat bash.sh 
#!/bin/bash
images=( kube-apiserver:v1.13.4 kube-controller-manager:v1.13.4 kube-scheduler:v1.13.4 kube-proxy:v1.13.4  )
for imageName in ${images[@]} ; do
	docker pull mirrorgooglecontainers/$imageName
  	docker tag mirrorgooglecontainers/$imageName k8s.gcr.io/$imageName
done


[root@C7-1 ~]# cat bash2.sh
#!/bin/bash
images=( pause:3.1 etcd:3.2.24 coredns:1.2.6  )
for imageName in ${images[@]} ; do
	docker pull keveon/$imageName
  	docker tag keveon/$imageName k8s.gcr.io/$imageName
done
```

## 问题
1、
```bash
 Warning  FailedScheduling  19s (x7 over 50s)  default-scheduler  0/1 nodes are available: 1 node(s) had taints that the pod didn't tolerate.
```
解决办法：

默认情况下kubernetes中的master并不能运行用户的Pod. 因此需要删除 Train，允许master执行Pod

执行命令如下:
```bash
kubectl taint nodes --all node-role.kubernetes.io/master-
```