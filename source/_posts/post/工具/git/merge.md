---
title: merge
date: 2021-10-07
tags: []
categories: 
    - 工具
    - git
---

## merge

合并分支。

```bash
git checkout target
git merge dev ## 合并 dev 的内容到 target
```

合并过程：

假设有如下分支：

```bash
       E----F  test
      /
A----B----C----D  HEAD/master
```

执行 `git merge test`
