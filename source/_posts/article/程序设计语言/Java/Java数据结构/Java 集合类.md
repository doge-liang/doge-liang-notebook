---
title: Java 集合类
date: 2021-03-12
tags: []
categories:
  + 程序设计语言
  + Java
---

## Java 集合框架

### 实现思想

Java 集合框架的实现思想为为常见的接口和实现分离思想。

使用时只需根据自己的需要声明对应类型的变量，具体实现是哪个取决于构造了什么集合。

```JAVA
List<Customer> expressLane = new ArrayList<>(100);
List<Customer> expressLane = new LinkedList<>(100);
expressLane.add(new Customer("Harry"));
```

上述例子声明了两个 `List` ，程序并不用关注具体的实现是数组列表还是链表（虽然对他们做某些操作时，效率不同），只需要调用顺序表的 API 即可；
这样对于变量的使用方来说，具体的实现方式就是透明的了，只需要关注使用的数据结构接口即可；

此外，Java API 库中还定义了一些 `Abstract` 前缀修饰的类，比如 `AbstractCollection` 里面对 `Collection` 接口一些基本方法的实现，如果要实现自己的集合类，又不想重写所有的方法，继承 `Abstract` 前缀修饰的集合类更方便。

### 基础接口

Java 有两大类集合： `Map` 和 `Collection`

![picture 1](../../../../../assets/%E7%A8%8B%E5%BA%8F%E8%AE%BE%E8%AE%A1%E8%AF%AD%E8%A8%80/Java/Java%E6%95%B0%E6%8D%AE%E7%BB%93%E6%9E%84/Java%20%E9%9B%86%E5%90%88%E7%B1%BB/bb5ba2d657eeccd52915b6ed133b9e2cf3b272af3ae070137218ddcc16bbba84.png)  

### Collection

```JAVA
public interface Collection<E> {
    boolean add(E element); // 添加元素
    Iterator<E> iterator(); // 返回实现了 Iterator 接口的对象，用于迭代方法集合中的元素
}
```

#### Iterator

```JAVA
public interface Iterator<E> {
    E next(); // 如果到达了集合的末尾，会抛出异常 NoSuchElementException  
    boolean hasNext();
    void remove();
    default void forEachRemaining(Consumer<? super E> action();
}
```


在使用 `Collectors.toMap()` 时，要注意两个问题：

1. 当 key 相同时会抛出 `IllegalStateException` ；
2. 当 value 为 null 时，会抛出 `NullPointerException` ；

#### List

### Map

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

### Set

#### HashSet
