---
title: k8s安装教程
date: 2019-03-21 17:08:30
tags:
- 容器
- kubernetes
---
这是摘要
<!-- more -->
kubernetes 1.13.2 已经出来了，更新迭代比较快，安装部署一直都是对新手来说都比较麻烦，
重装了一次，整理一下文档，大家只要安装下面一步步安装，一定能成功，有些地方如果报错请具体排查，我这里安装过程如下，希望对大家有帮助，喜欢就点赞留言，大家一起交流学习；
这里是使用docker镜像安装：
安装kubernetes
环境准备，三台机器
系统环境：CentOS 7.6
192.168.1.130 k8smaster
192.168.1.131 k8snode1
192.168.1.135 k8snode2

## 1、系统准备，做host解析
```bash
hostnamectl set-hostname k8smaster

vim /etc/hosts
[root@k8smaster ~]# cat /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
192.168.1.130 k8smaster
192.168.1.131 k8snode1
192.168.1.132 k8snode2
```

## 2、禁用防火墙，安装iptables,  并安装ntp时间同步   
```bash
systemctl stop firewalld
systemctl disable firewalld
setenforce 0
iptables -F
iptables -t nat -F
iptables -I FORWARD -s 0.0.0.0/0 -d 0.0.0.0/0 -j ACCEPT
```

## 3、修改内核参数
```bash
vim /etc/sysctl.conf
net.ipv4.ip_forward=1
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-arptables = 1
vm.swappiness=0
```
关闭swap
```bash
swapoff -a
```

## 4、关闭selinux
```bash
vim /etc/selinux/config
SELINUX=disabled
```

## 5、保存修改内核参数
```bash
sysctl -p
```

## 6、安装Docker源
```bash
[root@k8smaster ~]# wget -P /etc/yum.repos.d  https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
```

## 7、 配置kubernetes源：
```bash
vim /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes Repo
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
gpgcheck=1
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
enabled=1
```
## 8、更新以下Yum源
```bash
[root@k8smaster ~]# yum update
[root@k8smaster ~]# ll /etc/yum.repos.d
总用量 40
-rw-r--r--. 1 root root 1664 11月 23 21:16 CentOS-Base.repo
-rw-r--r--. 1 root root 1309 11月 23 21:16 CentOS-CR.repo
-rw-r--r--. 1 root root  649 11月 23 21:16 CentOS-Debuginfo.repo
-rw-r--r--. 1 root root  314 11月 23 21:16 CentOS-fasttrack.repo
-rw-r--r--. 1 root root  630 11月 23 21:16 CentOS-Media.repo
-rw-r--r--. 1 root root 1331 11月 23 21:16 CentOS-Sources.repo
-rw-r--r--. 1 root root 5701 11月 23 21:16 CentOS-Vault.repo
-rw-r--r--. 1 root root 2640 1月  15 18:00 docker-ce.repo
-rw-r--r--. 1 root root  209 1月  16 14:21 kubernetes.repo
```

## 9、 安装docker, 三台机必须执行：
```bash
[root@k8smaster ~]# yum install docker-ce-18.06.1.ce  -y
```
> 备注：目前kubernetes1.13.2支持docker版本最多18.06.1ocker版本已经更新到18.9了，之前安装1.12.2时候就遇过这个大坑，所以这里就不做测试了，直接安装这个版本。所以不能指只有yum安装最新版，要指定版本型号，不建议安装到最新版本，会存在不兼容，

## 10、 启动docker并设置开机启动
```bash
systemctl start docker
systemctl enable docker
systemctl status docker
```

## 11、执行下面命令配置加速器：
```bash
curl -sSL https://get.daocloud.io/daotools/set_mirror.sh | sh -s http://f1361db2.m.daocloud.io
```
## 12、然后重启docker
```bash
systemctl restart docker
```
## 13、安装kubeadm和kubelet
```bash
[root@k8smaster ~]# yum install -y kubelet kubeadm kubectl
```
## 14、设置开机启动kubelet
```bash
systemctl start kubelet
systemctl enable kubelet.service
```

## 15、此时查看下面两个文件的值是否为1
```bash
[root@k8smaster ~]# cat /proc/sys/net/bridge/bridge-nf-call-ip6tables
1
[root@k8smaster ~]# cat /proc/sys/net/bridge/bridge-nf-call-ip6tables
1
```

## 16、K8smaster:
查看需要哪些镜像：
```bash
[root@k8smaster ~]#  kubeadm config images list
k8s.gcr.io/kube-apiserver:v1.13.2
k8s.gcr.io/kube-controller-manager:v1.13.2
k8s.gcr.io/kube-scheduler:v1.13.2
k8s.gcr.io/kube-proxy:v1.13.2
k8s.gcr.io/pause:3.1
k8s.gcr.io/etcd:3.2.24
k8s.gcr.io/coredns:1.2.6
```

## 17、这里就可以去docker-hub上面查找对应版本的镜像然后下载
执行以下命令就可以下载：
```bash
docker pull mirrorgooglecontainers/kube-apiserver-amd64:v1.13.2
docker pull mirrorgooglecontainers/kube-controller-manager-amd64:v1.13.2
docker pull mirrorgooglecontainers/kube-scheduler-amd64:v1.13.2
docker pull mirrorgooglecontainers/kube-proxy-amd64:v1.13.2
docker pull mirrorgooglecontainers/pause-amd64:3.1
docker pull mirrorgooglecontainers/etcd-amd64:3.2.24
docker pull carlziess/coredns-1.2.6
```
## 18、查看已经下载的镜像：
```bash
[root@k8smaster ~]# docker images
REPOSITORY                                             TAG                 IMAGE ID            CREATED             SIZE
mirrorgooglecontainers/kube-apiserver-amd64            v1.13.4             177db4b8e93a        5 days ago          181MB
mirrorgooglecontainers/kube-controller-manager-amd64   v1.13.4             b9027a78d94c        5 days ago          146MB
mirrorgooglecontainers/kube-proxy-amd64                v1.13.4             01cfa56edcfc        5 days ago          80.3MB
mirrorgooglecontainers/kube-scheduler-amd64            v1.13.4             3193be46e0b3        5 days ago          79.6MB
carlziess/coredns-1.2.6                                latest              f59dcacceff4        2 months ago        40MB
mirrorgooglecontainers/etcd-amd64                      3.2.24              3cab8e1b9802        3 months ago        220MB
mirrorgooglecontainers/pause-amd64                     3.1                 da86e6ba6ca1        13 months ago       742kB
```

## 19、然后给镜像打对应的标签：
```bash
docker tag mirrorgooglecontainers/kube-apiserver-amd64:v1.13.4 k8s.gcr.io/kube-apiserver:v1.13.2
docker tag mirrorgooglecontainers/kube-controller-manager-amd64:v1.13.4 k8s.gcr.io/kube-controller-manager:v1.13.2
docker tag mirrorgooglecontainers/kube-scheduler-amd64:v1.13.4 k8s.gcr.io/kube-scheduler:v1.13.2
docker tag mirrorgooglecontainers/kube-proxy-amd64:v1.13.4 k8s.gcr.io/kube-proxy:v1.13.2
docker tag mirrorgooglecontainers/pause-amd64:3.1 k8s.gcr.io/pause:3.1
docker tag mirrorgooglecontainers/etcd-amd64:3.2.24 k8s.gcr.io/etcd:3.2.24
docker tag carlziess/coredns-1.2.6 k8s.gcr.io/coredns:1.2.6
```

## 20、Node端需要下载的镜像
```bash
docker pull mirrorgooglecontainers/kube-proxy-amd64:v1.13.2
docker pull mirrorgooglecontainers/pause-amd64:3.1
docker pull carlziess/coredns-1.2.6
```

## 21、给镜像打标签：
```bash
docker tag mirrorgooglecontainers/kube-proxy-amd64:v1.13.2 k8s.gcr.io/kube-proxy:v1.13.2
docker tag mirrorgooglecontainers/pause-amd64:3.1 k8s.gcr.io/pause:3.1
docker tag carlziess/coredns-1.2.6  k8s.gcr.io/coredns:1.2.6
```

## 22初始化集群  在master端执行
> 备注：下面ip 192.168.130 需要和master端ip相同

```bash
kubeadm init --kubernetes-version=v1.13.2 --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=10.2.8.8
```
如下：
```bash
[root@k8smaster ~]# kubeadm init --kubernetes-version=v1.13.2 --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=192.168.1.130
[init] Using Kubernetes version: v1.13.2
[preflight] Running pre-flight checks
[preflight] Pulling images required for setting up a Kubernetes cluster
[preflight] This might take a minute or two, depending on the speed of your internet connection
[preflight] You can also perform this action in beforehand using 'kubeadm config images pull'
[kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[kubelet-start] Activating the kubelet service
[certs] Using certificateDir folder "/etc/kubernetes/pki"
[certs] Generating "ca" certificate and key
[certs] Generating "apiserver" certificate and key
[certs] apiserver serving cert is signed for DNS names [k8smaster kubernetes kubernetes.default kubernetes.default.svc kubernetes.default.svc.cluster.local] and IPs [10.96.0.1 192.168.1.130]
[certs] Generating "apiserver-kubelet-client" certificate and key
[certs] Generating "etcd/ca" certificate and key
[certs] Generating "etcd/healthcheck-client" certificate and key
[certs] Generating "etcd/peer" certificate and key
[certs] etcd/peer serving cert is signed for DNS names [k8smaster localhost] and IPs [192.168.1.130 127.0.0.1 ::1]
[certs] Generating "apiserver-etcd-client" certificate and key
[certs] Generating "etcd/server" certificate and key
[certs] etcd/server serving cert is signed for DNS names [k8smaster localhost] and IPs [192.168.1.130 127.0.0.1 ::1]
[certs] Generating "front-proxy-ca" certificate and key
[certs] Generating "front-proxy-client" certificate and key
[certs] Generating "sa" key and public key
[kubeconfig] Using kubeconfig folder "/etc/kubernetes"
[kubeconfig] Writing "admin.conf" kubeconfig file
[kubeconfig] Writing "kubelet.conf" kubeconfig file
[kubeconfig] Writing "controller-manager.conf" kubeconfig file
[kubeconfig] Writing "scheduler.conf" kubeconfig file
[control-plane] Using manifest folder "/etc/kubernetes/manifests"
[control-plane] Creating static Pod manifest for "kube-apiserver"
[control-plane] Creating static Pod manifest for "kube-controller-manager"
[control-plane] Creating static Pod manifest for "kube-scheduler"
[etcd] Creating static Pod manifest for local etcd in "/etc/kubernetes/manifests"
[wait-control-plane] Waiting for the kubelet to boot up the control plane as static Pods from directory "/etc/kubernetes/manifests". This can take up to 4m0s
[apiclient] All control plane components are healthy after 19.502869 seconds
[uploadconfig] storing the configuration used in ConfigMap "kubeadm-config" in the "kube-system" Namespace
[kubelet] Creating a ConfigMap "kubelet-config-1.13" in namespace kube-system with the configuration for the kubelets in the cluster
[patchnode] Uploading the CRI Socket information "/var/run/dockershim.sock" to the Node API object "k8smaster" as an annotation
[mark-control-plane] Marking the node k8smaster as control-plane by adding the label "node-role.kubernetes.io/master=''"
[mark-control-plane] Marking the node k8smaster as control-plane by adding the taints [node-role.kubernetes.io/master:NoSchedule]
[bootstrap-token] Using token: 786rp5.ju4lmdf0g06i2pmi
[bootstrap-token] Configuring bootstrap tokens, cluster-info ConfigMap, RBAC Roles
[bootstraptoken] configured RBAC rules to allow Node Bootstrap tokens to post CSRs in order for nodes to get long term certificate credentials
[bootstraptoken] configured RBAC rules to allow the csrapprover controller automatically approve CSRs from a Node Bootstrap Token
[bootstraptoken] configured RBAC rules to allow certificate rotation for all node client certificates in the cluster
[bootstraptoken] creating the "cluster-info" ConfigMap in the "kube-public" namespace
[addons] Applied essential addon: CoreDNS
[addons] Applied essential addon: kube-proxy

Your Kubernetes master has initialized successfully!

To start using your cluster, you need to run the following as a regular user:


  mkdir -p $HOME/.kube

  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config

  sudo chown $(id -u):$(id -g) $HOME/.kube/config
 

You should now deploy a pod network to the cluster.

Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:

  https://kubernetes.io/docs/concepts/cluster-administration/addons/

 
You can now join any number of machines by running the following on each node

as root:

  kubeadm join 192.168.1.130:6443 --token 786rp5.ju4lmdf0g06i2pmi --discovery-token-ca-cert-hash sha256:70dac4db1453a8555b522c856226fadee86534e0fc306dcb306cc2498aa6f4ed
```
把这个token复制保存下来，后面添加Node节点需要使用
```bash
kubeadm join 192.168.1.130:6443 --token 786rp5.ju4lmdf0g06i2pmi --discovery-token-ca-cert-hash sha256:70dac4db1453a8555b522c856226fadee86534e0fc306dcb306cc2498aa6f4ed
```
> 注意：不要照搬这个token,是你们自己的哦 

## 23、 在master继续执行以下步骤：
还有设置一下配置文件的环境变量master端：
```bash
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
export KUBECONFIG=/etc/kubernetes/admin.conf
```
如果安装失败，需要重装时。可以使用如下命令来清理环境
```bash
kubeadm reset
```
因为我们选择flannel作为Pod网络插件，所以上面的命令指定–pod-network-cidr=10.244.0.0/16。

## 24、 安装flannel网络：
```bash
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/bc79dd1505b0c8681ece4de4c0d86c5cd2643275/Documentation/kube-flannel.yml
```

## 25、执行以下命令 安装flannel网络：
```bash
[root@k8smaster ~]# kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/bc79dd1505b0c8681ece4de4c0d86c5cd2643275/Documentation/kube-flannel.yml
clusterrole.rbac.authorization.k8s.io/flannel created
clusterrolebinding.rbac.authorization.k8s.io/flannel created
serviceaccount/flannel created
configmap/kube-flannel-cfg created
daemonset.extensions/kube-flannel-ds-amd64 created
daemonset.extensions/kube-flannel-ds-arm64 created
daemonset.extensions/kube-flannel-ds-arm created
daemonset.extensions/kube-flannel-ds-ppc64le created
daemonset.extensions/kube-flannel-ds-s390x created
```

## 26、K8s node端：
Node端需要下载的镜像
```bash
docker pull mirrorgooglecontainers/kube-proxy-amd64:v1.13.2
docker pull mirrorgooglecontainers/pause-amd64:3.1
docker pull carlziess/coredns-1.2.6
```

## 27、给镜像打标签：
```bash
docker tag mirrorgooglecontainers/kube-proxy-amd64:v1.13.2 k8s.gcr.io/kube-proxy:v1.13.2
docker tag mirrorgooglecontainers/pause-amd64:3.1 k8s.gcr.io/pause:3.1
docker tag carlziess/coredns-1.2.6  k8s.gcr.io/coredns:1.2.6
```

## 28、node端：
```bash
yum install -y kubelet kubeadm kubectl
systemctl start kubelet
systemctl enable kubelet
systemctl status kubelet
systemctl status kubelet
```
添加nodoe端
```bash
[root@k8snode1 ~]# kubeadm join 192.168.1.130:6443 --token 786rp5.ju4lmdf0g06i2pmi --discovery-token-ca-cert-hash sha256:70dac4db1453a8555b522c856226fadee86534e0fc306dcb306cc2498aa6f4ed
[preflight] Running pre-flight checks
[WARNING Service-Kubelet]: kubelet service is not enabled, please run 'systemctl enable kubelet.service'
[discovery] Trying to connect to API Server "192.168.1.130:6443"
[discovery] Created cluster-info discovery client, requesting info from "https://192.168.1.130:6443"
[discovery] Requesting info from "https://192.168.1.130:6443" again to validate TLS against the pinned public key
[discovery] Cluster info signature and contents are valid and TLS certificate validates against pinned roots, will use API Server "192.168.1.130:6443"
[discovery] Successfully established connection with API Server "192.168.1.130:6443"
[join] Reading configuration from the cluster...
[join] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -oyaml'
[kubelet] Downloading configuration for the kubelet from the "kubelet-config-1.13" ConfigMap in the kube-system namespace
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
[kubelet-start] Activating the kubelet service
[tlsbootstrap] Waiting for the kubelet to perform the TLS Bootstrap...
[patchnode] Uploading the CRI Socket information "/var/run/dockershim.sock" to the Node API object "k8snode1" as an annotation

This node has joined the cluster:

* Certificate signing request was sent to apiserver and a response was received.

* The Kubelet was informed of the new secure connection details.

Run 'kubectl get nodes' on the master to see this node join the cluster.
```
然后在master端执行节点查看：
```bash
[root@k8smaster ~]# kubectl get nodes
NAME        STATUS   ROLES    AGE     VERSION
k8smaster   Ready    master   15m     v1.13.2
k8snode1    Ready    <none>   3m53s   v1.13.2
k8snode2    Ready    <none>   4m1s    v1.13.2
```