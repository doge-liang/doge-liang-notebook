---
title: python打包方式
tags: []
categories:
  - article
  - 程序设计语言
  - python
date: 2019-10-10 00:00:00
---

## python 打包方式

- [python 打包方式](#python-打包方式)
  - [通过 pyInstaller](#通过-pyinstaller)

### 通过 pyInstaller

```shell
#单文件模式
pyinstaller -F myscript.py
#包含动态库的模式
pyinstaller myscript.py
#使用.spec文件进行高级打包操作
pyi-makespec optionsscript [scirpt...] #创建.spec文件
#在.spec文件内编辑
pyinstaller specfile
pyi-build specfile

```
