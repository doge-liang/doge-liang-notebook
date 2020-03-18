# Docker

## 简介

docker是一个容器，可以将应用打包安装在这个容器内，使得即使在不同的系统环境中也能使用；

## 常用命令

`docker search [keyword]`：检索镜像（一般从docker hub检索）  
`docker pull [imagename]`：拉取镜像  
`docker images`：获取镜像列表  
`docker rmi [imageId]`：删除指定镜像  
`docker rm [containerId]`：删除指定容器  
`docker ps`：查看运行中的容器  
`docker ps -a`：查看所有容器  
`docker start/stop [containerId]|[containerName]`：开启/停止指定容器  
`docker run --name [containerName] -d -p [VM-Port]:[Container-Port] [imageName]`：docker启动容器  
`docker run -it --name [containerName] [imageName]`：启动容器  
`docker run -it --name mysql_test -p 3306:3306 -e MYSQL_ROOT_PASSWORD=123456 -d mysql`：指定初始root密码启动一个mysql容器  
`docker exec -it [containerName] bash`：进入容器的bash

