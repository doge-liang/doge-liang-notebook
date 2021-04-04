---
title: Jupyter Notebook的使用
date: 2019-10-10
tags: [Jupyter Notebook]
categories: 
    - 程序设计语言
    - python

---

## Jupyter NoteBook

### 简介

Jupyter NoteBook 是一个基于IPython的开源Web应用。我们可以使用它来创建和分享包含实时代码和数据可视化的文档。我们可以在文档内看到程序的运行结果。用途多样，可以用于统计建模分析、机器学习、数据可视化等等。

### 安装

对于初学者，最简单的方式是安装 Anaconda。Anaconda是在数据科学领域最流行python发行版本，这个版本预装载了许多流行的库和工具，如NumPy，pandas和Matplotlib。  

对于熟悉python的程序员可以使用pip命令直接安装Jupyter，其他的包可以自行安装。

`pip3 install jupyter`

> tips: 通过 anaconda 安装的，可以有两种方式修改启动的初始目录：
>
> 1. 修改 **“Anaconda Prompt (Anaconda3)快捷方式”** 的 **“属性” - “起始位置”** 为目标目录。这样可以修改 Anaconda Prompt 的启动工作目录，执行 jupyter notebook 命令。也可以直接修改 **“Jupyter Notebook (Anaconda3)快捷方式”** 的 **“目标”** ，这样从开始中直接唤出也可以直接进入目标工作目录；
> 2. 将目标目录写进环境变量中（系统和用户对机主差别应该不大），然后将写入的环境变量添加进 Path 中；

### 创建第一个NoteBook

打开Anaconda prompt，cd到存储笔记的目录。输入jupyter notebook命令运行jupyter notebook。  
程序自动打开一个浏览器窗口，如下：

![picture 19](../../../../assets/%E7%A8%8B%E5%BA%8F%E8%AE%BE%E8%AE%A1%E8%AF%AD%E8%A8%80/python/Jupyter%20NoteBook%20%E4%BD%BF%E7%94%A8/357056832e198d627af5ad5e634a548ca688f56d6f6ac2e04b5df6ec2d0b67f7.png)  

我们可以在这个窗口创建jupyter notebook

### kernel

kernel是一个计算机引擎，用来执行code中的代码的。

### cell

notebook被分为一个个的cell，cell的样式可以被设置为code和Markdown。code的cell可以被运行，输出被放在下面作为新的cell插入。  
Markdown的cell中可以使用Markdown格式进行编写，插入公式等等操作都可以利用Markdown实现。

### 好用的快捷键

`ctrl+shift+P`打开快捷键卷轴

`ctrl+Enter`执行选中cell的代码  
`shift+Enter`执行选中cell的代码并跳到下一个cell  
`Esc`跳出编辑模式  
`m`将该cell变成Markdown  
`y`将该cell变成code  
`1-6`将该cell变成heading 1-6  

### Tips

#### 使一个cell可以out出所有的结果

这个功能十分方便，使得我们不需要使用print即可输出变量。  
有两种配置方式：  

局部配置：  
在代码顶部添加：

```python
from IPython.core.interactiveshell import InteractiveShell
InteractiveShell.ast_node_interactivity = "all"
```

全局配置：  
创建`~/.ipython/profile_default/ipython_config.py`
输入命令：

```python
c = get_config()
c.InteractiveShell.ast_node_interactivity = "all"
```
