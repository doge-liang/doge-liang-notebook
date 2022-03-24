---
title: reset
date: 2021-10-07
tags: []
categories:
  - 工具
  - git
---

## reset

### 修改 HEAD 指针的撤销

![image](https://img2020.cnblogs.com/blog/2490228/202110/2490228-20211005205020669-7082147.png)

HEAD 是一个指针，每次 `commit` 操作都会使其移动至当前最新的提交节点处，通过 `reset` 命令我们可以让 `HEAD` 指针往前移动，即撤销上次 `commit` 操作。

`reset` 有三个参数，实际上是三个撤销级别：

- `--soft` 仅撤回 `commit` 节点指向， `Index` 和 `Working Directroy` 的修改还存在；
- `--mixed` 撤回 `commit` 结果和 `Index` 中 `git add ...` 的操作；（`git reset HEAD~` 默认参数）
- `--hard` `commit` `add` 和本地的为暂存的修改全部都被撤回；（慎用，此操作会丢失所有更改）

### 提供路径的撤销

通过提供路径，我们可以值撤回一部分文件或者文件集合的修改，这种方式不用变动 HEAD 指针，实际上是将文件在 HEAD 、 Index 和 Working Directory 中移动。

`git reset file.txt` 相当于 `git reset --mixed HEAD file.txt` 即是从 `HEAD` 指向的 commit 中获取 file.txt 放到 Index 中。
这可以起到 **取消暂存文件** 的作用，与 `git add` 正好相反，利用这一特性，我们可以压缩提交。

#### 压缩提交

我们每天都提交代码，但是并不是每次提交代码都需要保留历史记录的，一些诸如漏提交文件、漏配置项的提交可以被裁剪掉。

![image](https://img2020.cnblogs.com/blog/2490228/202110/2490228-20211005205448424-343280328.png)

图中的 `file-a.txt v2` 是一个未完成状态，可以被裁剪掉，不影响回溯。
可以执行 `git reset --soft HEAD~2` 把 `HEAD` 往前移动两个提交的位置，此时状态如下：

![image](https://img2020.cnblogs.com/blog/2490228/202110/2490228-20211005205111482-1774084290.png)

此时再执行 `git commit` 把暂存区的文件提交，`HEAD` 指针便无法回溯到含有 `file-a.txt v2` 的 commit 节点了。

![image](https://img2020.cnblogs.com/blog/2490228/202110/2490228-20211005205306860-374662520.png)

### 移动分支指向

`git reset <branch>` 还会移动分支的指向，这个 `git checkout` 做不到的，下图是在 develop 分支执行 `git reset master` 分支的结果：

![image](https://img2020.cnblogs.com/blog/2490228/202110/2490228-20211005205231560-1545687443.png)
