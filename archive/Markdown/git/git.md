# Git

## 远程仓库

### 查看远程仓库

```shell
git remote -v //-v是为了显示对应的地址
```

### 添加远程仓库

我们可以指定一个简单的名字以便引用，运行`git remote add [shortName] [url]`：

```shell
$ git remote
origin
$ git remote -v
origin  http://liangyichao@xinyipig.xyz:3345/r/~ygs/linghong-pms-java.git (fetch)
origin  http://liangyichao@xinyipig.xyz:3345/r/~ygs/linghong-pms-java.git (push)
```

### 查看远程仓库信息

`git remote show [remoteName]`

```shell
$ git remote show origin
* remote origin
  Fetch URL: http://liangyichao@xinyipig.xyz:3345/r/~ygs/linghong-pms-java.git
  Push  URL: http://liangyichao@xinyipig.xyz:3345/r/~ygs/linghong-pms-java.git
  HEAD branch: master
  Remote branch:
    master tracked
  Local branch configured for 'git pull':
    master merges with remote master
  Local ref configured for 'git push':
    master pushes to master (up to date)
```

### 删除/重命名远程仓库

重命名：
`git remote rename [oldName] [newName]`

```shell
$ git remote rename origin LinghongPM
```

删除：
`git remote rm [remoteName]`

## 远程分支

### 创建远程分支


