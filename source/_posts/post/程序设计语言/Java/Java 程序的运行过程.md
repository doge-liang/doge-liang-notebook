---
title: Java 程序的运行过程
date: 2021-03-07
tags: [Java]
categories:
  - 程序设计语言
  - Java
---

### Java 程序的运行过程

#### Java 内存分析

![picture 18](../../../../assets/%E7%A8%8B%E5%BA%8F%E8%AE%BE%E8%AE%A1%E8%AF%AD%E8%A8%80/Java/Java%E6%B3%A8%E8%A7%A3%E4%B8%8E%E5%8F%8D%E5%B0%84/4e8edf8f42ca4b84de99896a016b2294f6c4853658213aa276f30b1d4d1aca0d.png)

#### 类的加载过程

类的加载过程：（Load-Link-Initialize）

1. 类的加载（Load）：将类的 class 文件读入内存，并为之创建一个 `java.lang.Class` 对象。此过程由类加载器完成；
2. 类的链接（Link）：将类的二进制数据合并到 JRE 中；
   - 验证：确保加载的类信息符合 JVM 规范，不会出现安全问题；
   - 准备：正式为类变量（static 变量），分配内存并设置默认初始值，这些内存都在方法区中进行分配；
   - 解析：虚拟机常量池内的符号引用（常量名）替换为直接引用（地址）的过程；
3. 类的初始化（Initialize）：JVM 负责对类进行初始化；
   - 执行类构造器 `<clinit>()` 方法的过程。类构造器 `<clinit>()` 方法，是由编译器自动收集类中所有类变量的赋值和静态代码块中的语句合并产生的；（类构造器是构造类信息的，不是构造类对象的）
   - 当初始化一个类的时候，如果发现其父类还没有初始化，则需要先触发其父类的初始化；
   - 虚拟机会保证一个类的方法在多线程的环境中被正确加锁和同步；

#### 类的初始化

类的主动引用（一定会发生类的初始化）

- 当虚拟机启动，先初始化 main 方法所在的类；
- new 一个类的对象；
- 调用类的静态成员（除了 final 常量）和静态方法；
- 使用 java.lang.reflect 包的方法对类进行反射调用；
- 当初始化一个类，如果其父类没有被初始化，则先会初始化它的父类；

类的被动引用（不会发生类的初始化）

- 当访问一个静态域时，只有真正声明这个域的类才会被初始化。如：当通-过子类引用父类的静态变量，不会导致子类初始化；
- 通过数组定义类引用，不会触发此类的初始化，`Son[] array = new Son[5];`；
- 引用常量不会触发此类的初始化（常量在链接阶段就存入调用类的常量池中了）；

#### 类的加载器

类加载器（ClassLoader）的作用就是用来把类装载进内存的。JVM 规范定义了如下几类加载器：

- 引导类加载器：用 C++ 编写的，是 JVM 自带的类加载器，负责 Java 平台核心库，用来装载核心类库。**无法直接获取。**
- 扩展类加载器：负责 re/lib/ext 目录下的 jar 包或-D java.ext.dirs 指定目录下的 jar 包装入工作库；
- 系统类加载器：负责 java-classpath 或 -D java.class.path 所指的目录下的类与 jar 包装入工作，是最常用的加载器；

这些类加载器是自上而下加载，自下而上检查是否加载完成的。此外我们还可以自定义类加载器；

```JAVA
// 获取系统类加载器
ClassLoader systemClassLoader = ClassLoader.getSystemClassLoader();

// 获取系统类加载器的父类加载器-->扩展类加载器
ClassLoader extClassLoader = systemClassLoader.getParent();

// 获取扩展类加载器的父类加载器-->根加载器（是用C/C++写的）
ClassLoader rootClassLoader = systemClassLoader.getParent(); //null，因为无法获取

// 获得系统类加载器可以加载的路径
System.getProperty("java.class.path");

```

**双亲委派机制**：假如我自己定义了一个类 `java.lang.String` ，JVM 会从用户类加载器一层一层往上找，如果找到了就不会加载自己定义的这个 `java.lang.String` 类，这是处于系统安全性的考虑；
