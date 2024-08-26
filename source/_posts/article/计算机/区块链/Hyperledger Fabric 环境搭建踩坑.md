---
title: Hyperledger Fabric 环境搭建踩坑
tags: []
categories:
  - article
  - 计算机
  - 区块链
date: 2021-03-27 00:00:00
---

## Hyperledger Fabric 环境搭建踩坑

### 网络启动失败

在跑 `. ./init.sh` 脚本的时候，运行到第五步，创建通道并将节点加入通道的时候，出现了如下错误：

```code
5.Create & Join Channel
######## - (COMMON) setup variables - ########
~/workspace/channel-artifacts ~/workspace
Error: failed to create deliver client for orderer: orderer client failed to connect to localhost:7050: failed to create new connection: connection error: desc = "transport: error while dialing: dial tcp 127.0.0.1:7050: connect: connection refused"
~/workspace
######## - (ORG1) join channel - ########
Error: error getting endorser client for channel: endorser client failed to connect to localhost:7051: failed to create new connection: connection error: desc = "transport: error while dialing: dial tcp 127.0.0.1:7051: connect: connection refused"
######## - (ORG1) update anchor - ########
2021-03-27 13:40:35.708 CST [channelCmd] InitCmdFactory -> INFO 001 Endorser and orderer connections initialized
Error: Error getting broadcast client: orderer client failed to connect to localhost:7050: failed to create new connection: connection error: desc = "transport: error while dialing: dial tcp 127.0.0.1:7050: connect: connection refused"
######## - (ORG2) join channel - ########
Error: error getting endorser client for channel: endorser client failed to connect to localhost:9051: failed to create new connection: connection error: desc = "transport: error while dialing: dial tcp 127.0.0.1:9051: connect: connection refused"
######## - (ORG2) update anchor - ########
2021-03-27 13:40:35.785 CST [channelCmd] InitCmdFactory -> INFO 001 Endorser and orderer connections initialized
Error: Error getting broadcast client: orderer client failed to connect to localhost:7050: failed to create new connection: connection error: desc = "transport: error while dialing: dial tcp 127.0.0.1:7050: connect: connection refused"
```

意思是建立到本地的 7050 等等端口的 tcp 时失败了，原因是拒绝访问。

原因暂时不明，但是我运行了 `. ./shutdown.sh` 和 `. ./teardown.sh` 两个脚本，把整个网络都删掉了，再重新执行接下来的脚本就搞定了。

原因不明，但是先记录一下这两个脚本都做了什么吧，以后再出现了就再分析。

/root/workspace/shutdown.sh

```BASH
#!/bin/bash

echo "Clearing"
docker rm -f `docker ps -qa`
docker rmi -f $(docker images | awk '($1 ~ /dev-peer.*/) {print $3}')
docker volume prune -f
docker network prune -f

rm -rf system-genesis-block/*.block
rm -rf channel-artifacts
rm -rf organizations/peerOrganizations
rm -rf organizations/ordererOrganizations
rm -rf tmp
sudo rm -rf organizations/fabric-ca/org1/*
sudo rm -rf organizations/fabric-ca/org2/*
sudo rm -rf organizations/fabric-ca/ordererOrg/*
```

/root/workspace/teardown.sh

```BASH
#!/bin/bash
echo "Shutdown CA Services, Peers and Orderer in Network"
COMPOSE_FILE_CA=docker/docker-compose-ca.yaml
COMPOSE_FILE_BASE=docker/docker-compose-ABC.yaml
COMPOSE_FILE_COUCH=docker/docker-compose-couch.yaml
CA_IMAGE_TAG=${CA_VERSION}
IMAGE_TAG=${FABRIC_VERSION}
DB_IMAGE_TAG=${OTHER_VERSION}
docker-compose -f ${COMPOSE_FILE_CA} -f ${COMPOSE_FILE_BASE} -f ${COMPOSE_FILE_COUCH} down
echo
```
