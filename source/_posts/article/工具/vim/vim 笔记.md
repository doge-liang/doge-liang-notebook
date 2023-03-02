---
title: vim 笔记
tags:
  - vim
categories:
  - article
  - 工具
  - vim
date: 2020-06-19 00:00:00
---

## vim 应用

### 块注释

添加注释：

1. `ctrl` + `v` 进入列模式， `I` 进入插入模式，输入注释符号
2. `esc` 退出列模式和视图模式

取消注释：

1. `ctrl` + `v` 控制方向键选中注释代码， `d` 删除注释符号

## Vim 使用笔记

###### 窗口多开和切换

- 横向切割窗口

`:new [windowName]` 横向切割，保存之后 windowName 就是文件名
`:split [windowName]` 同上

- 纵向切割窗口

`:vsplit [windowName]`

- 关闭多窗口

`:close` 关闭窗口，内容还在缓存中
`:q!` 强制退出，不保存
`:w!` 强制保存退出
`:x` 同上
`:tabc` 关闭当前窗口
`:tabo` 关闭所有窗口

- 窗口大小调整

  - 纵向调整

  - `ctrl+w` + 纵向扩大（行数增加）
  - `ctrl+w` - 纵向缩小 （行数减少）
  - `res(ize) num` 例如：:res 5，显示行数调为 5 行
  - `res(ize)+num` 把当前窗口高度增加 num 行
  - `res(ize)-num` 把当前窗口高度减少 num 行

  - 横向调整

    - `:vertical res(ize) num` 指定当前窗口为 num 列
    - `:vertical res(ize)+num` 把当前窗口增加 num 列
    - `:vertical res(ize)-num` 把当前窗口减少 num 列

`:f [fileName]` 窗口重命名
`vim fileA, fileB, fileC` 多文件打开
`:n ||[fileName]` 跳至下一个文件
`:Ex` 文件浏览器
`:[S/V]ex` 横向/纵向分割出文件浏览器
`:ls` 当前具体窗口信息

`:shell` 在不关闭 vim 的情况下，跳转到 shell

vim 有三个模式：命令模式、视图模式、编辑模式

###### 命令模式(Normal)

- `i` → 进入\*Insert 模式，按 Esc 可退回 Normal 模式
- `x` → 删除光标所在的字符
- `:wq` → 存盘退出（*:w*存盘，*:q*退出，*:w*后面可以加文件名)
- `dd` → 删除当前行，并保存到剪切板
- `p` → 粘贴
- `hjkl` → 左上下右
- `:help \<command\>` → 显示相关命令的帮助

###### 命令模式拓展

1. 各种插入模式

   - `a` → 在光标后插入
   - `o` → 在当前行后插入一个新行
   - `cw` → 替换光标所在未知到下一个空格处的字符

2. 简单的移动光标

   - `0` → 到行头
   - `^` → 到本行第一个不是空格字符的位置
   - `$` → 到本行行尾
   - `g_` → 到本行最后一个不是空格字符的位置
   - `/pattern` → 向下搜索 _pattern_ 字符串，有多个匹配可使用*n*去往下一个匹配字符串
   - `?pattern` → 向上搜索 _pattern_ 字符串，同上
   - `%s/xenial/bionic/g` → 整个文件内将 'xenial' 替换成 'bionic' ， 也可以指定行 `1,10s/xenial/bionic/g`

3. 拷贝/粘贴

   - `p` → 粘贴在当前位置之后
   - `P` → 粘贴在当前位置之前
   - `yy` → 拷贝当前行到 ddp

4. Undo/Redo

   - `u` → undo
   - `<ctrl-R>` → redo

5. 打开/保存/退出/改变文件(Buffer)

   - `e <path/to/file>` → 打开一个文件
   - `:w` → 存盘
   - `:savea <path/to/file>` → 另存为 `<path/to/file>`
   - `:x, ZZ` 或 `:wq` → 保存并退出( `:x` 表示仅在需要时保存)
   - `:bn和:bp` → 同时打开很多文件时，可以用这两个命令进行切换上一个文件和下一个文件，*:n*也可以切换到下一个文件

###### 更好更快更强

- `.` → 重复上一次命令
- `N \<command>` → 重复某个命令 n 次
- `2dd` → 删除 2 行
- `3p` → 粘贴文本 3 次
- `100idesu [ESC]` → 会写下 “desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu “
- `.` → 重复上一个命令—— 100 “desu “.
- `3.` → 重复 3 次 “desu” (注意：不是 300，你看，VIM 多聪明啊)

- `NG` → 移动到第 N 行
- `gg` → 移动到第一行
- `G` → 到最后一行
- 按单词移动

  - `w` → 到下一个单词开头
  - `e` → 到下一个单词结尾
  - `%` → 匹配括号移动
  - `*` 和 `#` → 匹配光标当前单词， `*` 下一个， `#` 上一个

- 命令联动
  - `0y$` → 从行头拷贝到行尾
  - `ye` → 从当前光标拷贝到本单词最后一个字符
  - `gU` → 变大写
  - `gu` → 变小写

###### 视图模式(visual mode)

`v` 进入视图模式，字符选择
`V` 进入视图模式，行选择
`<C-v>` 块选择
`y` 高亮位置复制
`d` 高亮位置删除
