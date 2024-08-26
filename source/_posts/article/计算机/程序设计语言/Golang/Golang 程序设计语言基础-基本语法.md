---
title: Golang 程序设计语言基础-基本语法
tags: []
categories:
  - article
  - 计算机
  - 程序设计语言
  - Golang
date: 2021-03-05 00:00:00
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

## 基本语法

### 常用转义字符

`\t` 制表符
`\n` 换行符
`\r` 回车（从头覆盖，不会换行）
`\\` \
`\"` "

### 导包

GO 的包的概念，有点像文件夹，包下面还有子包，文件下还有子文件夹，有对应关系；
如果使用 gomodules 管理项目的包，那么新建项目的时候需要执行：

```shell
go mod init <project name>
```

项目路径：

```shell
└─go_code
    ├─ex-1
    │  │  go.mod
    │  │
    │  ├─main
    │  │      hello-world.exe
    │  │      hello-world.go
    │  │
    │  └─package
    └─ex-2
```

go.mod 文件内容：

```mod
module go_code/ex-1

go 1.14
```

```go
package main

import (
	"fmt"
	"math"
	"math/rand"
)

func getPi() {
	fmt.Println(math.Pi)
}

func main() {
	fmt.Println(rand.Intn(10))
	getPi()
}

```

### 函数

```go
// 省略
// 1. 下面两个函数功能是一样的
func foo1(x, y int) int {
    return 1
}

func foo2(x int, y int) int {
    return 2
}

// 2. 返回多值
func foo3(x int, y int) (string, string) {
	if x > y {
		return "bigger", "smaller"
	} else {
		return "smaller", "bigger"
	}
}

// 3. 命名返回值，这样 return 就不需要省略返回对象了
func foo4(x, y int) (sum int) {
    sum = x + y
    return
}
```

### 变量

```go
// 类型声明在后面
// 局部变量不使用会报错
// 全局变量不会
var x int

// 变量列表
var a, b int = 1, 2

// 类型省略
var c, cpp, java, python = 1, "2", true, false

// 短变量声明
// 注意该方法只能在函数内使用
// 函数外的声明语句必须在关键字后面
k := 3

// 分组的方式定义
var (
    x_11, x_12, x_13 = 1, 2, 3
    x_21, x_22, x_23 = 4, 5, 6
    x_31, x_32, x_33 = 7, 8, 9
)

// 变量默认值为零值
var a int // 0
var b string // ""
var c bool // false

// 类型转换，只能显式转换
var i int = 42
var f float = float(i)
var u uint = uint(f)

// 类型推导
// 未定义类型的数据，类型由右值决定，取决于精度
i := 42           // int
f := 3.142        // float64
g := 0.867 + 0.5i // complex128

// 匿名变量
func getTwoValue() (string, string) {
	return "看得到我", "看不到我"
}
// 只有 i 接收到了值
// _ 不占用空间，相当于把后面的值丢弃了
i, _ = getTwoValue()
```

### 常量

```go
// 声明常量，不能使用 := 定义
const Pi = 3.14
const world = "世界"
const yes = true
// 数值常量
const (
    // float
    // 1000....00 左移位运算符
    // 相当于二进制 1后面跟了 100 个零
    Big = 1 << 100
    // 类型未定 int 还是 float 由上下文决定
    // (10)2 = (2)10 左移运算符
    Small = Big >> 99
)

func needInt(x int) int { return x*10 + 1 }
func needFloat(x float64) float64 {
	return x * 0.1
}
needInt(Small) // int
needFloat(Small) // float

// 缺省值自动填充
const (
    a = 100
    b
    c
)
fmt.Print(a, "\t", b, "\t", c)
// 100  100 100

// iota 常量计数器
// 每增加一行常量，值就 +1
const (
    x = iota
    y
    z
)

fmt.Println(x, " ", y, " ", z)
// 0 1 2
```

### 基本类型

`bool` `string`
`int` `int8` `int16` `int32` `int64`
`uint` `uint8` `uint16` `uint32` `uint64` `uintptr`
`byte` // uint8 的别名
`rune` // int32 的别名 表示一个 unicode 码点
`float32` `float64`
`complex32` `complex64`
`int`, `uint` 和 `uintptr` 在 32 位系统上通常为 32 位宽，在 64 位系统上则为 64 位宽。 当你需要一个整数值时应使用 `int` 类型，除非你有特殊的理由使用固定大小或无符号的整数类型。

### 流程控制语句

#### 循环

```go
// 循环，定义的量作用域在大括号内
for i := 0; i < 10; i++ {
    sum += i;
}

// 省略初始化和后置语句
sum := 1
for ; sum < 1000 ; {
    sum += sum
}

// 上面这种情况可以去掉分号
sum := 1
for sum < 1000 {
    sum += sum
}

// 无限循环
sum := 1
for {
    fmt.Println("I can't get out!")
}

// for range 写法
// 专门用来遍历数组、切片、字符串、map和通道
s := "Hello"
for i, v := range s {
    fmt.Printf("%d %c \n", i, v)
}
// 0 H
// 1 e
// 2 l
// 3 l
// 4 o

// 跳出循环
i := 10
for {
    if i == 5 {
        break
    }
    i--
}

// 跳过一次循环
for i := 0; i < 10; i++ {
    if i == 5 {
        continue
    }
    fmt.Println(i)
}
```

#### 条件判断

```go
// 条件判断
// 简单的 if 语句
x int = 10
if x > 5 {
    fmt.Println("bigger than 5")
}

// 执行一个简短的语句在判断，作用域在大括号内
if v := math.Pow(x, n); v < lim {
    return v
}
return lim

// 如果有 else 那么 else 块中也能使用
if v := math.Pow(x, n); v < lim {
    return v
} else {
    fmt.Printf("%g >= %g\n", v, lim)
}

// switch 判断
// 1. 注意 Golang 的 switch 不需要 break
//  （已经自动添加了）
// 2. 如果要求执行后面的那个 case ，
//    就以 fallthrough 结束（最好不用）
// 3. case 无需为常量，取值也无需为整数
switch os := runtime.GOOS; os {
    case "darwins":
        fmt.Println("OS X.")
    case "linux":
        fmt.Println("Linux")
    default:
        // freebsd, openbsd,
        // plan9, windows...
        fmt.Printf("%s.\n", os)
}

```

#### 占位符

上面的输出语句中用了比较多的[占位符](https://studygolang.com/articles/2644)

- `%g` ：紧凑格式输出的浮点数（复数）占位符；
- `%v` ：相应值的默认格式；
- `%+v` ：打印结构体的时候，会添加字段名；
- `%t` ：布尔占位符；
- `%b` ：二进制占位符；
- `%d` ：十进制占位符；
- `%o` ：八进制占位符；
- `%x` 或 `%X` ：十六进制占位符，区别是 abc 和 ABC ；
- `%T` ：显示相应类型；
