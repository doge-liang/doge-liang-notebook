---
title: Linux命令杂记
date: 2019-10-01
tags: [Linux]
categories: 

    - [操作系统]

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
sudo apt-get install [Option] // Debian-based
```

## 查看软件安装

**因为linux安装软件的方式比较多，所以没有一个通用的办法能查到某些软件是否安装。总结起来就是这几类：**  

1. rpm包安装的：用rpm -qa，如果查找某一软件包是否安装，用rpm -qa|grep "软件或包的名字";
2. deb包安装的：用dpkg -l，如果指定软件包，用dpkg -l|grep "软件或者包的名字";

## 目录查阅命令

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

- Debian 系列：
apt:

``` shell
apt-get install xxx xxx
apt install xxx xxx # 看apt的版本，新版的apt == apt-get
apt remove xxx xxx # 保留配置的卸载
apt purge xxx xxx # 不保留配置的卸载
apt update xxx xxx
apt upgrade xxx xxx
```

- RedHat 系列：
yum:

``` BASH
yum install [RPM package]
yum remove [RPM package]
yum update [RPM package]
yum list
yum list installed
```

## 后台启动命令

``` shell
setsid [Option] [program]
```

## 文件和目录的维护

### 权限操作

`chmod [mode] [path]` 修改目录的读/写/执行权限

- mode：代表权限模式
- path：表示作用目录

mode 有几种表示方式，一种是数字的表达方式

mode 可以写成三个八进制数字的组合，第一个数字表示文件所有者的权限，第二个表示所属组的权限，第三个表示其他用户的权限。

- 执行：`001`
- 写：`010`
- 读：`100`

注意和 `umask` 权限掩码的区别，权限掩码的各个位表示的意思和 `mode` 一样。但是 `umask` 中设置为 1 的位是表示剥夺该项权限的。因为赋予什么权限是由 `mode` 和 `umask` 之间 `AND` 的结果定。

### 文件操作

#### 复制文件或目录

`cp` [参数] [文件]

![picture 8](../../../../assets/%E6%93%8D%E4%BD%9C%E7%B3%BB%E7%BB%9F/linux/Linux%E5%91%BD%E4%BB%A4%E6%9D%82%E8%AE%B0/ef0b611502dc124d89efc8243f3fd852fca246f73c31c935e9bd7579c51c156d.png)  

### 目录栈

目录栈是 Linux 维护目录的一个高级工具，顾名思义是一个存放目录的栈，栈顶代表现在正在使用的工作目录，使用

- `pushd`
- `popd`
- `dirs`

等等命令来操作目录栈。

`pushd` ：添加目录栈
用法： `pushd [-n] [+N | -N | dir]`
参数：
`+n` 切换目录，以当前目录为准，从右向左数第 n 个；
`-n` 切换目录，以当前目录为准，从左向右数第 n 个；

使用例子：

``` code
#这个符号~代表根home目录
root@localhost:ubuntu# pushd /root
~ /home/ubuntu      

#添加目录
root@localhost:ubuntu# pushd /home/ubuntu/download/
/home/ubuntu/download /home/ubuntu ~    

#添加目录
root@localhost:download# pushd /usr/local/
/usr/local /home/ubuntu/download /home/ubuntu ~    

#切换到了原始目录
root@localhost:download# pushd +1
/home/ubuntu ~ /usr/local /home/ubuntu/download
root@localhost:ubuntu#          

#切换到home目录
root@localhost:ubuntu# pushd +1
~ /usr/local /home/ubuntu/download /home/ubuntu  
root@localhost:~#              

#切换到了/usr/local目录
root@localhost:~# pushd -2
/usr/local /home/ubuntu/download /home/ubuntu ~
root@localhost:local#          
```

`popd` ：弹出目录栈
用法： `popd [-n] [+N | -N | dir]`
参数：
`+n` 删除pushd添加的目录，以当前目录为准，从左向右数，删除第 n 个；
`-n` 删除pushd添加的目录，以当前目录为准，从右向左数，删除第 n 个；

```code
#添加目录
root@localhost:dev# pushd /usr/
/usr /dev /home/ubuntu

#删除了/dev
root@localhost:usr# popd +1
/usr /home/ubuntu

#添加目录
root@localhost:usr# pushd /home/
/home /usr /home/ubuntu

#删除了/usr
root@localhost:home# popd -1
/home /home/ubuntu
```

`dirs` ：显示目录栈中的内容
用法： `dirs [-clpv] [+N] [-N]`
参数：
`+n` 以当前目录为准，显示从左边算起第 n 笔的目录；
`-n` 以当前目录为准，显示从右边算起第 n 笔的目录；
`-l` 显示目录完整的记录；

```code
#显示目录栈
root@localhost:ubuntu# dirs
/home/ubuntu /usr

root@localhost:ubuntu# dirs -1
/home/ubuntu 

root@localhost:ubuntu# dirs +1
/usr
```

### bash 脚本的零碎知识

`$(ls /etc)` 代表一条语句；
`$your_name` 或 `${your_name}` 代表定义过的变量；
`$1` 或 `$2` ... 等等，代表了执行 bash 脚本时传递的参数，数字代表参数的位置；


`export val_name` 设置环境变量；
> 环境变量和本地变量的本质区别在于遗传性，不管开了几个子进程，只要都还在这个环境工作，那么都能用到这个环境变量，而本地变量则是各自维护的；

#### shell 的字符串

`'string'` ：

1. 单引号字符串中的变量都会被当作字符串；
2. 转义字符无效；
3. 单引号字符串中不允许出现单独的单引号（转义也不行），成对的单引号会把字符串分割，可以用来做字符串拼接用；

`"string"` ：

1. 允许带有变量名，比如 `"My name is $name"`；
2. 转义字符有效；

##### 字符串拼接

``` BASH
your_name="runoob"
# 使用双引号拼接
greeting="hello, "$your_name" !"
greeting_1="hello, ${your_name} !"
echo $greeting  $greeting_1
# 使用单引号拼接
greeting_2='hello, '$your_name' !'
greeting_3='hello, ${your_name} !'
echo $greeting_2  $greeting_3
```

结果：

``` BASH
hello, runoob ! hello, runoob !
hello, runoob ! hello, ${your_name} !
```

##### 获取字符串长度

``` BASH
string="abcd"
echo ${#string} #输出 4
```

##### 提取子字符串

``` BASH
string="runoob is a great site"
echo ${string:1:4} # 输出 unoo
```

##### 查找子字符串

``` BASH
string="runoob is a great site"
echo `expr index "$string" io`  # 输出 4
```

#### shell 的变量

`readonly val_name` 只读变量；
`unset val_name` 删除变量（不能删除只读变量）；
`echo val_name` 打印变量；
`$val_name` 或 `${val_name}` 使用变量；

变量也可以指向语句：

``` Bash
file=`ls /etc`
```

#### bash 脚本中的 set 命令

`set` 命令是对 shell 的一些设置，
例如 `set -x` 为打开调试回响模式，可以使脚本中的命令在控制台中打印出来。

``` BASH
set -x
echo $(uanme -a)
set +x
echo $(uname -a)
```

以上命令会返回两次 Linux 的版本信息，区别是，上一条命令会被显示出来，而下一条不会。
