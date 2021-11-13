---
title: Java面向对象
date: 2021-03-07
tags: [Java]
categories:
  - 程序设计语言
  - Java
---

## Java 面向对象

## 类和对象

类实际上是种抽象，

## 泛型

这个特性使得我们可以将类型参数化，即，将类型定义为参数传入方法中，不需要在传入参数的时候再考虑传入对象类型问题，以及相关的程序调试问题。

借助于**自动打包 (autoboxing)**的 java 特性，支持泛型类在被调用的时候自动进行类型转换成为调用者指定的类型。

```java
//这是一个泛型类
public class genericClass<T> {
	//这是一个泛型方法
	public genericMethod(T param) {...}
	...
}

//这是一个泛型接口
public interface genericInterface<T> {
	...
}

//可以定义多个类型参数
public interface genericInterface<T, R> {
	...
}
```

### 通配符

- `? extends Employee` 代表这个泛型是 Employee 的子类；
- `? super Manager` 代表这个泛型是 Manager 的父类；

但是，在运行时阶段是不存在类型参数的。我们从编译器的角度考虑一下方法：

```java
void setFirst(? super Manager)
? super Manger getFirst()
```

对于方法 `setFirst()` ：
在经过类型擦除之后，编译器无法得知 `? super Manager` 指的是哪一个超类，因此不能接受类型 `Employee` 或 `Object` ，只能接受 `Manager` 类型。
对于方法 `getFirst()` ：
在经过类型擦除之后，编译器无法得知 `? super Manager` 指的是哪个超类，不能保证返回对象的类型正确，因此只能返回 `Object` 类；
