---
title: Java IO
date: 2022-06-22
tags: []
categories:

  - 程序设计语言
  - Java
---

## Java IO

Java 提供了庞大的输入/输出 API 供开发者使用。按照处理的对象来说，分为两种 IO 流：

- 字节流，以字节为读写单位；
- 二进制流，以二进制 byte 为读写单位

### 读写字节

InputStream/OutputStream 家族（FileInputStream、FileOutputStream...）

InputStream 和 OutputStream 的 read() 和 write() 方法都是阻塞的，执行时都会阻塞该线程到字节确实被读写，期间流如果暂时无法访问，则其他线程有机会抢占位置执行别的项目。
如果使用 `avavilable()` 方法便可以判断此时可以获取多少个字节，下面的读取方式不可能被阻塞；

```JAVA
int bytesAvailable  = in.available();
if (bytesAvailable > 0) {
    var data = new byte[bytesAvailable];
    in.read(data);
} 
```

```JAVA
byte[] bytes = in.readAllBytes(); // 一次读取所有的字节，其他的读取给定字节数的方法，都是调用 read() 方法，所以每个 InputStream 的子类都只需要重写 read() 方法即可

in.transferTo(out); // 可以将所有字节从 InputStream 传递到 OutputStream 中
long m = in.skip(n); // 用于跳过指定的字节数，返回实际被跳过的字节数
in.mark(readlimit); // 在字节流的 readlimit 处
```

对每个流操作完毕后都需要调用 `close()` 方法将其关闭，如果不关闭可能会有耗尽系统资源的风险。随着输出流的关闭，其输出缓冲区也会被关闭，缓冲区中的内容也会被冲刷出，如果不关闭流，那么流中的内容永远得不到传递。

