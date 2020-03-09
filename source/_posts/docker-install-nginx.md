---
title: docker-install-nginx
categories:
  - 开源
date: 2019-08-04 20:33:50
tags:
- 容器
---
docker安装nginx的步骤
<!-- more -->
# 一、docker pull命令安装
查找docker hub上的nginx镜像
```bash
[root@master ~]# docker search nginx
NAME                              DESCRIPTION                                     STARS               OFFICIAL            AUTOMATED
nginx                             Official build of Nginx.                        11778               [OK]                
jwilder/nginx-proxy               Automated Nginx reverse proxy for docker con…   1635                                    [OK]
richarvey/nginx-php-fpm           Container running Nginx + PHP-FPM capable of…   731                                     [OK]
linuxserver/nginx                 An Nginx container, brought to you by LinuxS…   72                                      
bitnami/nginx                     Bitnami nginx Docker Image                      69                                      [OK]
tiangolo/nginx-rtmp               Docker image with Nginx using the nginx-rtmp…   51                                      [OK]
jc21/nginx-proxy-manager          Docker container for managing Nginx proxy ho…   21                                      
nginx/nginx-ingress               NGINX Ingress Controller for Kubernetes         20                                      
nginxdemos/hello                  NGINX webserver that serves a simple page co…   20                                      [OK]
jlesage/nginx-proxy-manager       Docker container for Nginx Proxy Manager        20                                      [OK]
schmunk42/nginx-redirect          A very simple container to redirect HTTP tra…   17                                      [OK]
crunchgeek/nginx-pagespeed        Nginx with PageSpeed + GEO IP + VTS + more_s…   13                                      
blacklabelops/nginx               Dockerized Nginx Reverse Proxy Server.          12                                      [OK]
centos/nginx-18-centos7           Platform for running nginx 1.8 or building n…   11                                      
centos/nginx-112-centos7          Platform for running nginx 1.12 or building …   10                                      
nginxinc/nginx-unprivileged       Unprivileged NGINX Dockerfiles                  9                                       
sophos/nginx-vts-exporter         Simple server that scrapes Nginx vts stats a…   5                                       [OK]
1science/nginx                    Nginx Docker images that include Consul Temp…   5                                       [OK]
nginx/nginx-prometheus-exporter   NGINX Prometheus Exporter                       5                                       
mailu/nginx                       Mailu nginx frontend                            3                                       [OK]
pebbletech/nginx-proxy            nginx-proxy sets up a container running ngin…   2                                       [OK]
travix/nginx                      NGinx reverse proxy                             2                                       [OK]
centos/nginx-110-centos7          Platform for running nginx 1.10 or building …   0                                       
wodby/nginx                       Generic nginx                                   0                                       [OK]
ansibleplaybookbundle/nginx-apb   An APB to deploy NGINX     
```
我们拉取官方镜像nginx
```bash
$ docker pull nginx
```
等待下载完成之后，我们就可以在本地镜像列表查找到REPOSITORY 为 nginx 的镜像。
```bash
[root@master ~]# docker images nginx
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
nginx               latest              e445ab08b2be        11 days ago         126MB
```
以下命令使用nginx的默认配置启动一个nginx的实例。
```bash
$ docker run --name nginx-test -p 8081:80 -d nginx
```
* nginx-test为容器实例的名称
* -d 设置容器一直在后台运行
* -p 设置端口映射，将本地8081映射到容器内部80

执行以上命令返回一串字符串，类似类似 6dd4380ba70820bd2acc55ed2b326dd8c0ac7c93f68f0067daecad82aef5f938，代表容器ID。
我们可以使用命令docker ps查看容器的运行状态：
```bash
$ docker ps
CONTAINER ID        IMAGE        ...               PORTS                  NAMES
6dd4380ba708        nginx        ...      0.0.0.0:8081->80/tcp   runoob-nginx-test
```
## 复制容器内到文件到本地
```bash
docker cp 6dd4380ba708:/etc/nginx/nginx.conf ~/nginx/conf
```
# 二、通过 Dockerfile 构建
首先要创建一个Dockerfile文件
```dockerfile
FROM nginx
```
然后就可以创建镜像
```bash
# docker build -t nginx-test .
```
后面步骤跟从官方镜像库获取镜像后操作一样
# 三、我们可知查看docker帮助文件
```bash
[root@master ~]# docker

Usage:	docker [OPTIONS] COMMAND

A self-sufficient runtime for containers

Options:
      --config string      Location of client config files (default "/root/.docker")
  -D, --debug              Enable debug mode
  -H, --host list          Daemon socket(s) to connect to
  -l, --log-level string   Set the logging level ("debug"|"info"|"warn"|"error"|"fatal") (default "info")
      --tls                Use TLS; implied by --tlsverify
      --tlscacert string   Trust certs signed only by this CA (default "/root/.docker/ca.pem")
      --tlscert string     Path to TLS certificate file (default "/root/.docker/cert.pem")
      --tlskey string      Path to TLS key file (default "/root/.docker/key.pem")
      --tlsverify          Use TLS and verify the remote
  -v, --version            Print version information and quit

Management Commands:
  config      Manage Docker configs
  container   Manage containers
  image       Manage images
  network     Manage networks
  node        Manage Swarm nodes
  plugin      Manage plugins
  secret      Manage Docker secrets
  service     Manage services
  stack       Manage Docker stacks
  swarm       Manage Swarm
  system      Manage Docker
  trust       Manage trust on Docker images
  volume      Manage volumes

Commands:
  attach      Attach local standard input, output, and error streams to a running container
  build       Build an image from a Dockerfile
  commit      Create a new image from a container’s changes
  cp          Copy files/folders between a container and the local filesystem
  create      Create a new container
  diff        Inspect changes to files or directories on a container’s filesystem
  events      Get real time events from the server
  exec        Run a command in a running container
  export      Export a container’s filesystem as a tar archive
  history     Show the history of an image
  images      List images
  import      Import the contents from a tarball to create a filesystem image
  info        Display system-wide information
  inspect     Return low-level information on Docker objects
  kill        Kill one or more running containers
  load        Load an image from a tar archive or STDIN
  login       Log in to a Docker registry
  logout      Log out from a Docker registry
  logs        Fetch the logs of a container
  pause       Pause all processes within one or more containers
  port        List port mappings or a specific mapping for the container
  ps          List containers
  pull        Pull an image or a repository from a registry
  push        Push an image or a repository to a registry
  rename      Rename a container
  restart     Restart one or more containers
  rm          Remove one or more containers
  rmi         Remove one or more images
  run         Run a command in a new container
  save        Save one or more images to a tar archive (streamed to STDOUT by default)
  search      Search the Docker Hub for images
  start       Start one or more stopped containers
  stats       Display a live stream of container(s) resource usage statistics
  stop        Stop one or more running containers
  tag         Create a tag TARGET_IMAGE that refers to SOURCE_IMAGE
  top         Display the running processes of a container
  unpause     Unpause all processes within one or more containers
  update      Update configuration of one or more containers
  version     Show the Docker version information
  wait        Block until one or more containers stop, then print their exit codes

Run ’docker COMMAND --help’ for more information on a command.
```

