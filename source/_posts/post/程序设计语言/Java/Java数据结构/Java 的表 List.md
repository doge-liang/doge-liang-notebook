---
title: Java 的表 List
date: 2021-03-12
tags: []
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

## Java 的表 List

List<?> 转换成 ?[]

``` JAVA
int[] array = list.stream().mapToInt(i -> i).toArray();
```

注意 `list.toArray()` 返回的是 `Object[]` 或者 `T[]`
