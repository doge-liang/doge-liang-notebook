---
title: Fabric实战
date: 2020-05-15
tags: [区块链概述, Hyperledger, Fabric实战]
categories: 
    - [区块链]
    - [Hyperledger]
---
# Fabric 环境搭建实战

简单说说 Fabric：
- HyperLegder 下的
- 模块化架构的
- 分布式的账本解决方案**平台**
特点是：
- 深度加密
- 便捷扩展
- 灵活部署（基于 Docker）
- 可插拔（定制化）

## 实验环境

```shell
ubuntu@ip-172-31-37-31:~$ head -n 1 /etc/issue
Ubuntu 18.04.4 LTS \n \l
ubuntu@ip-172-31-37-31:~$ uname -r
5.3.0-1019-aws
```

## 基本环境部署

## 安装工具包
```shell
sudo apt-get install -y apt-transport-https ca-certificates software-properties-common 
sudo apt-get install -y unzip git  curl wget vim tree jq
```

### 安装 Docker

> 确保 Linux 内核在 3.2 以上，以及依赖已经更新。

卸载旧的 docker

```shell
sudo apt-get remove docker \
        docker-client \
        docker-client-latest \
        docker-common \
        docker-latest \
        docker-latest-logrotate \
        docker-logrotate \
        docker-selinux \
        docker-engine-selinux \
        docker-engine
```

设置稳定的存储库
```shell
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable"
```
> curl 参照：https://blog.csdn.net/huangzx3/article/details/80625080

更新源并安装 docker-ce
```shell
sudo apt-get update & sudo apt-get install -y docker-ce
docker --version
```

