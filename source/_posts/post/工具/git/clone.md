---
title: clone
date: 2021-03-25
tags: []
categories:
  - 工具
  - git
---

- [clone](#clone)
  - [参数以及用法](#参数以及用法)
  - [常用用法](#常用用法)

## clone

### 参数以及用法

### 常用用法

- 项目版本迭代过多，为了加快拉取速度只拉取最新版本

```BASH
git clone --depth 1 https://github.com/aaa.git
```

- 显示详细拉取过程的详细信息

```BASH
git clone https://github.com/aaa.git --progress --verbose
```

- 克隆某个指定版本的仓库

```BASH
# 如果是使用 tag 来区分版本可以这样 clone
# 他会新建一个 branch ，目的是为了防止游离的 HEAD
git clone --branch v0.35.3 https://github.com/nvm-sh/nvm.git
# 如果是使用 branch 来区分版本可以这样 clone ，他只会拉取那个分支的代码
git clone -b release-2.2 https://github.com/hyperledger/fabric.git
# 也可以直接 clone 整个项目然后通过 checkout -b 来切换版本分支
git clone https://github.com/example.git
git checkout -b release-2.2
git branch -a # 查看分支所在的版本
```
