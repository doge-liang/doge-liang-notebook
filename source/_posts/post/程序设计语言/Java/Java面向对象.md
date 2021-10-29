---
title: Java面向对象
date: 2021-03-07
tags: [Java]
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

## Java面向对象

## 类和对象

类实际上是种抽象，

## 泛型

这个特性使得我们可以将类型参数化，即，将类型定义为参数传入方法中，不需要在传入参数的时候再考虑传入对象类型问题，以及相关的程序调试问题。  

借助于**自动打包 (autoboxing)**的java特性，支持泛型类在被调用的时候自动进行类型转换成为调用者指定的类型。  

``` java
//这是一个泛型类
public class genericClass<T> {
	//这是一个泛型方法
	public genericMethod(T param) {...}
	...
}

//这是一个泛型接口
public interface genericInterface<T> {
...}
```