---
title: Java 的映射 HashMap 和 TreeMap
date: 2021-03-12
tags: [数据结构, 映射]
categories:
  - 程序设计语言
  - Java
---

<style>
.center {
width: auto;
display: table;
margin - left: auto;
margin - right: auto;
}
// 图片居中
img {
position: relative;
left: 50%;
transform: translateX(-50%);
}
</style>

## Java 的映射（HashMap 和 TreeMap）数据结构 , 映射程序设计语言

# Java 数据结构之映射（键值对）

## HashMap

### 初始化的两种方式

第一种方式是常见写法，实例化一个空 `HashMap` 对象，再调用实例方法 `put()`。

```JAVA
HashMap<String, String> map = new HashMap<>();
map.put("key1", "value1");
map.put("key2", "value2");
```

第二种方式使用了匿名内部类，

```JAVA
HashMap<String, String> map = new HashMap<String, String>() {
    {
        put.("key1", "value2");
        put.("key2", "value2");
    }
}
```
