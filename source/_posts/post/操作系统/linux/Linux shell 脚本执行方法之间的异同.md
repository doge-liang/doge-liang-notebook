---
title: Linux shell 脚本执行方法之间的异同
date: 2021-03-30
tags: []
categories:
  - 操作系统
  - linux
---

## Linux shell 脚本执行方法之间的异同

Linux shell 脚本的执行方式有很多，比如 `source <bash path>` 、 `sh|bash <bash path>` 、 `. <bash path>` 等等。

这些执行方式分为两类：

1. 开启子 shell 执行脚本；
2. 以当前 shell 作为环境执行脚本；

如果以子 shell 的方式执行脚本，那么父 shell 脚本定义的环境变量（未 export 的）是不会被子 shell 继承的；

- `./*.sh` 的执行方式等价于 `sh ./*.sh` 或者 `bash ./*.sh` ，此三种执行脚本的方式都是重新启动一个子 shell ，在子 shell 中执行此脚本。
- `source ./*.sh` 和 `. ./*.sh` 的执行方式是等价的，即两种执行方式都是在当前 shell 进程中执行此脚本，而不是重新启动一个 shell 而在子 shell 进程中执行此脚本。
