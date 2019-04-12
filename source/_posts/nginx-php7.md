---
title: Nginx+PHP7源码安装配置
date: 2018-03-19 21:36:12
tags:
categories:
- 设施
- 服务器
---
这是摘要

<!-- more -->

# 1. Nginx安装配置
如果需要一些特殊的功能，在包和端口不可用的情况下，也可以从源代码编译来安装nginx。虽然源代码编译安装更灵活，但这种方法对于初学者来说可能很复杂(建议初学者自己使用源代码编译安装来安装nginx)。有关更多信息，请参阅从源构建nginx。在本文中，主要介绍从源代码安装nginx，这篇教程是基于CentOS7 64bit系统来安装的，非Centos系统不适用。现在我们就开始吧！
## 1.1 安装前工作
首先更新系统软件源，使用以下命令更新系统
```bash
[root@localhost ~]# yum update
```
有关两个命令的一点解释：
yum -y update - 升级所有包，改变软件设置和系统设置,系统版本内核都升级
yum -y upgrade - 升级所有包，不改变软件设置和系统设置，系统版本升级，内核不改变
依赖包安装
```bash
[root@localhost src]# yum -y install gcc gcc-c++ autoconf automake libtool make cmake
[root@localhost src]# yum -y install zlib zlib-devel openssl openssl-devel pcre-devel
```
## 1.2. 下载Nginx安装源文件
源码下载，可官网下载地址：http://nginx.org/en/download.html 下载并上传到服务器(这里选择最新稳定版本：nginx-1.10.3)
或直接在服务上执行以下命令下载
```bash
[root@localhost ~]# cd /usr/local/src
[root@localhost src]# wget -c http://nginx.org/download/nginx-1.10.3.tar.gz
```
解压上面下载的文件
```bash
[root@localhost src]# tar zxvf nginx-1.10.3.tar.gz
```

在编译之前还要做一些前期的准备工作，如：依懒包安装，Nginx用户和用户组等
## 1.3. 新建nginx用户及用户组
使用 root 用户身份登录系统，执行以下命令创建新的用户。
```bash
[root@localhost src]# groupadd nginx
[root@localhost src]# useradd -g nginx -M nginx
```
useradd命令的-M参数用于不为nginx建立home目录
修改/etc/passwd，使得nginx用户无法bash登陆(nginx用户后面由/bin/bash改为/sbin/nologin)，
```bash
[root@localhost src]# vi /etc/passwd
```
然后找到有 nginx 那一行，把它修改为(后面由/bin/bash改为/sbin/nologin)：
```bash
nginx:x:1002:1003::/home/nginx:/sbin/nologin
```
## 1.4. 编译配置、编译、安装
下面我们进入解压的nginx源码目录：/usr/local/src/ 执行以下命令
```bash
[root@localhost ~]# cd /usr/local/src/nginx*
[root@localhost nginx-1.10.3]# pwd
/usr/local/src/nginx-1.10.3
[root@localhost nginx-1.10.3]#
[root@localhost nginx-1.10.3]# ./configure --prefix=/usr/local/nginx \
--pid-path=/usr/local/nginx/run/nginx.pid \
--with-http_ssl_module \
--user=nginx \
 --group=nginx \
--with-pcre \
--without-mail_pop3_module \
--without-mail_imap_module \
--without-mail_smtp_module
```
--prefix=/usr/local/nginx 指定安装到 /usr/local/nginx 目录下。
上面配置完成后，接下来执行编译
```
[root@localhost nginx-1.10.3]# make
[root@localhost nginx-1.10.3]# make install
... ...
cp conf/nginx.conf '/usr/local/nginx/conf/nginx.conf.default'
test -d '/usr/local/nginx/run' \
        || mkdir -p '/usr/local/nginx/run'
test -d '/usr/local/nginx/logs' \
        || mkdir -p '/usr/local/nginx/logs'
test -d '/usr/local/nginx/html' \
        || cp -R html '/usr/local/nginx'
test -d '/usr/local/nginx/logs' \
        || mkdir -p '/usr/local/nginx/logs'
make[1]: Leaving directory `/usr/local/src/nginx-1.10.3'
[root@localhost nginx-1.10.3]#
```
查看安装后的程序版本：
```bash
[root@localhost nginx-1.10.3]# /usr/local/nginx/sbin/nginx -v
nginx version: nginx/1.10.3
```
修改配置后验证配置是否合法
```bash
[root@localhost nginx-1.10.3]# /usr/local/nginx/sbin/nginx -t
nginx: the configuration file /usr/local/nginx/conf/nginx.conf syntax is ok
nginx: configuration file /usr/local/nginx/conf/nginx.conf test is successful
```
启动Nginx程序、查看进程 
```bash
[root@localhost nginx-1.10.3]# /usr/local/nginx/sbin/nginx
[root@localhost nginx-1.10.3]# ps -ef | grep nginx
root      29151      1  0 22:01 ?        00:00:00 nginx: master process /usr/local/nginx/sbin/nginx
nginx     29152  29151  0 22:01 ?        00:00:00 nginx: worker process
root      29154   2302  0 22:01 pts/0    00:00:00 grep --color=auto nginx
[root@localhost nginx-1.10.3]#
```
nginx停止、重启
未添加nginx服务前对nginx的管理只能通过一下方式管理
```bash
#  nginx 管理的几种方式 -
# 启动Nginx 
/usr/local/nginx/sbin/nginx 
# 从容停止Nginx：
kill -QUIT 主进程号 # 如上一步中的 ps 命令输出的 29151，就是 Nginx的主进程号
# 快速停止Nginx：
kill -TERM 主进程号
# 强制停止Nginx：
pkill -9 nginx
# 平滑重启nginx
/usr/nginx/sbin/nginx -s reload
```

现在我们来看看安装的Nginx的运行结果，可以简单地使用curl命令访问localhost测试，结果如下
```bash
[root@localhost nginx-1.10.3]# curl localhost
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
[root@localhost nginx-1.10.3]#
```
>提示： 如果没有看到以上界面，在确保Nginx启动的前提下，检查SeLinux和防火墙是否已关闭。关闭防火墙命令：systemctl stop firewalld.service

# 2. PHP7安装配置
## 2.1 源码下载
官网地址：php7下载
```bash
[root@localhost ~]# cd /usr/local/src
[root@localhost src]# wget -c http://cn2.php.net/distributions/php-7.1.3.tar.gz
```
解压压缩包：
```bash
[root@localhost src]# tar -xzvf php-7.*
[root@localhost src]# cd php-7*
```
## 2.2 安装编译所需依赖包
```bash
[root@localhost php-7.1.3]# yum -y install libxml2 libxml2-devel openssl openssl-devel curl-devel libjpeg-devel libpng-devel freetype-devel libmcrypt-devel
```
或者常见大部分依懒包安装
```bash
[root@localhost php-7.1.3]# yum install -y wget gcc gcc-c++ autoconf libjpeg libjpeg-devel perl perl* perl-CPAN libpng libpng-devel freetype freetype-devel libxml2 libxml2-devel zlib zlib-devel glibc glibc-devel glib2 glib2-devel bzip2 bzip2-devel ncurses ncurses-devel curl curl-devel e2fsprogs e2fsprogs-devel krb5 krb5-devel libidn libidn-devel openssl openssl-devel openldap openldap-devel nss_ldap openldap-clients openldap-servers png jpeg autoconf gcc cmake make gcc-c++ gcc ladp ldap* ncurses ncurses-devel zlib zlib-devel zlib-static pcre pcre-devel pcre-static openssl openssl-devel perl libtoolt openldap-devel libxml2-devel ntpdate cmake gd* gd2 ImageMagick-devel jpeg jpeg* pcre-dev* fontconfig libpng libxml2 zip unzip gzip
```

## 2.3 源码编译、安装
通过 ./configure –help 查看支持的编译配置参数，如下所示 
```bash
[root@localhost php-7.1.3]# ./configure --help
`configure' configures this package to adapt to many kinds of systems.

Usage: ./configure [OPTION]... [VAR=VALUE]...

To assign environment variables (e.g., CC, CFLAGS...), specify them as
VAR=VALUE.  See below for descriptions of some of the useful variables.

Defaults for the options are specified in brackets.

Configuration:
  -h, --helpdisplay this help and exit
      --help=short        display options specific to this package
      --help=recursive    display the short help of all the included packages
  -V, --versiondisplayversion information and exit
  -q, --quiet, --silent   do not print `checking ...' messages
      --cache-file=FILE   cache test results inFILE [disabled]
  -C, --config-cache      alias for `--cache-file=config.cache'
  -n, --no-create         do not create output files
      --srcdir=DIR        find the sources inDIR [configure dir or `..']

Installation directories:
  --prefix=PREFIX         install architecture-independent files in PREFIX
                          [/usr/local]
  --exec-prefix=EPREFIX   install architecture-dependent files in EPREFIX
                          [PREFIX]

By default, `make install' will install all the files in
`/usr/local/bin', `/usr/local/lib' etc.  You can specify
an installation prefix other than `/usr/local' using `--prefix',
for instance `--prefix=$HOME'.

For better control, use the options below.
```
PHP+Nginx组合的编译配置命令
```bash
[root@localhost php-7.1.3]# ./configure --prefix=/usr/local/php7 \
--with-config-file-path=/usr/local/php7/etc \
--with-config-file-scan-dir=/usr/local/php7/etc/php.d \
--with-mcrypt=/usr/include \
--enable-mysqlnd \
--with-mysqli \
--with-pdo-mysql \
--enable-fpm \
--with-fpm-user=nginx \
--with-fpm-group=nginx \
--with-gd \
--with-iconv \
--with-zlib \
--enable-xml \
--enable-shmop \
--enable-sysvsem \
--enable-inline-optimization \
--enable-mbregex \
--enable-mbstring \
--enable-ftp \
--enable-gd-native-ttf \
--with-openssl \
--enable-pcntl \
--enable-sockets \
--with-xmlrpc \
--enable-zip \
--enable-soap \
--without-pear \
--with-gettext \
--enable-session \
--with-curl \
--with-jpeg-dir \
--with-freetype-dir \
--enable-opcache

# 执行完成后的结果：
Generating files
configure: creating ./config.status
creating main/internal_functions.c
creating main/internal_functions_cli.c
+--------------------------------------------------------------------+
| License:                                                           |
| This software is subject to the PHP License, available in this     |
| distribution in the file LICENSE.  By continuing this installation |
| process, you are bound by the terms of this license agreement.     |
| If you do not agree with the terms of this license, you must abort |
| the installation process at this point.                            |
+--------------------------------------------------------------------+

Thank you for using PHP.

config.status: creating php7.spec
config.status: creating main/build-defs.h
config.status: creating scripts/phpize
config.status: creating scripts/man1/phpize.1
config.status: creating scripts/php-config
config.status: creating scripts/man1/php-config.1
config.status: creating sapi/cli/php.1
config.status: creating sapi/fpm/php-fpm.conf
config.status: creating sapi/fpm/www.conf
config.status: creating sapi/fpm/init.d.php-fpm
config.status: creating sapi/fpm/php-fpm.service
config.status: creating sapi/fpm/php-fpm.8
config.status: creating sapi/fpm/status.html
config.status: creating sapi/cgi/php-cgi.1
config.status: creating ext/phar/phar.1
config.status: creating ext/phar/phar.phar.1
config.status: creating main/php_config.h
config.status: executing default commands
```
编译 + 安装，编译源码, 如下所示
```bash
$ make
Generating phar.php
Generating phar.phar
PEAR package PHP_Archive not installed: generated phar will require PHP's phar extension be enabled.
directorytreeiterator.inc
pharcommand.inc
directorygraphiterator.inc
invertedregexiterator.inc
clicommand.inc
phar.inc

Build complete.
Don't forget to run 'make test'.

## 对编译结果进行测试：
[root@localhost php-7.1.3]# make test
## 很遗憾，我这里make test报错了，已反馈php test信息。

## 安装程序至指定目录：
[root@localhost php-7.1.3]# make install
Installing shared extensions:     /usr/local/php7/lib/php/extensions/no-debug-non-zts-20160303/
Installing PHP CLI binary:        /usr/local/php7/bin/
Installing PHP CLI man page:      /usr/local/php7/php/man/man1/
Installing PHP FPM binary:        /usr/local/php7/sbin/
Installing PHP FPM defconfig:     /usr/local/php7/etc/
Installing PHP FPM man page:      /usr/local/php7/php/man/man8/
Installing PHP FPM status page:   /usr/local/php7/php/php/fpm/
Installing phpdbg binary:         /usr/local/php7/bin/
Installing phpdbg man page:       /usr/local/php7/php/man/man1/
Installing PHP CGI binary:        /usr/local/php7/bin/
Installing PHP CGI man page:      /usr/local/php7/php/man/man1/
Installing build environment:     /usr/local/php7/lib/php/build/
Installing header files:          /usr/local/php7/include/php/
Installing helper programs:       /usr/local/php7/bin/
  program: phpize
  program: php-config
Installing man pages:             /usr/local/php7/php/man/man1/
  page: phpize.1
  page: php-config.1
/usr/local/src/php-7.1.3/build/shtool install -c ext/phar/phar.phar /usr/local/php7/bin
ln -s -f phar.phar /usr/local/php7/bin/phar
Installing PDO headers:           /usr/local/php7/include/php/ext/pdo/
[root@localhost php-7.1.3]#
```
查看安装成功后的版本信息
```bash
[root@localhost local]# /usr/local/php7/bin/php -v
PHP 7.1.3 (cli) (built: Apr 13 2017 22:47:30) ( NTS )
Copyright (c) 1997-2017 The PHP Group
Zend Engine v3.1.0, Copyright (c) 1998-2017 Zend Technologies
[root@localhost local]#
```

## 2.4. 修改配置
修改php配置，查看php加载配置文件路径：
```bash
[root@localhost local]# /usr/local/php7/bin/php -i | grep php.ini
Configuration File (php.ini) Path => /usr/local/php7/etc
[root@localhost local]#
```
php-7.1.3源码目录下
```bash
[root@localhost local]# ll /usr/local/src/php-7.1.3/ | grep ini
-rw-rw-r--.  1 yiibai yiibai   71063 Mar 14 09:17 php.ini-development
-rw-rw-r--.  1 yiibai yiibai   71095 Mar 14 09:17 php.ini-production
[root@localhost local]#
```
复制PHP的配置文件，使用以下命令
```bash
[root@localhost local]# cp /usr/local/src/php-7.1.3/php.ini-production /usr/local/php7/etc/php.ini
## 根据需要对`php.ini`配置进行配置修改，请自行参考官方文档配置 。
[root@localhost local]# /usr/local/php7/bin/php -i | grep php.ini
Configuration File (php.ini) Path => /usr/local/php7/etc
Loaded Configuration File => /usr/local/php7/etc/php.ini
[root@localhost local]#
```

## 2.5 启用php-fpm服务
上面我们在编译php7的时候，已经将fpm模块编译了，那么接下来，我们要启用php-fpm。但是默认情况下它的配置文件和服务都没有启用，所以要我们自己来配置，先重命名并移动以下两个文件
```bash
[root@localhost local]# cd /usr/local/php7/etc
[root@localhost etc]# cp php-fpm.conf.default php-fpm.conf
[root@localhost etc]# cp php-fpm.d/www.conf.default php-fpm.d/www.conf
```
php-fpm的具体配置这里不做深入去详解，因为在编译之前./configure的时候，我们都已经确定了一些配置，比如运行fpm的用户和用户组之类的，所以默认配置应该不会存在路径问题和权限问题。配置php-fpm的服务载入：
就像上面的nginx一样，我们希望使用 service php-fpm start|stop|restart 这些操作来实现服务的重启，但没有像nginx那么复杂，php编译好之后，给我们提供了一个php-fpm的程序。这个文件放在php编译源码目录中
```bash
[root@localhost local]#  cd /usr/local/src/php-7.1.3/sapi/fpm/
## 或直接使用可执行文件： /usr/local/php7/sbin/php-fpm
[root@localhost local]# ls
[root@localhost local]# cp init.d.php-fpm /etc/init.d/php-fpm
[root@localhost local]# chmod +x /etc/init.d/php-fpm
[root@localhost local]# chkconfig --add php-fpm
[root@localhost local]# chkconfig php-fpm on
```
通过上面这个操作，我们就可以使用 service php-fpm start 来启用php-fpm了。用 ps -ef | grep php-fpm看看进程吧。
```bash
[root@localhost fpm]# ps -ef | grep php-fpm
root     108421      1  0 23:19 ?        00:00:00 php-fpm: master process (/usr/local/php7/etc/php-fpm.conf)
nginx    108422 108421  0 23:19 ?        00:00:00 php-fpm: pool www
nginx    108423 108421  0 23:19 ?        00:00:00 php-fpm: pool www
root     108507   2285  0 23:23 pts/0    00:00:00 grep --color=auto php-fpm
[root@localhost fpm]#
```
这样，PHP环境就安装完成了，接下来我们通过Nginx代理集成PHP7，来实现Nginx+PHP服务。

# 3. Nginx代理集成PHP7配置
通过上面的操作，nginx和php-fpm服务都已经正常运行起来了，但是php-fpm只是在127.0.0.1:9000上提供服务，外网是无法访问的，而且也不可能直接通过php-fpm给外网提供服务，因此需要使用nginx去代理9000端口执行php。
实际上这个过程只需要对nginx进行配置即可，php-fpm已经在后台运行了，我们需要在nginx的配置文件中增加代理的规则，即可让用户在访问80端口，请求php的时候，交由后端的php-fpm去执行，并返回结果。现在编辑Nginx的配置文件
```bash
[root@localhost local]# vi /usr/local/nginx/conf/nginx.conf
```

如果你大致了解过nginx的配置，应该能够很快分辨出这个配置文件里面的结构，并且知道server块代表一个虚拟主机，要增加虚拟主机就再增加一个server块，而且这个conf文件中也给出了例子。那么怎么代理php-fpm呢？找到
```conf
#location ~ \.php$ {
#   root           html;
#  fastcgi_pass   127.0.0.1:9000;
#  fastcgi_index  index.php;
#  fastcgi_param  SCRIPT_FILENAME  /script$fastcgi_script_name;
#  include        fastcgi_params;
#}
```
把前面的#注释符号去掉，把script改为$document_root最终如下
```bash
location ~ \.php$ {
            root           html;
            fastcgi_pass   127.0.0.1:9000;
            fastcgi_index  index.php;
            fastcgi_param  SCRIPT_FILENAME  /usr/local/nginx/html/$fastcgi_script_name;
            include        fastcgi_params;
        }
```
这样就可以了，重新载入nginx配置即可，使用以下命令 
```bash
/usr/local/nginx/sbin/nginx -s reload
```
然后到/usr/local/nginx/html去写一个php文件：index.php进行测试，文件：index.php的代码如下
```php
<?php
    phpinfo();
?>
```
附完整的Nginx配置(/usr/local/nginx/conf/nginx.conf)文件内容：
```conf
#user  nobody;
worker_processes  1;

#error_log  logs/error.log;
#error_log  logs/error.log  notice;
#error_log  logs/error.log  info;

#pid        logs/nginx.pid;


events {
    worker_connections  1024;
}


http {
    include       mime.types;
    default_type  application/octet-stream;

    #log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
    #                  '$status $body_bytes_sent "$http_referer" '
    #                  '"$http_user_agent" "$http_x_forwarded_for"';

    #access_log  logs/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    #keepalive_timeout  0;
    keepalive_timeout  65;

    #gzip  on;

    server {
        listen       80;
        server_name  localhost;

        #charset koi8-r;

        #access_log  logs/host.access.log  main;

        location / {
            root   html;
            index  index.html index.html;
        }

        #error_page  404              /404.html;

        # redirect server error pages to the static page /50x.html
        #
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }

        # proxy the PHP scripts to Apache listening on 127.0.0.1:80
        #
        #location ~ \.php$ {
        #    proxy_pass   http://127.0.0.1;
        #}

        # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
        #
        #location ~ \.php$ {
        #    root           html;
        #    fastcgi_pass   127.0.0.1:9000;
        #    fastcgi_index  index.php;
        #    fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;
        #    include        fastcgi_params;
        #}

        # deny access to .htaccess files, if Apache's document root
        # concurs with nginx's one
        #
        #location ~ /\.ht {
        #    deny  all;
        #}
    }


    # another virtual host using mix of IP-, name-, and port-based configuration
    #
    #server {
    #    listen       8000;
    #    listen       somename:8080;
    #    server_name  somename  alias  another.alias;

    #    location / {
    #        root   html;
    #        index  index.html index.html;
    #    }
    #}


    # HTTPS server
    #
    #server {
    #    listen       443 ssl;
    #    server_name  localhost;

    #    ssl_certificate      cert.pem;
    #    ssl_certificate_key  cert.key;

    #    ssl_session_cache    shared:SSL:1m;
    #    ssl_session_timeout  5m;

    #    ssl_ciphers  HIGH:!aNULL:!MD5;
    #    ssl_prefer_server_ciphers  on;

    #    location / {
    #        root   html;
    #        index  index.html index.html;
    #    }
    #}

}
```