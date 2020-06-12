---
title: python系统操作-os库的使用
date: 2020-05-27
tags: [程序设计语言, python]
categories: 
    - [程序设计语言]
---
# python-os库使用
官方文档：https://docs.python.org/3/library/os.html

## 文件读写
open()

## 路径操作

### os.path 
这是关于路径的底层操作接口，可能对使用不是很友好，官方文档更推荐高级的 O-O 模块 [pathlib](https://docs.python.org/3/library/pathlib.html#module-pathlib)

### pathlib
```python
from pathlib import Path
cwd = Path.cwd() # 获取工作路径
test = cwd/'test' # 特有的 Path 拼装方式，不存在也不要紧
test # WindowsPath('F:/笔记/srp/区块链/demo/爬虫整理/test')
if not test.exists():
    test.mkdir() # 创建路径
```

## 命令行读写文件
fileInput

## 创建临时文件和目录
tempfile

## 创建高级文件和目录
shutil
