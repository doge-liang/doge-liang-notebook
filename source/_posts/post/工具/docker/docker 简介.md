---
title: docker 简介
date: 2021-03-27
tags: []
categories: 
    - 工具
    - docker
---

## docker 简介

## 简介

docker是一个容器，可以将应用打包安装在这个容器内，使得即使在不同的系统环境中也能使用；

## docker vs. VM

![picture 1](../../../../assets/%E5%B7%A5%E5%85%B7/docker/docker%20%E7%AE%80%E4%BB%8B/a501dbf474a0f9f65bd80babb718fb91427ad5dd82022ae4da670d4e9b55c0f5.png)  

对比虚拟机， docker 并不是在 Host OS 上实现了自己的 Guest OS ，而是使用了 Docker Engine 借助 Host OS 的 namespace 、 Control Group 等，对进程进行封装隔离——容器化。换言之，VM 在宿主系统上实现了自己的操作系统内核，而 Docker 是借助宿主系统的内核实现的应用封装。所以 Docker 属于更轻量化的技术，虚拟机包括操作系统内核以及一大堆乱七八糟的库，更笨重。

## 一些概念

### 镜像（Image）

可以类比为集装箱，其中包含了一个应用的运行所需要的依赖以及应用本身。

实际上，镜像的构建使用了联合文件系统的技术，从操作系统的引导，上一层是操作系统镜像，再上一层是 Tomcat 、 jdk 、……等等。镜像不包含任何动态数据，每层的内容在构建完成之后都不会删除。

![picture 2](../../../../assets/%E5%B7%A5%E5%85%B7/docker/docker%20%E7%AE%80%E4%BB%8B/3582e10cecd9062825c1afc8464540228c16f3d461aa500be51077849b782187.png)  

### 容器（Container）

可以理解为集装箱内部的产品，集装箱运过来之后就可以拆箱即用了。

实际上，是使用了联合文件系统的技术，以镜像为底层，在其上构建存储层。运行一个容器，实际上就是运行了一个进程，进程之间拥有隔离的命名空间、网络配置、用户 ID 空间等等。这种相对独立性也是 Docker 容易被混淆成虚拟机的重要原因。实际上，这种相对独立性让我们免去了很多的环境部署麻烦，运行环境是标准化的。

### 仓库（Repository）

可以类比为码头，docker 可以想象成鲸鱼，就像图标中的一样，可以将镜像运送到目标港口。

实际上，就是远程的镜像仓库。 Docker 官方提供了[仓库](https://hub.docker.com/)，而国内也有一些云服务商提供自己的 Docker 仓库，比如 [阿里云](https://account.aliyun.com/login/login.htm)、[网易云](https://c.163.com/hub#/m/home/)

## 常用命令

`docker search [keyword]`：检索镜像（一般从docker hub检索）  
`docker pull [imagename]`：拉取镜像  
`docker images`：获取镜像列表  
`docker rmi [imageId]`：删除指定镜像  
`docker rm [containerId]`：删除指定容器  
`docker rm $(docker ps -a)`：删除所有容器  
`docker ps`：查看运行中的容器  
`docker ps -a`：查看所有容器  
`docker start/stop/kill [containerId]|[containerName]`：开启/停止/强制停止指定容器  
`docker run --name [containerName] -d -p [VM-Port]:[Container-Port] [imageName]`：docker启动容器  
`docker run -it --name [containerName] [imageName]`：交互式启动容器
`docker run -d --name [containerName] [imageName]`：守护进程式启动容器（若未分配事情给容器做，容器没有前台会自杀）  
`docker run -it --name mysql_test -p 3306:3306 -e MYSQL_ROOT_PASSWORD=123456 -d mysql`：指定初始root密码启动一个mysql容器  
`docker exec -it [containerName] [/bin/bash]`：进入容器的bash，进入 bash 的命令可以替换为其他命令，exec 命令可以使容器开启新进程
`docker attach -it [containerName]`：进入容器的 shell，不会开启新的线程
`docker cp [containerId]:[directory] [directory-in-VM]`：从容器内复制文件进入宿主机

## 打包项目并部署

整体流程：在本地安装 Docker 之后，在对应项目的目录下新建 Dockerfile ，通过配置 Dockerfile 告诉 Docker 如何构建镜像。

下面是 Dockerfile 的一些配置参数含义：

- `FROM`：指定创建镜像的基础镜像；
- `MAINTAINER`：Dockerfile作者信息，一般写的是联系方式；
- `RUN`：运行Linux系统的命令使用；
- `CMD`：指定容器启动执行的命令；启动容器中的服务；
- `LABEL`：指定生成镜像的源数据标签；
- `EXPOSE`：指定镜像容器监听端口号；发布服务使用；
- `ENV`：使用环境变量；
- `ADD`：对压缩文件进行解压缩；将数据移动到指定的目录；
- `COPY`：复制宿主机数据到镜像内部使用；
- `WORKDIR`：切换到镜像容器中的指定目录中；
- `VOLUME`：挂载数据卷到镜像容器中；
- `USER`：指定运行容器的用户；
- `ARG`：指定镜像的版本号信息；
- `ONBUILD`：创建镜像，作为其他镜像的基础镜像运行操作指令；
- `ENTRYPOINT`：指定运行容器启动过程执行命令，覆盖CMD参数；
