---
title: Linux命令杂记
date: 2019-10-01
tags: [Linux, 操作系统]
categories: 

    - [操作系统]
    - [计算机基础]

---

## 转换到root用户

``` code
su root
```

## 修改root用户密码

``` code
sudo passwd root
```

## 修改ssh密码

``` shell
passwd [用户]

#输入新密码
#重新输入密码
```

## 安装软件

``` code
sudo yum install [Option] // RedHat-based
sudo apt-get install [Option] // CentOS-based
```

## 查看软件安装

**因为linux安装软件的方式比较多，所以没有一个通用的办法能查到某些软件是否安装。总结起来就是这几类：**  

1. rpm包安装的：用rpm -qa，如果查找某一软件包是否安装，用rpm -qa|grep "软件或包的名字";
2. deb包安装的：用dpkg -l，如果指定软件包，用dpkg -l|grep "软件或者包的名字";

## 文件操作命令

``` code
// 显示文件信息
ls [OPTION]... [FILE]...
// 按行显示
ls -1
// 显示具体信息
ls -l
// 显示子文件夹
ls [OPTION] -R
// 树形结构显示文件目录，使用tree，要自己安装
tree
// 显示到第N层
tree -L N
// 这两个命令参数非常多，-help参数查看帮助信息
ls -help
tree -help
```

## 软件安装/卸载

apt:

``` shell
apt-get install xxx xxx
apt install xxx xxx # 看apt的版本，新版的apt == apt-get
apt remove xxx xxx # 保留配置的卸载
apt purge xxx xxx # 不保留配置的卸载
apt update xxx xxx
apt upgrade xxx xxx
```

## 后台启动命令

``` shell
setsid [Option] [program]
```

## 文件和目录的维护

`chmod [mode] [path]` 修改目录的读/写/执行权限

- mode：代表权限模式
- path：表示作用目录

mode 有几种表示方式，一种是数字的表达方式

mode 可以写成三个八进制数字的组合，第一个数字表示文件所有者的权限，第二个表示所属组的权限，第三个表示其他用户的权限。

- 执行：`001`
- 写：`010`
- 读：`100`

注意和 `umask` 权限掩码的区别，权限掩码的各个位表示的意思和 `mode` 一样。但是 `umask` 中设置为 1 的位是表示剥夺该项权限的。因为赋予什么权限是由 `mode` 和 `umask` 之间 `AND` 的结果定。
