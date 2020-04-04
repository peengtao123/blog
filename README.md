# blog

## Install the admin & start things up

```bash
npm install --save hexo-admin
hexo server -d
open http://localhost:4000/admin/
```
# 部署问题
## Cannot parse privateKey: Unsupported key format
ssh-keygen -m PEM -t rsa 
## 拉取指定标签内容
```bash
git clone --branch [tags标签] [git地址]
```
## 免密登录
```sh
ssh-copy-id -i root@47.89.13.13
```