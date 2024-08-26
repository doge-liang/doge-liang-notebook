---
title: docker容器部署错误分析
tags: []
categories:
  - article
  - 计算机
  - 工具
  - docker
date: 2021-04-07 00:00:00
---

## docker 容器部署错误分析

今天用 docker-compose 部署 Hyperledger Fabric 网络的时候， peer1.subscriber.mynetwork.com 容器出现了 Exited(1) 的错误。

使用 `docker logs <container_name>` 命令，列出了这个容器的日志

```code
2021-04-07 03:49:03.657 UTC [main] InitCmd -> ERRO 001 Cannot run peer because error when setting up MSP of type bccsp from directory /etc/hyperledger/fabric/msp: administrators must be declared when no admin ou classification is set
```

查看 `/etc/hyperledger/fabric/msp` 目录挂载在哪里，将目录结构和另一个成功启动的节点对比，发现少了一个 `msp/config.yaml` 文件，然后将 `config.yaml` 文件从外面的 `msp` 目录复制进来就好了，像另一个节点那样操作。
