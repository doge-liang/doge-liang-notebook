---
title: Golang 程序设计语言基础-概述
tags: []
categories:
  - article
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

## Golang 程序设计语言基础-概述

### 优势领域

- 数据处理
- 并发
- 区块链（兼容性）

### 设计背景

现有编程语言没办法发挥多核 cpu 优势（cuda？）
编程风格不统一，计算能力不够强，并发处理差（Java？）
编译语言编译过程慢，解释语言运行慢，要综合他们的优势。

### 语言特性

Go = Pyhton + C

提供了 C 的指针特性，使用 Python 编程风格。

静态语言：运行时，变量类型必须明确，是类型安全的（你调用某个函数的时候，期望接受一个叫做 id 的字符串，不是字符串 IDE 会报类型不兼容错误，但是动态语言意味着，编译器也不知道你传的类型符不符合要求，直到测试的时候才能发现错误）；
动态语言：运行时，变量类型是不明确的，赋值那一刻才知道变量的类型；

保留了 C 的很多语言特性，并且弱化了指针；
强制归入包，类似 Java；
垃圾回收机制，类似 Java；
语言层面实现并发，实现简单 （goroutine）；
管道通信机制 （Chanel)；
支持函数多值返回；
切片（动态数组），延时执行（defer）（类似回调？）

### 开发工具

VS Code + GO SDK 1.16.3

### 第一个程序 Hello world

项目路径：

```code
learning-go # $GOPATH 的路径
└─src # 源代码
    └─go_code # 项目
        ├─ex-1
        │  ├─main
        │  │      hello-world.go
        │  │      main.exe
        │  │
        │  └─package
        └─ex-2
```

```go
package main

import "fmt"

func main() {
	fmt.Println("Hello world")
}

```

1. `main()` 是入口函数；
2. `import` 是导入包；
3. `func` 是声明函数；
4. `package xxx` 是声明包；
5. **注意** go 语言导入的包和定义的变量没有用到是不通过编译的（节约资源）；
6. `gofmt -w hellow-world.go` 格式化代码；
7. 代码过长换行展示；
8. 大括号只有一种写法；

#### 执行方式

- `go build`：
  编译生成 .exe 文件（编译语言的方式，一次编译，多次运行）
  生成文件相对源代码大很多，自动添加环境变量；

  - `[-o]` 参数，后接生成文件名；

- `go run`：
  自动使用编译器将源代码编译，再执行（脚本语言的方式，一边解释，一边执行）

#### 依赖安装问题

由于 golang.org 在国内无法访问

- 翻墙下载
- 先 git 源码，再本地安装
- 通过设置代理 GOPROXY（推荐）

1. 先写 GOPROXY 方法，其他的不知道为什么试了没用；
   <https://goproxy.io/zh/>
   就一条命令：

   ```shell
   go env -w GO111MODULE=on
   go env -w GOPROXY=https://goproxy.io,direct
   ```

   然后通过正常的安装命令完成安装，下一种方法贴了代码；

2. 使用 git 源码再安装的方法。
   在 Golang SDK 安装目录新建 `src/golang.org/x/`

   ```shell
   mkdir src/golang.org/x/
   cd src/golang.org/x/
   git clone https://github.com/golang/tools.git tools
   git clone https://github.com/golang/lint.git lint
   git clone https://github.com/golang/mod.git mod
   git clone https://github.com/golang/xerrors.git xerrors
   git clone https://github.com/golang/net.git net
   ```

   获取依赖源代码：

   ```shell
   # 先从github下载依赖工具的源码，fetch提示timeout不要管
   go get -v github.com/ramya-rao-a/go-outline
   go get -v github.com/acroca/go-symbols
   go get -v github.com/mdempsky/gocode
   go get -v github.com/rogpeppe/godef
   go get -v github.com/zmb3/gogetdoc
   go get -v github.com/fatih/gomodifytags
   go get -v sourcegraph.com/sqs/goreturns
   go get -v github.com/cweill/gotests/...
   go get -v github.com/josharian/impl
   go get -v github.com/haya14busa/goplay/cmd/goplay
   go get -v github.com/uudashr/gopkgs/cmd/gopkgs
   go get -v github.com/davidrjenni/reftools/cmd/fillstruct
   go get -v github.com/alecthomas/gometalinter
   ```

   开始安装相关依赖：

   ```shell
   go install github.com/mdempsky/gocode
   go install github.com/ramya-rao-a/go-outline
   go install github.com/acroca/go-symbols
   go install golang.org/x/tools/cmd/guru
   go install golang.org/x/tools/cmd/gorename
   go install github.com/stamblerre/gocode
   go install github.com/ianthehat/godef
   go install github.com/sqs/goreturns
   go install golang.org/x/lint/golint
   ```
