---
title: docker ps 命令打印内容过多如何解决
date: 2021-03-30
tags: []
categories:
  - 工具
  - docker
---

## docker ps 命令打印内容过多如何解决

可以自己指定显示的模板，例如：

```BASH
docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Ports}}"
```

- `table` - 表示显示表头列名
- `{{.ID}}` - 容器 ID
- `{{.Command}}` - 启动执行的命令
  显示结果：

```BASH
$ docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Ports}}"
CONTAINER ID        NAMES                                   PORTS
db3df460fe14        dev-peer0.org1.example.com-fabcar-1.0
b6f803814cce        cli
10724ca7364f        peer0.org1.example.com                  0.0.0.0:7051->7051/tcp, 0.0.0.0:7053->7053/tcp
20d930e6e9f7        ca.example.com                          0.0.0.0:7054->7054/tcp
```

可用的占位符

| 名称        | 含义                 |
| ----------- | -------------------- |
| .ID         | 容器 ID              |
| .Image      | 镜像 ID              |
| .Command    | 执行的命令           |
| .CreatedAt  | 容器创建时间         |
| .RunningFor | 运行时长             |
| .Ports      | 暴露的端口           |
| .Status     | 容器状态             |
| .Names      | 容器名称             |
| .Label      | 分配给容器的所有标签 |
| .Mounts     | 容器挂载的卷         |
| .Networks   | 容器所用的网络名称   |
