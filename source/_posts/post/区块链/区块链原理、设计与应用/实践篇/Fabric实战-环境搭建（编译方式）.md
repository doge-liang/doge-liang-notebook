---
title: Fabric实战-环境搭建（编译方式）
date: 2020-05-15
tags: [Hyperledger Fabric]
categories:
  - 区块链
  - 《区块链设计、原理与应用》
  - 实践篇
---

## Fabric 环境搭建

简单说说 Fabric：

- HyperLegder 下的
- 模块化架构的
- 分布式的账本解决方案**平台**
  特点是：
- 深度加密
- 便捷扩展
- 灵活部署（基于 Docker）
- 可插拔（定制化）

这次实验使用的是二进制源码编译的方式安装 Fabric 。

### 实验机器

VirtualBox 的 Ubuntu 18.04.5 LTS 虚拟机

### 基本环境部署

主要是 Go 语言环境和 Docker 容器，因为 fabric 是 Go 语言实现的，而 Docker 用于在一台虚拟机中搭建多个独立的环境，让 Peer 节点可以在其中运行，组成区块链网络。

#### 安装工具包

HTTPS 访问依赖：

```BASH
sudo apt install -y apt-transport-https ca-certificates software-properties-common
```

解压缩工具、git（代码版本管理）、curl（文件传输）、vim（编辑器）、jq（JSON 解析器）、 tree （路径树查看器）安装：

```BASH
sudo apt install -y unzip git curl vim jq tree
```

#### GO 语言环境搭建

使用 `curl` 命令下载

```BASH
curl -O https://dl.google.com/go/go1.13.4.linux-amd64.tar.gz
```

如果由于网络环境无法下载成功，则去[go 语言中文网](https://studygolang.com/dl)下载压缩包
解压

```BASH
sudo tar -xvf go1.14.15.linux-amd64.tar.gz -C /usr/local
```

创建工作环境

```BASH
sudo mkdir -p /opt/goworkspace/bin
sudo mkdir -p /opt/goworkspace/src
sudo mkdir -p /opt/goworkspace/pkg
```

设置环境变量

```BASH
sudo vim /etc/profile
```

追加以下内容到文件末尾：

```BASH
export GOROOT=/usr/local/go
export GOPATH=/opt/goworkspace
export PATH=$GOROOT/bin:$PATH
```

应用环境变量：

```BASH
source /etc/profile
```

设置代理，（如果网络环境没问题可以不用设置）

```BASH
go env -w GO111MODULE=on
go env -w GOPROXY=https://mirrors.aliyun.com/goproxy/
```

`GO111MODULE` 选项打开之后，`go install` 命令可能无法使用，所以如果使用 `go install` 命令编译源码包，就要关闭 `GO111MODULE` 。后面需要使用代理进行 `go get` 就又要打开 `GO111MODULE` 。

<!-- 启动 go module

``` BASH
export GO111MODULE=on
``` -->

#### 安装 Docker

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

##### curl 下载脚本一键安装

其实这个脚本要完成的工作就是官方推荐的下载步骤，包含了一系列脚本。

```BASH
curl -fsSL https://get.docker.com/ | sh
```

##### 官方推荐的下载方法

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
  "registry-mirrors": ["https://docker.mirrors.ustc.edu.cn"]
}
```

重载重启 docker 以应用设置：

```BASH
sudo systemctl daemon-reload
sudo systemctl restart docker
```

> 由于美国的制裁，中国很多公司或组织提供的镜像源无法使用了，最后都会连接到 Docker-Hub 上……暂时没有好的办法。找到了一个测试镜像站点的项目，会定期检测哪些镜像站还有用，<https://github.com/docker-practice/docker-registry-cn-mirror-test> 点击 `Action` 可以查看近期有哪些镜像还有用。这本书蛮 nb 的 <https://github.com/yeasy/docker_practice>

### 获取 fabric 代码

创建 fabric 代码仓库目录：

```BASH
sudo mkdir -p $GOPATH/src/github.com/hyperledger
cd $GOPATH/src/github.com/hyperledger
```

获取 fabric 代码：

```BASH
# fabric
sudo git clone https://github.com/hyperledger/fabric.git
# fabric-ca
sudo git clone https://github.com/hyperledger/fabric-ca.git
```

使用哪个版本的 Fabric 就要 checkout 到哪个发行版的分支，我这里使用的是 release-2.0 ：

```BASH
git checkout release-2.0
```

### 编译安装 Peer 组件

配置版本号和编译参数：

```BASH
PROJECT_VERSION=2.0.0

LD_FLAGS="-X github.com/hyperledger/fabric/common/metadata.Version=${PROJECT_VERSION} \
-X github.com/hyperledger/fabric/common/metadata.BaseDockerLabel=org.hyperledger.fabric \
-X github.com/hyperledger/fabric/common/metadata.DockerNamespace=hyperledger \
-X github.com/hyperledger/fabric/common/metadata.BaseDockerNamespace=hyperledger"
```

编译并安装 Peer 组件到 `$GOPATH/bin` 下：

```BASH
CGO_CFLAGS=" "
go install -tags "" -ldflags "$LD_FLAGS" \
github.com/hyperledger/fabric/cmd/peer
```

这里我遇到了移动文件被拒绝的问题，猜测是权限问题，通过 `su root` 命令，暂时性使用 root 用户权限，可以成功安装。切换用户之后不要忘了重新设定编译参数和版本号，还要重新使用 `source /etc/profile` 命令应用 go 环境变量，否则会提示没有 `go` 命令。

### 编译安装 Orderer 组件

```BASH
CGO_CFLAGS=" "
go install -tags "" -ldflags "$LD_FLAGS" \
github.com/hyperledger/fabric/cmd/orderer
```

这里同样遇到了 `permission denied` 的问题，同样是切换到 `root` 用户执行代码解决。

### 编译安装 fabric-ca

从源码编译安装 fabric-ca：

```BASH
go install -ldflags \
"-X github.com/hyperledger/fabric-ca/lib/metadata.Version=$PROJECT_VERSION \
-linkmode external \
-extldflags '-static -lpthread'" \
github.com/hyperledger/fabric-ca/cmd/...
```

这里的命令很长，很容易不小心打错，复制是最好的。多打了一个字母 t 浪费了我一个下午的时间……晕死

### 编译安装配置辅助工具

- cryptogen：本地生成组织结构和身份文件；
- configtxgen：生成配置区块和配置交易；
- configtxlator：解析转换配置信息；
- discover：拓扑探测；
- idemixgen：Idemix 证书生成；

```BASH
# 编译安装 cryptogen，等价于执行 make cryptogen
CGO_CFLAGS=" " \
  go install -tags "" -ldflags "$LD_FLAGS" \
  github.com/hyperledger/fabric/cmd/cryptogen
# 编译安装 cryptogen，等价于执行 make configtxgen
CGO_CFLAGS=" " \
  go install -tags "" -ldflags "$LD_FLAGS" \
  github.com/hyperledger/fabric/cmd/configtxgen
# 编译安装 cryptogen，等价于执行 make configtxlator
CGO_CFLAGS=" " \
  go install -tags "" -ldflags "$LD_FLAGS" \
  github.com/hyperledger/fabric/cmd/configtxlator
# 编译安装 cryptogen，等价于执行 make discover
CGO_CFLAGS=" " \
  go install -tags "" -ldflags "$LD_FLAGS" \
  github.com/hyperledger/fabric/cmd/discover
# 编译安装 cryptogen，等价于执行 make idemixgen
CGO_CFLAGS=" " \
  go install -tags "" -ldflags "$LD_FLAGS" \
  github.com/hyperledger/fabric/cmd/idemixgen
```

### 安装 Protobuf 支持和 Go 语言相关工具

```BASH
go get github.com/golang/protobuf/protoc-gen-go \
#   && go get github.com/maxbrunsfeld/counterfeiter \
  && go get github.com/axw/gocov/... \
  && go get github.com/AlekSi/gocov-xml \
  && go get golang.org/x/tools/cmd/goimports \
  && go get golang.org/x/lint/golint \
#   && go get github.com/estesp/manifest-tool \
  && go get github.com/client9/misspell/cmd/misspell \
  && go get github.com/onsi/ginkgo/ginkgo
```

出现错误：

```BASH
unrecognized import path "google.golang.org/protobuf/compiler/protogen": https fetch: Get "https://google.golang.org/protobuf/compiler/protogen?go-get=1": dial tcp 216.239.37.1:443: i/o timeout
unrecognized import path "google.golang.org/protobuf/types/descriptorpb": https fetch: Get "https://google.golang.org/protobuf/types/descriptorpb?go-get=1": dial tcp 216.239.37.1:443: i/o timeout
unrecognized import path "google.golang.org/protobuf/cmd/protoc-gen-go/internal_gengo": https fetch: Get "https://google.golang.org/protobuf/cmd/protoc-gen-go/internal_gengo?go-get=1": dial tcp 216.239.37.1:443: i/o timeout
```

这里就是因为没有使用 go 代理进行下载，所以才出现了 `timeout` 错误。

配置代理打开了 `GO111MODULE` 之后，仍然出现错误：

```BASH
go get github.com/maxbrunsfeld/counterfeiter: github.com/maxbrunsfeld/counterfeiter@v6.3.0: reading https://mirrors.aliyun.com/goproxy/github.com/maxbrunsfeld/counterfeiter/@v/v6.3.0.info: 404 Not Found
```

逐一调试发现上面注释掉的两个包下不了，下不了就下不了吧……暂时不管他，如果服务器在境外就能够正常下载了吧……

### 示例配置

在 `$GOPATH/src/github.com/hyperledger/fabric/sampleconfig` 下有几个示例配置文件，可以将他们移动到默认配置目录 `/etc/hyperledger/fabric` 下进行使用

- configtx.yaml：示例配置区块生成文件；
- orderer.yaml：示例排序节点配置文件；
- core.yaml：示例 Peer 节点配置文件；
- msp/config.yaml：示例组织身份配置文件；
- msp/：存放示例证书和私钥文件；

到此为止，通过编译的方式安装 fabric 已经完成了。
上面的配置过程参考了多篇博客，中间遇到许多问题，都是通过检索得到的解决方案。主要配置过程参考的是 《区块链原理、设计与应用》 这本书。
