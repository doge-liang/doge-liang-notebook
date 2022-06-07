---
title: git-ssh
date: 2020-06-20
tags: [ssh]
categories:
  - 工具
  - git
---

## How to use ssh in git

### generate the ssh key in local pc

```BASH
ssh-keygen
```

随后提示输入 `id_rsa` 文件保存位置
随后输入两次密码，就设定成功了
在密码保存位置会出现四个文件分别是 `id_rsa` `id_rsa.pub` `known_hosts` `config`，其中的 `.pub` 文件中保存了公钥，运行

```BASH
cat id_rsa.pub
```

将文件内容复制下来

### prepare a git account

click the setting at the top-left corner.

![picture 24](../../../../assets/%E5%B7%A5%E5%85%B7/git/git-ssh/b9ed120ce8a918731007a77fad7a3a4c838d2637d128a6c8e3e8bce743521f43.png)

![picture 25](../../../../assets/%E5%B7%A5%E5%85%B7/git/git-ssh/5e0cfef621cbe20c38a15094443810f3d7dda20aca7b1f35e20b66f3c4252b5d.png)

![picture 26](../../../../assets/%E5%B7%A5%E5%85%B7/git/git-ssh/36db3af5779fdf07bd2aeb5aae0b6c5eb4d2f95b53fee84507c27ad806aa069b.png)

点击图中的 `New Repository` 按钮，将刚刚复制的内容粘贴进去就可以完成 ssh key 的配置了。

以后 push 内容到 github Repository 中便会要求输入 ssh 密码了。
