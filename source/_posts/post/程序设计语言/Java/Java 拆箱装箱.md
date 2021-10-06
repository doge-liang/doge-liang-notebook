---
title: Java 拆箱装箱
date: 2021-03-07
tags: []
categories:
  - 程序设计语言
  - Java
---

- [Java 拆箱装箱](#java-拆箱装箱)
  - [包装类](#包装类)
  - [自动拆装箱](#自动拆装箱)
    - [性能问题](#性能问题)
    - [重载方法调用混乱](#重载方法调用混乱)
  - [常量池](#常量池)

## Java 拆箱装箱

### 包装类

为了方便使用 Java 面向对象的相关特性，例如，泛型、反射、集合等。用包装类将基本类型包装成引用类型。

| 包装类      | 包装类转基本类型（拆箱） | 基本类型转包装类（装箱）       |
| ----------- | ------------------------ | ------------------------------ |
| `Integer`   | `Integer.valueOf(int)`   | `IntegerInstance.intValue()`   |
| `Byte`      | `Byte.valueOf(int)`      | `ByteInstance.intValue()`      |
| `Short`     | `Short.valueOf(int)`     | `ShortInstance.intValue()`     |
| `Long`      | `Long.valueOf(int)`      | `LongInstance.intValue()`      |
| `FLoat`     | `FLoat.valueOf(int)`     | `FLoatInstance.intValue()`     |
| `Double`    | `Double.valueOf(int)`    | `DoubleInstance.intValue()`    |
| `Boolean`   | `Boolean.valueOf(int)`   | `BooleanInstance.intValue()`   |
| `Character` | `Character.valueOf(int)` | `CharacterInstance.intValue()` |

### 自动拆装箱

是 Java 提供的语法糖，让我们可以无感使用包装类，由编译器自动完成拆装箱的过程，如：

```java
Integer a = 5; // 自动完成基本类型 5 到引用类型 Integer 的转换
int b = a; // 自动完成引用类型到基本类型的转换
```

#### 性能问题

但由于包装器类的拆装箱过于无感，有时会导致性能问题，如：

```java
Integer sum = 0;
for (int i = 0; i < 1000; i++) {
  sum += i;
}
```

以上代码经过编译器的转换后变成：

```java
Integer sum = 0;
for (int i = 0; i < 1000; i++) {
  sum = Integer.valueOf(sum.intValue() + i);
}
```

每次循环都要拆装箱一次，申请+释放了 1000 次的 Integer 对象。

#### 重载方法调用混乱

正常重载：

```java
static void func(int i) {
  System.out.println("Param is a int");
}

public static void main(String[] args) {
  func(new Integer(3));
  func(3);
}
```

输出结果为：

```java
// Param is a int
// Param is a int
```

重载混乱：

```java
static void func(int i) {
  System.out.prinln("Param is a int");
}

static void func(Object i) {
  System.out.println("Param is a Integer");
}

public static void main(String[] args) {
  func(new Integer(3));
  func(3);
}
```

输出结果为：

```java
// Param is a Integer
// Param is a int
```

结论：当遇到更匹配的重载方法时，不会自动拆装箱；

### 常量池

由于包装类的创建很浪费性能，所以 Java 对简单的数字(-128~127)对应的包装类进行了缓存，称为常量池。
通过**直接量赋值**的包装类如果在这个范围内，会直接使用常量池中的引用。

例如：

```java
Integer i1 = 100;
Integer i2 = 100;
System.out.println(i1 == i2); // true
```

而正常来说，包装类属于引用类型，即使是值相等的两个包装类，其引用不同，应该返回 `false` 。通过 `new` 创建一个新的包装类实例可以避免使用常量池的引用；

```java
Integer i1 = 100;
Integer i2 = new Integer(100);
System.out.println(i1 == i2); // false
```
