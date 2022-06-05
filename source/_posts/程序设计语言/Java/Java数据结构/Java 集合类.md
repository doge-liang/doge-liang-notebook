---
title: Java 集合类
date: 2021-03-12
tags: []
categories:
  + 程序设计语言
  + Java
---

## Java 集合类

### Collection

在使用 `Collectors.toMap()` 时，要注意两个问题：

1. 当 key 相同时会抛出 `IllegalStateException` ；
2. 当 value 为 null 时，会抛出 `NullPointerException` ；

### List

#### WeakHashMap

适用于需要缓存的场景, 对 entry 进行弱引用管理 GC 时会自动释放弱引用的 entry 项
相对 HashMap 只增加弱引用管理, 并不保证线程安全

#### HashTable

读写方法都加了 `synchronized` 关键字 key 和 value 都不允许出现 null 值
与 HashMap 不同的是 HashTable 直接使用对象的 hashCode , 不会重新计算 has 值 `ConcurrentHashMap`

利用 CAS + Synchronized 来确保线程安全. 底层数据结构依然是数组+链表+红黑树, 对哈希项进行分段上锁, 效率上较之 HashTable 要高；
key 和 uvaiue 都不允许出现 null

> CAS(compare and swap) 并交换
> 在 Java 语言还未出现的时候，并发得到大量应用了，硬件厂商也给出了很多并发操作原语，从硬件层面提高并发效率。CAS 指令就是其中之一；
> Java 语言初期还无法利用硬件提供的指令提高并发效率，后来随着语言的发展，诞生了 Java 本地方法(JNI) 让 JVM 便利地调用本地方法。
> CAS 操作包含三个操作数：
>
> 1. 内存位置（V)；
> 2. 预期原值（A）；
> 3. 新值（B）；
> 如果内存位置的值 V 和预期原值 A 匹配，那边处理器会自动更新 V 为新值 B ，否则处理器不做任何处理；一般情况下，它都会在 CAS 指令之前返回该位置的值。
> 用自然语言描述这个过程就是：如果内存存的是值我预期的 A ，那么就把新值 B 放进去，否则更改失败，返回内存现在的值；
> 在多线程的时候无需害怕其他线程同时修改变量，如果被修改了，CAS 指令会执行失败；
> 存在的问题：
>
> - ABA 问题：内存中的值在预期值 A 和新值 B 之间反复横跳，对于执行 CAS 操作的线程来说，在计算新值 B 的过程中，实际上值已经发生了变化了。解决思路是加入一个版本号，在变量前加入变量的版本号，每次对变量的操作都进行累加。执行 CAS 指令时加上版本号校验；
> - 循环时间长开销大：
> <https://blog.csdn.net/ls5718/article/details/52563959>

### Map

### Set
