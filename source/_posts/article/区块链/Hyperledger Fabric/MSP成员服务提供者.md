---
title: MSP 成员服务提供者
date: 2021-04-05
tags: []
categories:
  - 区块链
  - Hyperledger Fabric
---

## MSP 成员服务提供者

### 简介

MSP（成员服务提供者）是一种机制，他为区块链网络内的组织成员提供身份认证的功能。因为 Fabric 是一个认证性的网络，网络中的通信和交易是建立在可信身份的基础上的。他让用户不用暴露自己的私钥而能够让网络中的成员识别他的身份。

具体来说，用户要想加入一个网络进行交易，需要满足以下条件：

1. 拥有被信任的 CA 颁发的身份；
2. 成为一个被网络成员认可和认可的 组织 的成员。MSP 将身份与组织的成员资格联系在一起。成员资格是通过将成员的公钥(也称为证书、签名证书或签证)添加到组织的 MSP 来实现的。
3. 将 MSP 添加到网络上的一个联盟 或者通道。
4. 确保 MSP 包括在网络中的[策略](https://hyperledger-fabric.readthedocs.io/zh_CN/release-2.2/policies/policies.html)定义。

### MSP 域

网络中， MSP 出现在两个位置：

- 在参与者节点本地（**本地 MSP**）
- 在通道配置中（**通道 MSP**）

它们的使用范围不同，每个 MSP 列出特定管理级别上的角色和权限。

#### 本地 MSP

本地 MSP 是为**客户端**和**节点**( peer 节点和排序节点)定义的。 本地 MSPs 定义节点的权限(例如，谁是可以操作节点的 peer 节点管理员)。客户端的本地 MSP ，允许用户作为一个通道成员或作为一个特定角色的所有者，如组织管理者，在其交易(如链码交易)时进行身份验证从而进入系统，例如，进行配置交易。

**每个节点都必须定义一个本地 MSP**，因为它定义了在该级别上谁拥有管理权或参与权( peer 节点管理员不一定是通道管理员，反之亦然)。这允许在通道上下文之外对成员消息进行身份验证，并定义特定节点(例如，能够在 peer 节点上安装链码的节点)的权限。请注意，一个组织可以拥有一个或多个节点。 MSP 定义了组织管理员。组织、组织的管理员、节点的管理员以及节点本身都应该具有相同的信任根。

排序节点的本地 MSP 也在节点的文件系统上定义，并且只应用于该节点。与 peer 节点一样，排序节点也由单个组织拥有，因此有一个 MSP 来列出它信任的参与者角色或节点。

#### 通道 MSP

通道 MSP 在通道层面上定义了管理权和参与权。应用程序通道上的 peer 节点和排序节点共用通道 MSP 的相同视图，因此能够正确地对通道参与者进行身份验证。这意味着，如果组织希望加入通道，则需要在通道配置中添加包含组织成员信任链的 MSP。否则，来自该组织身份的交易将被拒绝。本地 MSP 表现为**文件系统上的文件夹结构**，而通道 MSP 则**在通道配置中被描述**。

通道 MSP 识别谁在通道层次拥有权限。通道 MSP 定义通道成员(本身是 MSP )的身份和通道级策略的执行之间的 关系 。通道 MSP 包含通道成员组织的 MSP 。

每个参与通道的组织都必须为其定义一个 MSP。

系统通道 MSP 包括参与排序服务的所有组织的 MSP。

- 本地 MSP 仅在其应用的节点或用户的文件系统上定义。每个节点只有一个本地 MSP；
- 由于通道 MSP 对通道内的所有节点都可用，它们在通道配置中逻辑上仅定义一次，而通道 MSP 也在通道中的每个节点的文件系统上实例化，并通过共识保持同步；

![picture 2](../../../../assets/%E5%8C%BA%E5%9D%97%E9%93%BE/Hyperledger%20Fabric/MSP%E6%88%90%E5%91%98%E6%9C%8D%E5%8A%A1%E6%8F%90%E4%BE%9B%E8%80%85/42c2719412b013108ddd074bac2351aed145979e59286659dbd0444252014d0f.png)

### 组织和 MSP

组织可以作为 MSP 的身份标识，像用户组一样管理组织成员。同时，一个组织也可以被划分为多个**组织单元( ou )**，每个单元有一定职责（ `affiliations` ）。例如，组织 `Org1` 可能同时拥有 `org1.Manufacturing` 和 `org1.Distribution` 组织单元，这两个组织单元反映了互相隔离的流水线。这样使用组织单元可以让策略的定义更简单，在组织内部实现更细粒度的访问控制。或者使用基于属性进行访问控制的智能合约。 `OU` 字段是可选的，如果不使用 MSP 中的所有身份都被 CA 视为组织成员。

##### 节点组织单元和 MSP

一类特殊的组织单元，有时也被称为**节点组织单元**，用于为角色赋予身份。这些节点组织单元被定义在 `FABRIC_CFG_PATH/msp/config.yaml` 配置文件中。这些单元成员被认为是 MSP 所代表的组织的一部分，通过节点组织单元，您可以实现更细粒度的背书策略，该策略要求 Org1 的 peer 节点(而不是 Org1 的任何成员)为交易背书。

例如我们可以这样定义节点组织单元：

```yaml
NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/ca.sampleorg-cert.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/ca.sampleorg-cert.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/ca.sampleorg-cert.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/ca.sampleorg-cert.pem
    OrganizationalUnitIdentifier: orderer
```

以上代码定义了四个节点组织单元：

- client
- peer
- admin
- orderer

经过上述配置，当使用 Fabric CA 或 SDK 注册带有 CA 的用户时，这些角色和 `OU` 属性会被分配给一个身份标识。随后 `enroll` 用户命令会在用户的 `/msp` 文件夹中生成证书。

![picture 3](../../../../assets/%E5%8C%BA%E5%9D%97%E9%93%BE/Hyperledger%20Fabric/MSP%E6%88%90%E5%91%98%E6%9C%8D%E5%8A%A1%E6%8F%90%E4%BE%9B%E8%80%85/e905af5fd5cacc68043ed9b7fe374adb2685be11bcbca4f4b16b8874a981911e.png)

生成的角色和 OU 属性在位于 `/signcerts` 文件夹中的 X.509 签名证书中可见。 `ROLE` 属性被标识为 `hf.Type` ，其指的是参与者在其组织中的角色(例如，指定参与者是一个 `peer` 节点)。请参阅以下来自签名证书的代码片段，它显示了角色和 ou 在证书中是如何表示的。

![picture 4](../../../../assets/%E5%8C%BA%E5%9D%97%E9%93%BE/Hyperledger%20Fabric/MSP%E6%88%90%E5%91%98%E6%9C%8D%E5%8A%A1%E6%8F%90%E4%BE%9B%E8%80%85/78c16733d6209be583fbf1273cae814c7200f2ef12448c310f727310fc1a82df.png)

另外，节点是否有权管理特定资源，还要看实际分配权力的 **策略** 如何编写，如果策略要求持有 `Org1.Manufaturing` msp 的管理者（即 `admin` 角色）才有权向通道添加新的组织，那么单单持有其中一个 msp 是无权限的。

### MSP 结构
