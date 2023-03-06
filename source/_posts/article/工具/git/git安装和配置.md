---
title: git安装和配置
tags: []
categories:
  - article
  - 工具
  - git
date: 2021-03-23 00:00:00
---

## git 安装和配置

### 安装

```BASH
sudo apt install git
```

### 初次配置

```BASH
git config --global user.name "doge-liang"
git config --global user.email "1542640147@qq.com"
```

这里配置的用户名和密码属于不是 github.com 的用户名和密码，而是提交的时候，展示给仓库所有者查看的密码用户名和邮箱。

如果 github 账户设置了 ssh 密钥的话，可以在本地生成一下 ssh-key

步骤参照 git-ssh

### 控制台显示问题

#### `git status` 中文编码问题

```bash
git config --global core.quotepath false
```
