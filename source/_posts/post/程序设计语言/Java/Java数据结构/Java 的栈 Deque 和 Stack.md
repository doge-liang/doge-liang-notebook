---
title: Java 的栈 Deque和Stack
date: 2021-03-12
tags: [数据结构, 栈]
categories:
  - [程序设计语言]
---

- [Java 的栈 Deque 和 Stack](#java-的栈-deque-和-stack)

## Java 的栈 Deque 和 Stack

Java 拥有双端队列 `Deque` 接口，**没有属于栈的 `Stack` 接口**，只有一个遗留的 `Stack` 类。

双端队列 `Deque` 可以从两端插入和取出，既可以模拟栈也可以模拟队列。

当用作栈时，有 `pop()/peek()/push()/` 等 `Stack` 风格的方法，而用作队列时又有。
