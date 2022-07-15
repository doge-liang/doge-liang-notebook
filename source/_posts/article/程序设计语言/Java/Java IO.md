---
title: Java IO
date: 2022-06-22
tags: []
categories:

  - 程序设计语言
  - Java
---

## Java IO

Java 提供了庞大的输入/输出 API 供开发者使用。

总的来说分为两种 IO 流：

- 字节流，以字节为读写单位；
- 二进制流，以二进制 byte 为读写单位

### 读写字节

InputStream/OutputStream 家族（FileInputStream、FileOutputStream...）

InputStream 和 OutputStream 的 read() 和 write() 方法都是阻塞的，执行时都会阻塞到字节确实被读写，期间流如果暂时无法访问，则其他线程有机会抢占位置执行别的项目。
