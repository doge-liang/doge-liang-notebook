---
title: Hyperledger 简介
tags:
  - 区块链概述
  - Hyperledger Fabric
categories:
  - article
  - 计算机
  - 区块链
  - Hyperledger Fabric
date: 2020-05-27 00:00:00
---

## Hyperledger 简介

Hyperledger 是由 Linux 基金会发起的大型开源项目，包含了许多的子项目，其中的 Fabric 是联盟链框架。

下图描述了 Fabric 的主要构成元素。

![picture 28](../../../../assets/%E5%8C%BA%E5%9D%97%E9%93%BE/HyperLedger%20Fabric%201.4%E6%A6%82%E8%BF%B0/32790cf3b7c91c39b3d5e705884baf3078f5af0a95b61550ed9101461edffb45.png)

- Chaincode 即链码，即链上代码，是工作在每个 Peer 内的脚本，当接收到服务端发起的 proposal 提案之后， Peer 开始执行链码产生相应的结果；
- Shared Ledger 即共享账本，链上的每一个 Peer 都拥有一套相同的账本（部分节点私有的数据，未授权节点保留其 hashcode ），这也是区块链系统的基础；
- Consensus 即共识，所有的分布式系统都会面临数据一致性的问题，为了保证数据的一致性，需要引入共识机制，目前 Fabric 使用的机制有 `raft` 、 `kafka` 、 ；

### Permissioned or Permissionless

许可的概念不理解成非 0 即 1 的概念，根据不同的业务场景，有很多维度的许可，不同维度的许可排列组合能够形成丰富的许可结构，比如身份是否可以公开访问、谁可以访问节点，谁可以提交一个交易，谁可以看到这个区块。。。

### 模块化 modular

blockmaker:orderer
bookkeeper:peer
submitter:client
CA
organization

### 智能合约 smart contracts

支持语言：GO, nodeJS, Java

### 共识机制可插拔 pluggable consensus

实现接口替代内置共识机制

### 隐私数据 Privacy

保证数据隐私

### 没有内置挖矿 No mining

为了提升交易速度

。。。官方的太慢了而且讲的不细，本篇到此作废，下一篇开始实战。
