---
title: Java程序设计语言基础-泛型
date: 2019-10-01
tags: [程序设计语言, Java]
categories:
	- [程序设计语言]
---
# 泛型

这个特性使得我们可以将类型参数化，即，将类型定义为参数传入方法中，不需要在传入参数的时候再考虑传入对象类型问题，以及相关的程序调试问题。  

借助于**自动打包 (autoboxing)**的java特性，支持泛型类在被调用的时候自动进行类型转换成为调用者指定的类型。  

```java
//这是一个泛型类
public class genericClass<T> {
	//这是一个泛型方法
	public genericMethod(T param) {...}
...}

//这是一个泛型接口
public interface genericInterface<T> {
...}
```


