---
title: Golang 依赖管理-go mod
date: 2021-04-10
tags: []
categories:
  - 程序设计语言
  - Golang
---

## Golang 依赖管理-go mod

### Go Module

Go 语言在 1.11 版本之后发布了 `go module` 是目前最新的依赖管理工具了。
通过设置 `GO111MODULE` 的值可以开启或禁用 `go module` 工具。
`GO111MUDULE` 支持 `on` `auto` `off` 三种模式：

- `GO111MODULE=on` 编译时会忽略 GOPATH 和 vendor 文件夹，只根据 `go.mod` 加载依赖；
- `GO111MODULE=auto` 当项目在 `$GOPATH/src` 外，且项目根目录下有 `go.mod` 文件时，会开启模块支持；
- `GO111MODULE=off` 禁用 `go module` 支持，编译时会从 `$GOPATH` 和 `vendor` 下寻找依赖；

### Go PROXY

在 Go 1.13 之后 `GOPROXY` 的默认值为 `https://proxy.golang.org` ，在国内无法访问，所以可以设置为： `goproxy.cn`

```BASH
export GOPROXY=https://goproxy.cn
```

### go mod 命令

```BASH
go mod download         下载依赖的module到本地cache（默认为$GOPATH/pkg/mod目录）
go mod edit             编辑go.mod文件
go mod grap             打印模块依赖图
go mod init             初始化当前文件夹，删除无用的go.mod文件
go mod tidy             增加缺少的module，删除无用的module
go mod vendor           将依赖复制到vendor下
go mod verify           校验依赖
go mod why              解释为什么需要依赖
```

### go.mod

`go.mod` 文件记录了项目所有的依赖信息，其结构大致如下：

```code
module github.com/Q1mi/studygo/blogger

go 1.12

require (
    github.com/DeanThompson/ginpprof v0.0.0-20190408063150-3be636683586
    github.com/gin-gonic/gin v1.4.0
    github.com/go-sql-driver/mysql v1.4.1
    github.com/jmoiron/sqlx v1.2.0
    github.com/satori/go.uuid v1.2.0
    google.golang.org/appengine v1.6.1 //indirect
)
```

其中，

- `module` 定义了包名
- `require` 定义依赖以及版本
- `indirect` 表示间接引用

#### 语义化的版本号

比如 `go get foo@v1.2.3` ，也可以跟 git 的 tag 或者 branch ，比如 `go get foo@master` ，当然也可以跟 git 提交 hashcode 比如 `go get foo@3702bed2` 。关于依赖的版本支持以下几种格式：

```code
gopkg.in/tomb.v1 v1.0.1-20141024135613-dd632973f1e7
gopkg.in/vmihailenco/msgpack.v2 v2.9.1
gopkg.in/yaml.v2 <= v2.2.1
github.com/tatsushid/go-fastping v0.0.0-20160109021039-d7bb493dee3e
latest
```

#### replace

在国内访问 golang.org/xxx 的包都要翻墙，可以在 `go.mod` 中使用 `replace` 语法将 `require` 的包替换成 github 或者 gitee 上相应的库。

```code
replace (
    golang.org/x/crypto v0.0.0-20180820150726-614d502a4dac => github.com/golang/crypto v0.0.0-20180820150726-614d502a4dac
    golang.org/x/net v0.0.0-20180821023952-922f4815f713 => github.com/golang/net v0.0.0-20180826012351-8a410e7b638d
    golang.org/x/text v0.3.0 => github.com/golang/text v0.3.0
)
```

#### go get

`go get` 是下载依赖的命令，还可以指定版本。如果是下载所有依赖，可以用 `go mod download` 。

#### 整理依赖

在代码中删除了依赖项之后，在 `go.mod` 文件中并不会删除，我们需要用 `go mod tidy` 命令更新 `go.mod` 中的依赖关系；

#### go mod edit

`go mod edit -fmt` 帮助我们格式化 `go.mod` 文件，使文件不会因为手动修改而太乱。
