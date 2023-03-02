---
title: 链码开发-Golang
tags: []
categories:
  - article
  - 区块链
  - Hyperledger Fabric
date: 2021-04-10 00:00:00
---

## 链码开发

Golang 的链码开发有两套 api ：

- [shim api](https://pkg.go.dev/github.com/hyperledger/fabric-chaincode-go/shim?utm_source=godoc#Chaincode) 偏底层；
- [contract api](https://github.com/hyperledger/fabric-contract-api-go/blob/main/tutorials/using-advanced-features.md) 实际上也不过是在 shim api 上做了一层封装，通过获取 shim api 的 stub 来调用 shim api 的 stub；

### Contract api

一个合约需要遵循以下的规则：

1. 入参的第一个只能是 contratapi.TransactionContext 或者继承了这个结构的接口（自定义的或者 contractapi.TransactionContextInterface ）。其他的入参只能是如下的类型：
   string
   bool
   int (including int8, int16, int32 and int64)
   uint (including uint8, uint16, uint32 and uint64)
   float32
   float64
   time.Time
   Arrays/slices of any allowable type
   Structs (whose public fields are all of the allowable types or another struct)
   Pointers to structs
   Maps with a key of type string and values of any of the allowable types
   interface{} (Only allowed when directly taken in, will receive a string type when called via a transaction)
2. 返回的参数只能是零个、一个或两个
