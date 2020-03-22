---
title: C语言程序设计
date: 2020-02-01
tags: [C语言]
categories:
    - [程序设计语言]
---
# C语言程序设计

## 变量

C程序的变量都必须声明后再使用

### 基本数据类型

- int16, int32
- short
- long
- float32
- double
- char8

### 格式输出

- %d 十进制整数
- %6d 按照至少6个字符宽打印整数
- %6f 按照至少6个字符宽打印浮点数
- %.2 按照小数点后至少2位打印浮点数

### 常量定义

```C
#define LOWER 0
#define UPPER 300
#define STEP 20
```

### I/O

C语言通常以流的方式读写字符；

- c = getchar() 读入一个char
- putchar(c) 写出一个char
- EOF
> 识别文本流末尾，是一个常量标识符；

