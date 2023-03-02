---
title: stash
tags: []
categories:
  - article
  - 工具
  - git
date: 2021-10-07 00:00:00
---

## stash

将更改存储在脏工作目录（脏应该是不同步的意思，类似于 dirty data ）中。

使用场景示例：

修改了本地的代码，但还没 commit ，又需要去别的分支做一些操作。可以先把当前的更改 stash 起来，做完工作后 checkout 回来，然后把 stash 的内容从脏工作目录中读出来。

```bash
git stash save "Save Message" # 保存时添加备注信息，方便读出
git checkout someBranch
# do something
git checkout stashTest
git stash list # 查看 stash 栈的列表
git stash pop # 从 stash 栈中 pop 出上次的修改
git stash apply # 应用 stash 栈的存储，但不删除
git stash drop # drop 掉第一个 stash 存储
gti stash clear # 删除所有 stash
```

当合并分支时，出现 `Your files ... will be overwritten by merge ...` 之类的错误，都可以使用 `stash` 对未提交文件进行临时保存，再进行同步的操作。
