---
title: jvm 常用工具
tags: []
categories:
  - article
  - 计算机
  - 程序设计语言
  - Java
  - JVM
date: 2022-07-23 00:00:00
---

## JVM 常用工具

### 基础故障处理工具

#### java

#### javac

#### javap

#### jps

虚拟机进程状况工具，类似于 linux 的 ps 命令，不过这个命令专门对 Java 程序服务，可以列出正在运行的虚拟机进 程，并显示虚拟机执行主类（Main Class，main()函数所在的类）名称以及这些进程的本地虚拟机唯一 ID（LVMID，Local Virtual Machine Identifier）。

命令格式：

```shell
jps [option] [hostId]
```

选项：

- `-q` 只输出 LVMID ，省略主类名称；
- `-m` 输出虚拟机进程启动时传递给主类 main() 函数的参数；
- `-l` 输出主类的全名，如果进程执行的是 jar 包，则输出 jar 包路径；
- `-v` 输出虚拟机进程启动时的 JVM 参数；

#### jstat

#### jinfo

#### jmap

#### jhat

#### jstack

用于生成虚拟机当前时刻的线程快照，（一般称为threaddump或者 javacore文件）。线程快照就是当前虚拟机内每一条线程正在执行的方法堆栈的集合，生成线程快照的 目的通常是定位线程出现长时间停顿的原因，如线程间死锁、死循环、请求外部资源导致的长时间挂 起等，都是导致线程长时间停顿的常见原因。
线程出现停顿时通过jstack来查看各个线程的调用堆栈， 就可以获知没有响应的线程到底在后台做些什么事情，或者等待着什么资源。

```shell
usage:
    jstack [option] vmId

-F 正常输出的请求不被响应时，强制输出线程堆栈
-l 除堆栈外，还输出关于锁的详细信息
-m 如果调用到本地方法，还显示 C/C++ 的堆栈
```
