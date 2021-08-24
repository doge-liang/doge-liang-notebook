---
title: Java 的表 List
date: 2021-03-12
tags: []
categories:
  - 程序设计语言
  - Java
---

- [Java 的表 List](#java-的表-list)

## Java 的表 List

List<?> 转换成 ?[]

```JAVA
int[] array = list.stream().mapToInt(i -> i).toArray();
```

注意 `list.toArray()` 返回的是 `Object[]` 或者 `T[]`
