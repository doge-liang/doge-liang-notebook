# Vim使用笔记

###### 命令模式(Normal):

- **i**-进入*Insert模式，按Esc可退回Normal模式
- **x**-删除光标所在的字符
- **:wq**-存盘退出（*:w*存盘，*:q*退出，*:w*后面可以加文件名)
- **dd**-删除当前行，并保存到剪切板
- **p**-粘贴
- **hjkl**-左上下右
- **:help<command>**-显示相关命令的帮助

###### 命令模式拓展：

1. 各种插入模式
- **a**-在光标后插入
- **o**-在当前行后插入一个新行
- **cw**-替换光标所在未知到下一个空格处的字符

2. 简单的移动光标

- **0**-到行头
- **^**-到本行第一个不是空格字符的位置
- **$**-到本行行尾
- **g_**-到本行最后一个不是空格字符的位置
- **/pattern-**搜索 *pattern* 字符串，有多个匹配可使用*n*去往下一个匹配字符串

3. 拷贝/粘贴

- **p**-粘贴在当前位置之后
- **P**-粘贴在当前位置之前
- **yy**-拷贝当前行到ddp

4. Undo/Redo

- **u**-undo
- **<C-r>**-redo

5. 打开/保存/退出/改变文件(Buffer)

- **e <path/to/file>**-打开一个文件
- **:w**-存盘
- **:savea <path/to/file>**-另存为*<path/to/file>*
- **:x,ZZ**或**:wq**-保存并退出(*:x*表示仅在需要时保存)
- **:bn和:bp**-同时打开很多文件时，可以用这两个命令进行切换上一个文件和下一个文件，*:n*也可以切换到下一个文件

###### 更好更快更强

- **.**-重复上一次命令
- **N<command>**重复某个命令n次
- 2dd → 删除2行
- 3p → 粘贴文本3次
- 100idesu [ESC] → 会写下 “desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu desu “
- . → 重复上一个命令—— 100 “desu “.
- 3. → 重复 3 次 “desu” (注意：不是 300，你看，VIM多聪明啊) 

- **NG**-移动到第N行
- **gg**-移动到第一行
- **G**-到最后一行
- 按单词移动

    - **w**-到下一个单词开头
    - **e**-到下一个单词结尾
    - **%**-匹配括号移动
    - **'*'和#**-匹配光标当前单词，*下一个，#上一个

- 命令联动

    - **0y$**-从行头拷贝到行尾
    - **ye**-从当前光标拷贝到本单词最后一个字符
    - **gU**-变大写
    - **gu**-变小写
