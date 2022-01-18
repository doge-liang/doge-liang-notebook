---
title: Java Stream API
date: 2019-10-01
tags: []
categories:
	- 程序设计语言
	- Java
---

## Java Stream API

### 简介

Stream API 是 Java SE 8 引入的新特性。是一系列类似于 JavaScript 的函数式处理集合的方法。这种方法使我们更加关注对于集合的操作，而无需关注元素的处理顺序，这也让并行处理集合元素成为可能；

### 入门

使用步骤如下：

1. 创建流；
2. 对流做过滤、聚合、映射等中间操作；
3. 从流中收集元素生成集合。

### 创建流

- 有限流
  - `collectionInst.stream()`
  - `Arrays.stream(array, from, to)` 切分数组产生流；
  - `Stream.of(T...)`
  - `Stream.empty()`
  - `collectionInst.parallelStream()` 并行处理流中的元素；
- 无限流
  - `Stream.generate(Supplier<T> s)` 返回调用 Supplier 函数产生流；
  - `Stream.iterate(T seek, UnaryOperator<T> f)` ；
- 其他创建流的方法
  - `PatternInst.splitAsStream(CharSequence input)` 根据正则结果生成流；
  - `Files.lines(Path path, Charset cs)` 按行读取文件产生流；

### 中间操作

- `filter(Predicate<T> conditions)` 通过条件过滤流；
- `map(Function<? super T, ? extends R> mapper)` 对流中的每一个元素传入 mapper 函数中，将返回值生成新的流；
- `flatMap(Function<? super T, ? extends Stream<? extends R>> mapper)` 将多个流通过 mapper 汇总成一个流输出；
- 裁剪
  - `streamInst.limit(n)` 抽取流的前 n 个元素组成新流；如果流提前结束则新流一起结束；
  - `streamInst.skip(n)` 跳过 n 个元素，产生新流；
  - `Stream.concat(stream1, stream2)` 连接 stream1 和 stream2 ，产生新流；
  - `streamInst.distinct()` 去重；
  - `streamInst.sort(Comparator<? super T> comparator))` 根据传入的比较器对流进行排序；
    > `Comparator.comparing(Function<? super T, ? extends U> keyExtractor, Comparator<? super U> keyComparator)` 返回比较器，`keyExtractor` 根据流中的对象产生比较的 key ， `keyComparator` 用于自定义 key 的比较规则；
    > `Comparator.comparing(Function<? super T, ? extends U> keyExtractor)` 返回比较器， `keyExtractor` 作用同上，不能自定义比较器，所以需要 `keyExtractor` 返回的对象 `U` 实现 `compareTo()` 方法；
  - `streamInst.peek(Comsumer<? super T> action)` 把流中的元素抽取出来传给 `action` 执行某项动作，不返回结果，产生的新流与原来的流相同；

### 收集流

=======
创建流的各种方式：

1. `CollectionInstance.stream()` 返回由集合的元素组成的流；
2. `Stream.of(T)` 和 `Stream.of(T...)` 返回 T 类型的流；
