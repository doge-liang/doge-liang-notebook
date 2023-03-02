---
title: Fabric 网络启动（本地方式）
tags:
  - Hyperledger Fabric
categories:
  - article
  - 区块链
  - 区块链原理、设计与应用
  - 实践篇
date: 2021-03-14 00:00:00
---

## Fabric 网络启动（本地方式）

启动一个 Fabric 网络主要包括以下步骤：

1. 规划初始网络拓扑
2. 准备启动配置文件
3. 启动 Peer 节点
4. 创建通道
5. 加入通道

### 规划初始网络拓扑

示例网络拓扑结构如图：

![picture 1](../../../../../assets/%E5%8C%BA%E5%9D%97%E9%93%BE/%E5%8C%BA%E5%9D%97%E9%93%BE%E5%8E%9F%E7%90%86%E3%80%81%E8%AE%BE%E8%AE%A1%E4%B8%8E%E5%BA%94%E7%94%A8/%E5%AE%9E%E8%B7%B5%E7%AF%87/Fabric%20%E7%BD%91%E7%BB%9C%E5%90%AF%E5%8A%A8%EF%BC%88%E6%9C%AC%E5%9C%B0%E6%96%B9%E5%BC%8F%EF%BC%89/7d2ba45fa2972f19cecc140c1fd280702c0c7387d76d6e5edf1d83589c6d6a48.png)

构成要素：

- 3 个排序节点
- 4 个 Peer 节点，分属两个组织 Org1 和 Org2 ，每个组织的 Peer0 节点作为锚节点负责组织间的信息共享
- 1 个客户端操作节点
- 2 个组织 Org1 ， Org2

排序服务使用 Raft 模式，所有节点都加入 businesschannel 中。

### 准备启动配置文件

Fabric 网络启动之前需要准备一些相关的配置文件，主要包括：

- MSP 相关身份文件( `msp/*` )
- TLS 相关身份文件( `tlsca/*` )
- 系统通道初始区块( `orderer.genesis.block` )
- 新建应用通道交易文件( `businesschannel.tx` )
- 锚节点配置更新交易文件( `Org2MSPanchors.tx` 和 `Org2MSPanchors.tx` )

![picture 7](../../../../../assets/%E5%8C%BA%E5%9D%97%E9%93%BE/%E5%8C%BA%E5%9D%97%E9%93%BE%E5%8E%9F%E7%90%86%E3%80%81%E8%AE%BE%E8%AE%A1%E4%B8%8E%E5%BA%94%E7%94%A8/%E5%AE%9E%E8%B7%B5%E7%AF%87/Fabric%20%E7%BD%91%E7%BB%9C%E5%90%AF%E5%8A%A8%EF%BC%88%E6%9C%AC%E5%9C%B0%E6%96%B9%E5%BC%8F%EF%BC%89/84a6bcf5b0d6805398efbebcfe616f64f1856081b2bbaab0738f43a6ad49e60a.png)

下面开始生成上述五类配置文件。

#### 生成组织关系和身份证书

联盟链的成员之间通过身份进行识别，网络通过身份来限制资源的访问，所以所有的成员需要事先准备对应的身份文件，并部署到其所拥有的节点和客户端上。

用户可通过标准的 `PKI` 服务或 `OpenSSL` 工具，手动生成各个实体的证书和私钥，另外 `Fabric` 还提供了 `cryptogen` 工具（基于 Go 语言的 `crypto` 标准库）在本地生成，需要提前准备 `crypto-config.yaml` 配置文件。

`crypto-config.yaml` 支持定义两种类型的若干个组织（ `OrdererOrgs` 和 `PeerOrgs` ）。每个组织还可以定义多个节点（ Spec ）和用户（ User ）。

本次案例中， `crypto-config.yaml` 文件定义了一个 `OrdererOrgs` 类型的组织 `example.com` 包括 3 个节点；两个 `PeerOrgs` 类型的组织 `org1.example.com` 和 `org2.example.com` ，分别包括 2 个节点和 1 个普通用户身份，文件内容如下：

```yaml
OrdererOrgs:
    - Name: Orderer
        Domain: example.com
        CA:
            Country: US
            Province: California
            Locality: San Francisco
        Specs:
            - Hostname: orderer0
            - Hostname: orderer1
            - Hostname: orderer2
PeerOrgs:
    - Name: Org1
      Domain: org1.example.com
      EnableNodeOUs: true
      CA:
        Country: US
        Province: California
        Locality: San Francisco
      Template:
        Count: 2
      Users:
        Count: 1
    - Name: Org2
      Domain: org2.example.com
      EnableNodeOUs: true
      CA:
        Country: US
        Province: California
        Locality: San Francisco
      Template:
        Count: 2
      Users:
        Count: 1

```

生成身份文件：

```BASH
cryptogen generate \
    --config=./crypto-config.yaml \
    --output ./crypto-config \
    && tree -L 4 crypto-config
```

可以看到目录结构如下：

```BASH
/crypto-config
├── ordererOrganizations
│   └── example.com
│       ├── ca
│       │   ├── ca.example.com-cert.pem
│       │   └── priv_sk
│       ├── msp
│       │   ├── admincerts
│       │   ├── cacerts
│       │   └── tlscacerts
│       ├── orderers
│       │   ├── orderer0.example.com
│       │   ├── orderer1.example.com
│       │   └── orderer2.example.com
│       ├── tlsca
│       │   ├── priv_sk
│       │   └── tlsca.example.com-cert.pem
│       └── users
│           └── Admin@example.com
└── peerOrganizations
    ├── org1.example.com
    │   ├── ca
    │   │   ├── ca.org1.example.com-cert.pem
    │   │   └── priv_sk
    │   ├── msp
    │   │   ├── admincerts
    │   │   ├── cacerts
    │   │   ├── config.yaml
    │   │   └── tlscacerts
    │   ├── peers
    │   │   ├── peer0.org1.example.com
    │   │   └── peer1.org1.example.com
    │   ├── tlsca
    │   │   ├── priv_sk
    │   │   └── tlsca.org1.example.com-cert.pem
    │   └── users
    │       ├── Admin@org1.example.com
    │       └── User1@org1.example.com
    └── org2.example.com
        ├── ca
        │   ├── ca.org2.example.com-cert.pem
        │   └── priv_sk
        ├── msp
        │   ├── admincerts
        │   ├── cacerts
        │   ├── config.yaml
        │   └── tlscacerts
        ├── peers
        │   ├── peer0.org2.example.com
        │   └── peer1.org2.example.com
        ├── tlsca
        │   ├── priv_sk
        │   └── tlsca.org2.example.com-cert.pem
        └── users
            ├── Admin@org2.example.com
            └── User1@org2.example.com
```

我们看到 `ordererOrganizations` 目录下包括了如下三个排序节点的身份信息：

```BASH
/crypto-config/ordererOrganizations/example.com/orderers
   ├── orderer0.example.com
   ├── orderer1.example.com
   └── orderer2.example.com
```

`peerOrganizations` 目录下包括了所有的 `Peer` 节点组织及其节点的身份信息：

```BASH
/crypto-config/peerOrganizations
├── org1.example.com
│   └── peers
│       ├── peer0.org1.example.com
│       └── peer1.org1.example.com
└── org2.example.com
    └── peers
        ├── peer0.org2.example.com
        └── peer1.org2.example.com
```

每个实体都有 `msp` 和 `tls` 目录，其中包括了对应的认证身份文件和 `TLS` 身份文件（公钥证书、私钥等）。

接下来需要把节点对应的身份文件移动到 `/etc/hyperledger/fabric/` 目录下：

```BASH
sudo cp -r \
crypto-config/ordererOrganizations/example.com/orderers/* \
 crypto-config/peerOrganizations/org1.example.com/peers/* \
 crypto-config/peerOrganizations/org2.example.com/peers/* \
 crypto-config/ordererOrganizations/example.com/users/* \
 crypto-config/peerOrganizations/org1.example.com/users/* \
 crypto-config/peerOrganizations/org2.example.com/users/* \
 /etc/hyperledger/fabric/ && \
 tree -L 2 /etc/hyperledger/fabric/
```

结果如下：

```BASH
/etc/hyperledger/fabric/
├── Admin@example.com
│   ├── msp
│   └── tls
├── Admin@org1.example.com
│   ├── msp
│   └── tls
├── Admin@org2.example.com
│   ├── msp
│   └── tls
├── orderer0.example.com
│   ├── msp
│   └── tls
├── orderer1.example.com
│   ├── msp
│   └── tls
├── orderer2.example.com
│   ├── msp
│   └── tls
├── peer0.org1.example.com
│   ├── msp
│   └── tls
├── peer0.org2.example.com
│   ├── msp
│   └── tls
├── peer1.org1.example.com
│   ├── msp
│   └── tls
├── peer1.org2.example.com
│   ├── msp
│   └── tls
├── User1@org1.example.com
│   ├── msp
│   └── tls
└── User1@org2.example.com
    ├── msp
    └── tls
```

#### 生成系统通道初始区块

系统通道是网络启动后的第一个通道，负责管理网络整体的配置。排序节点启动后，可以使用初始区块来创建一个新的网络。

初始区块包括了排序服务的相关配置信息（包括排序节点信息、块大小、最大通道数、默认策略等等）和示例联盟配置。可以使用 `configtxgen` 工具通过配置文件 `configtx.yaml` 生成。

`configtx.yaml` 配置文件

使用 `configtxgen` 工具生成初始区块文件：

```shell
export SYS_CHANNEL=testchainid
export ORDERER_GENESIS_PROFILE=TwoOrgsOrdererGenesis
export ORDERER_GENESIS=orderer.genesis.block
configtxgen \
-configPath ./ \
-channelID ${SYS_CHANNEL} \
-profile ${ORDERER_GENESIS_PROFILE} \
-outputBlock ${ORDERER_GENESIS}
```
