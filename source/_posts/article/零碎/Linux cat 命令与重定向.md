---
title: Linux cat 命令与重定向
tags:
  - cat
categories:
  - article
  - 零碎
date: 2021-07-25 00:00:00
---

## Linux cat 命令与重定向

`cat` 命令用于连接文件并输出到标准输出设备（打印机、显示器、文件、 U 盘等等）。常常和重定向符一起使用。

重定向符包括：

- 重定向输出 `>` `>>`
- 重定向输入 `<` `<<`

常用的命令：

```bash
# 从键盘读入，以 EOF 为结束符，输出到 aa.txt
cat << EOF > aa.txt
# << 重定向符后面跟的是定界符，即输入结束的标识
# < 重定向符的参数是文件，标识从文件输入

# 将把文件 b.txt 内容追加到 a.txt 末尾，如果 a.txt 没有就创建
cat b.txt >> a.txt
# 用 b.txt 文件的内容覆盖 a.txt 原有内容
cat b.txt > a.txt
```

通过管道命令 `|` 我们还能将 `cat` 的输出重定向到别的命令，比如 `jq` ，然后重定向输出到某个文件即可完成文件的格式化。

```bash
cat < unformat.json | jq . >> format.json
# < 可以省略
```
