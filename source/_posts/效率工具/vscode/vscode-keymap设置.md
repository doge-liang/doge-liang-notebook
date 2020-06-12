---
title: vscode-keymap设置
date: 2020-06-01
tags: [vscode]
categories: 

    - [效率工具]

---

# 打开设置文件

路径：File > Perferences > keyboard shortcuts

或者快捷键 Ctrl+K Ctrl+S
搜索自己希望设置的功能，比如新建文件：explorer.new.*
设置好对应的快捷键后点击 vscode 左上角的第一个按钮

![keyboard shortcuts](./assets/KeyboardShortcuts.jpg)

显示如下设置：

``` json
// Place your key bindings in this file to override the defaultsauto[]
[
    {
        "key": "alt+n f",
        "command": "explorer.newFile",
        "when": "explorerResourceIsFolder"
    },
    {
        "key": "alt+f",
        "command": "explorer.newFolder",
        "when": "explorerResourceIsFolder"
    }
]
```

自行添加 `when` 对应的状态，设置快捷键触发的情况，具体的参数在[官方文档](https://code.visualstudio.com/docs/getstarted/keybindings)可以查询，外国网站访问过慢，可以参考 csdn 的一篇[文章](https://blog.csdn.net/u011511756/article/details/85058990)
