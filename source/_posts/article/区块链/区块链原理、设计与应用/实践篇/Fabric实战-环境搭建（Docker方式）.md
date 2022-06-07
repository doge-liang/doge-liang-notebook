---
title: Fabric实战-环境搭建（Docker方式）
date: 2021-03-13
tags: [Hyperledger Fabric]
categories:
  - 区块链
  - 《区块链设计、原理与应用》
  - 实践篇
---

## Fabric 实战-环境搭建（Docker 方式）

### 安装 Docker

> 确保 Linux 内核在 3.2 以上，以及依赖已经更新。

卸载旧的 docker：

```BASH
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

获取 docker 官方 GPG：

```BASH
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
```

由于国内网络环境，以上方法有可能不成功，可以通过科学手段访问链接，直接下载 GPG 文件，然后手动 add

```BASH
sudo apt-key add [gpg path]
```

设置稳定的存储库：

```BASH
sudo add-apt-repository \
"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable"
```

`$(lsb_release -cs)` 代表了当前发行版的 codename 这里用的是 `bionic` 所以改成 `bionic` 也可以。

> curl 参照：<https://blog.csdn.net/huangzx3/article/details/80625080>

更新源并安装 docker-ce

```BASH
sudo apt update && sudo apt install -y docker-ce
docker --version
```

测试 docker 安装情况：

```BASH
sudo docker run hello-world
```

由于国内的网络环境，为了加快拉取镜像的速度，需要将官方镜像源换成国内的：

```BASH
sudo vim /etc/docker/daemon.json
```

输入以下内容：

```json
{
  "registry-mirrors": [
    "https://registry.docker-cn.com",
    "http://hub-mirror.c.163.com",
    "https://docker.mirrors.ustc.edu.cn"
  ]
}
```

重载重启 docker 以应用设置：

```BASH
sudo systemctl daemon-reload
sudo systemctl restart docker
```

### 安装 docker-composer

```BASH
# 安装 pip
sudo apt install python-pip
# 更新 pip
sudo pip install --upgrade pip
# 安装 docker-composer
sudo pip install docker-compose

# 如果报错了就用 pip3
sudo apt install pip3
sudo pip3 install --upgrade pip
sudo pip3 install docker-compose
```

### 获取 Docker 镜像

fabric 相关的镜像有十几个，可以氛围三大类：核心镜像、辅助镜像和第三方镜像。

核心镜像提供 Fabric 网络运行的核心功能，包括：

- **fabric-Peer**
- **fabric-orderer**
- **fabric-ca**
- fabric-baseos
- fabric-ccenv
- fabric-javaenv
- fabric-nodeenv

前三个是 Fabric 的核心组件镜像； baseos 是用来生成其他镜像的基础镜像，并作为 Go 链码的默认运行环境； ccenv 、 javaenv 、 nodeenv 三个分别是 Go 、 java 、 node.js 语言的链码支持基础镜像，也是三种语言的链码的运行环境镜像。

辅助镜像提供支持功能，包括 fabric-baseimage 、 fabric-tools 、 镜像。

- fabric-baseimage
- fabric-tools

baseimage 是基础镜像，安装了 wget 、 Golang 、 Node.js 、 Python 、 Protocol buffer 支持等，可以用来生成其他镜像，运行时可以用来生成 Node.js 链码镜像。
tools 安装了 bash 、 jq 、 peer 、 cryptogen 、 configtxgen 等常见命令，可以用来测试客户端来使用。

第三方镜像是为一些开源的第三方软件提供支持功能，包括：

- fabric-couchdb
- fabric-kafka
- fabric-zookeeper

以上镜像除了 couchdb 以外，其余的都在 2.x 版本停用了。

#### 从 Dokerhub 获取镜像

```BASH
ARCH=amd64
BASEIMAGE_RELEASE=0.4.18
LATEST=latest
CA_RELEASE=1.5
PROJECT_VERSION=2.0.0
TWO_DIGIT_VERSION=2.0

sudo docker pull hyperledger/fabric-peer:$LATEST \
&& sudo docker pull hyperledger/fabric-orderer:$LATEST \
&& sudo docker pull hyperledger/fabric-ca:$LATEST \
&& sudo docker pull hyperledger/fabric-tools:$LATEST \
&& sudo docker pull hyperledger/fabric-ccenv:$LATEST \
&& sudo docker pull hyperledger/fabric-baseimage:$LATEST \
&& sudo docker pull hyperledger/fabric-baseos:$LATEST
```

#### 使用 Dockerfile 生成镜像

待更新。。。
