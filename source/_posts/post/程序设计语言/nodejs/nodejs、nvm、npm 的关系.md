---
title: nodejs、nvm、npm 的关系
date: 2021-03-13
tags: []
categories: 
    - 程序设计语言
    - nodejs
---

## node.js、nvm、npm 的关系

### node.js

node.js 是一个基于 Chrome V8 引擎的 Javascript 运行时，主要工作在服务器端。

node.js 的特点：

- 单线程
- 非阻塞 I/O
- 事件驱动
- 轻量、可伸缩

### nvm

nvm ，（Node Version Manager），是一个 node.js 的 版本管理工具。nvm 是基于 Linux/Mac OS 平台的工具，而 nvm-windows 则是基于 Windows 开发的另一款工具。但两者要完成的目标都是对 node.js 的版本管理。

### npm

npm 是 node.js 的第三方开源软件包的仓库，也可以用来进行 node.js 的第三方软件包管理器，通过命令行运行。

> 同样功能的还有 `Yarn` 。

### 三者关系

一个 nvm 管理多个版本的 node.js ，而每个 node.js 都有属于自己的 npm 包管理工具。
