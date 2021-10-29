---
title: Golang 程序设计语言基础-结构体
date: 2021-04-10
tags: []
categories: 
    - 程序设计语言
    - Golang
---

## Golang 程序设计语言基础-结构体

### 自定义类型和类型别名

``` Go
package main

import "fmt"

// 自定义类型
type myInt int

// 类型别名
type yourInt = int

func main() {
	var n myInt
	n = 100
	fmt.Println(n)
	fmt.Printf("%T\n", n)

	var m yourInt
	m = 200
	fmt.Println(m)
	fmt.Printf("%T\n", m)
}
```

输出：

``` code
100
main.myInt
200
int
```

类型别名的类型本质上还是原来的类型，源代码经过编译之后，还是会变成原来的类型。这是为了代码编写时，丰富类型的含义，尽管两种类型使用的底层类型是同一个类型，但我们能够从源码层面区分这两种类型，便于理解；
而自定义类型已经不是