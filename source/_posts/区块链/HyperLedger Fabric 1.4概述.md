---
title: 区块链概述以及Hyperledger
date: 2020-05-27
tags: [区块链概述, Hyperledger, Fabric]
categories: 
    - [区块链]
    - [Hyperledger]
---

# Fabric 概述

## Permissioned or Permissionless
许可的概念不理解成非 0 即 1 的概念，根据不同的业务场景，有很多维度的许可，不同维度的许可排列组合能够形成丰富的许可结构，比如身份是否可以公开访问、谁可以访问节点，谁可以提交一个交易，谁可以看到这个区块。。。

## 模块化 modular
blockmaker:orderer
bookkeeper:peer
submitter:client
CA
organization

## 智能合约 smart contracts
支持语言：GO, nodeJS, Java

## 共识机制可插拔 pluggable consensus
实现接口替代内置共识机制

## 隐私数据 Privacy
保证数据隐私

## 没有内置挖矿 No mining
为了提升交易速度

。。。官方的太慢了而且讲的不细，本篇到此作废，下一篇开始实战。