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
void setFirst(? super Manager obj) {
	//...
}
? super Manger getFirst() {
	//...
}
```

对于方法 `setFirst()` ：
编译器无法得知 `? super Manager` 指的是哪一个超类，因此不能接受类型 `Employee` 或 `Object` ，只能接受 `Manager` 类型。
对于方法 `getFirst()` ：
编译器无法得知 `? super Manager` 指的是哪个超类，不能保证返回对象的类型正确，因此只能返回 `Object` 类；

```java
void setFirst(Test<? extends Employee> obj) {
	//...
}
? extends Employee getFirst() {
	//...
}
```

> **协变**：原父子类型关系在经过复杂类型构造之后，父子类型关系被保持下来了；
> **逆变**：原父子类型经过类型构造之后，父子关系逆转；
> **不变**：上述两种不适用；

#### Producer Extend Consumer Super(PECS)

考虑 `List<? extends T> list` ：
`list.add(something)` 会报错，因为编译器只知道要存的是 `T` 的子类，但是不知道是哪个子类，不能保证类型安全，所以禁止存，只能保证取出来的是 `T` 的子类，所以可以生产 `T` 以及 `T` 的父类型的数据；
考虑 `List<? super T> list` ：
`list.get()` 会报错，因为编译器只知道里面存的是 `T` 的父类，但是不知道是哪个父类，不能保证类型安全。但编译器知道，`T` 以及 `T` 的子类都能够和 `T` 的某个父类兼容，所以可以使用 `list.add(t)` 存放对象。

<!--
考虑 `List<? extends Animal>` 和 `List<? extends Cat>` ：
`Cat` 是 `Animal` 的子类，而 `List<? extends Cat>` 也是 `List<? extends Animal>` 的子类，我们称之为 *通配符类型是在**上界协变**的*；

考虑 `List<? super Animal>` 和 `List<? super Cat>` ：
`Animal` 是 `Cat` 的父类，而 `List<? super Animal>` 是 `List<? super Cat>`  -->
