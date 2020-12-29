---
title: Java程序设计语言基础-泛型
date: 2019-10-01
tags: [程序设计语言, Java]
categories:
	- [程序设计语言]
---

## Java 程序设计语言基础

### 先验知识

#### Java 语言规范、API、JDK、IDE

- Java 语言规范就是 Java 的语法，完整的定义在 https://docs.oracle.com/javase/specs/ 中可以找到；
- API(Application Program Interface) 也称为 *库* ，包括开发 Java 程序预定义的类和接口；
- JDK(Java Development Toolkit)，Java 开发工具包，每个版本都有对应的 Java 开发工具包， Java SE 8 的工具包为 JDK 1.8 = Java 8 = JDK 8
- IDE(Integrated Development Environment) 集成开发环境，将程序的编辑、编译、链接、调试都放在一个界面中。IDE 没有出现的时候，程序员需要使用专门的文本编辑软件编写源代码，然后使用命令行工具调用 JDK 中的Java 开发工具，比如编译器、链接器等，生成调试文件，使用 JDK 中的调试器来查看结果；

Java 的三个版本：

- Java SE，Java 标准版，用于客户端开发；
- Java EE，Java 企业版，用于服务器端开发；
- Java ME，Java 微型版，用于移动开发；

#### 创建、编译和执行 Java 程序

- `.java` 文件存放源代码；
- `.class` 文件为编译生成文件，由 JVM(Java Virtual machine) 执行；

![picture 1](assets/38161b86580243532b4bf2793197f37ecd7be2548c64fdbf8176cb7545f86239.png)  

#### 一个简单的例子

``` JAVA
// Welcome.java
public class Welcome {
	public static void main(String[] args) {
		System.out.println("Welcome to Java!");
	}
}
```

通过命令行调用 jdk 编译器生成字节码文件（可执行文件、`.class` 文件），通过 JVM 执行。

``` BASH
#cmd
javac Welcome.java
java Welcome
# Welcome to Java!
```

在执行一个 Java 程序时， JVM 首先使用 *类加载器（class loader）* 将字节码载入到内存中，每个类在使用之前都需要被动态地载入到内存中。类被加载进内存之后， JVM 会使用 *字节码验证器（bytecode verifier）* 对字节码进行验证，以保证程序符合安全规范不会篡改或者危害计算机。

#### 代码规范

规范的注释：

``` JAVA
// 行注释风格
/**
块注释风格
**/
```

两种块代码风格：

``` JAVA
// 次行风格 next-line style
public static void main(String[] args) {
	...
}
```

``` JAVA
// 行尾风格 end-of-line style
public static void main(String[] args) 
{
	...
}
```

两种风格选哪种都可以，就是要统一，不要造成代码混乱。

#### 三种程序错误

- 语法错误：缺少必要的关键字、符号或者顺序出错之类的；
- 运行时错误：程序因非正常原因终止，称为运行时错误，比如除 0 错误，内存溢出等等；
- 逻辑错误：没有按照预期输出想要的结果，比较难以察觉；

### 基本程序设计

#### 合法的标识符

- 标识符是由字母、数字、下划线（-) 和美元符号（$) 构成的字符序列。
- 标识符必须以字母、下划线（_)或美元符号（$) 开头，不能以数字开头。
- 标识符不能是保留字（参见 [保留字列表](www.baidu.com)）。
- 标识符不能是 `true` 、 `false` 或 `null`。
- 标识符可以为任意长度。

标识符

#### 泛型

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


