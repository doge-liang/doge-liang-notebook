---
title: git ssh 协议出现 22 端口拒绝连接
tags: []
categories:
  - article
  - 工具
  - git
date: 2022-06-06 00:00:00
---

## git ssh 协议出现 22 端口拒绝连接

### 出现问题

```BASH
> git push
ssh: connect to host github.com port 22: Connection refused
fatal: Could not read from remote repository.

Please make sure you have the correct access rights
and the repository exists.
```

### 问题分析及解决

通过 `ssh` 命令直接访问 `git@github.com` 检查连通性；

```BASH
> ssh -vT git@github.com

OpenSSH_for_Windows_8.1p1, LibreSSL 3.0.2
debug1: Connecting to github.com [127.0.0.1] port 22.
debug1: connect to address 127.0.0.1 port 22: Connection refused
ssh: connect to host github.com port 22: Connection refused
```

发现 `github.com` 被映射到 `127.0.0.1` 了，猜测是开启了科学上网导致的，顺势给 git 配置代理，以提升推拉代码速度；

在 `C:\User\Administrator\.ssh` 目录下建立 `config` 文件，输入如下内容：

```BASH
# 代理的地址按照自己的工具来配置，这里是 127.0.0.1:10808
ProxyCommand connect -S 127.0.0.1:10808 -a none %h %p

Host github.com
        User doge-liang
        Port 22
        Hostname github.com
        # 路径使用自己的 ssh private key
        IdentityFile "C:\Users\Administrator\.ssh\id_rsa"
        TCPKeepAlive yes
```

保存后即可连通；

### 类似问题

科学上网之后，使用 https 的方式推送代码也无法推送，猜测是同样的原因导致的。 https 的代理设置和 ssh 不同；
只要设置 `git config` 即可

```BASH
git config --global http.proxy http://127.0.0.1:10809
git config --global https.proxy http://127.0.0.1:10809

# 取消设置
git config --global --unset http.proxy
git config --global --unset https.proxy
```
