---
title: Golang 一些特殊的导包方法
date: 2021-04-11
tags: []
categories:
  - 程序设计语言
  - Golang
---

## Golang 一些特殊的导包方法

```Go
package main

import (
	. "fmt"
	f "fmt"

	// call the 'init' function in fmt, unnecessary to use the lib
	_ "fmt"
)

func main() {
	Println("call fmt without prefix")
	f.Println("call fmt with alias")

}
```

另外还能用相对路径和绝对路径来导包。

```Go
import   "./model"  //当前文件同一目录的model目录，但是不建议这种方式import
import   "shorturl/model"  //加载GOPATH/src/shorturl/model模块
```
