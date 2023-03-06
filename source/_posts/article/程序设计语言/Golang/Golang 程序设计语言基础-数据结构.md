---
title: Golang 程序设计语言基础-数据结构
tags: []
categories:
  - article
  - 程序设计语言
  - Golang
date: 2021-04-10 00:00:00
---

## Golang 程序设计语言基础-数据结构

### 数组

```Go

// 数组

// 是存放元素的容器
// 必须指定存放元素的类型和长度

func main() {
	var a1 [3]bool

	fmt.Printf("a1:%T\n", a1)
	// a1:[3]bool
	// 长度是类型的一部分，长度不同的数组是无法比较和赋值的

	// 初始化
	fmt.Println(a1)
	// [false false false]
	// 默认用零值初始化，bool-false，int-0，float-0，string-""

	// 1. 一般的初始化方式
	a1 = [3]bool{true, true, true}

	// 2. 根据初始值推断长度
	a4 := [...]int{1, 2, 3, 4}
	fmt.Println(a4)
	// [1 2 3 4]

	// 3. 使用索引初始化
	a5 := [5]int{0: 1, 4: 2}
	fmt.Println(a5)
	// [1 0 0 0 2]

	// 数组的遍历
	citys := [5]string{"东莞", "广州", "深圳", "长春", "昆明"}

	// 1. 根据索引遍历
	for i := 0; i < len(citys); i++ {
		fmt.Println(citys[i])
	}
	// 东莞
	// 广州
	// 深圳
	// 长春
	// 昆明

	// 2. for range 遍历
	for i, v := range citys {
		fmt.Println(i, v)
	}
	// 0 东莞
	// 1 广州
	// 2 深圳
	// 3 长春
	// 4 昆明

	// 多维数组
	a11 := [3][4]int{
		{1, 2, 3, 4},
		{5, 6, 7, 8},
		{9, 10, 11, 12},
	}

	fmt.Println(a11)
	// [[1 2 3 4] [5 6 7 8] [9 10 11 12]]

	// 数组是值类型
	b1 := [3]int{1, 2, 3}
	b2 := b1
	b2[0] = 3
	fmt.Println(b1)
	// [1 2 3]
	fmt.Println(b2)
	// [3 2 3]

	// 因为是值类型，所以再赋值之后相当于重新创建了一个对象
	// 对新创建的对象的操作，不会影响原来的对象
}

```

### 切片
