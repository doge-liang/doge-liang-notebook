---
title: C语言程序设计基础-Hello world
date: 2020-02-01
tags: []
categories:
  - 程序设计语言
  - C
---

- [C 程序设计语言](#c-程序设计语言)
  - [入门](#入门)
  - [变量](#变量)
    - [基本数据类型](#基本数据类型)
    - [格式输出](#格式输出)
    - [常量定义](#常量定义)
    - [I/O](#io)

## C 程序设计语言

### 入门

C 语言是一门强类型面向过程编程的编程语言。

第一个 C 程序：

```C
#include <stdio.h> //标准库引用

main() //主函数定义 不接受参数值
{
	printf("hello, world\n"); //在屏幕输出hello, world
}
```

### 变量

C 程序的变量都必须声明后再使用

#### 基本数据类型

- int16, int32
- short
- long
- float32
- double
- char8

#### 格式输出

- %d 十进制整数
- %6d 按照至少 6 个字符宽打印整数
- %6f 按照至少 6 个字符宽打印浮点数
- %.2 按照小数点后至少 2 位打印浮点数

#### 常量定义

```C
#define LOWER 0
#define UPPER 300
#define STEP 20
```

#### I/O

C 语言通常以流的方式读写字符；

- `c = getchar()` 读入一个 char
- `putchar(c)` 写出一个 char
- `EOF`
  > 识别文本流末尾，是一个常量标识符；
