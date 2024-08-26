---
title: Linux命令杂记
tags: []
categories:
  - article
  - 计算机
  - 操作系统
  - linux
date: 2019-10-01 00:00:00
---

## 检查 Linux 版本

```bash
lsb_release -a
uname -a #查看硬件架构
```

## 转换到 root 用户

```code
su root
```

## 修改 root 用户密码

```code
sudo passwd root
```

## 修改 ssh 密码

```shell
passwd [用户]

#输入新密码
#重新输入密码
```

## 安装软件

```code
sudo yum install [Option] // RedHat-based
sudo apt-get install [Option] // Debian-based
```

## 查看软件安装

**因为 linux 安装软件的方式比较多，所以没有一个通用的办法能查到某些软件是否安装。总结起来就是这几类：**

1. rpm 包安装的：用 rpm -qa，如果查找某一软件包是否安装，用 rpm -qa|grep "软件或包的名字";
2. deb 包安装的：用 dpkg -l，如果指定软件包，用 dpkg -l|grep "软件或者包的名字";

## 目录查阅命令

```code
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

```shell
apt-get install xxx xxx
apt install xxx xxx # 看apt的版本，新版的apt == apt-get
apt remove xxx xxx # 保留配置的卸载
apt purge xxx xxx # 不保留配置的卸载
apt update xxx xxx
apt upgrade xxx xxx
```

- RedHat 系列：
  yum:

```BASH
yum install [RPM package]
yum remove [RPM package]
yum update [RPM package]
yum list
yum list installed
```

## 后台启动命令

```shell
setsid [Option] [program]
```

## 文件和目录的维护

### 权限操作

`chmod [mode] [path]` 修改目录的读/写/执行权限

- mode：代表权限模式
- path：表示作用目录

mode 有几种表示方式，一种是数字的表达方式

mode 可以写成三个八进制数字的组合，第一个数字表示文件所有者的权限，第二个表示所属组的权限，第三个表示其他用户的权限。

例如：

```BASH
$ ll

# total 16
# drwxr-xr-x 4 root   root   4096 Apr  6 12:33 ./
# drwxrwxr-x 3 ubuntu ubuntu 4096 Apr  6 12:55 ../
# drwxr-xr-x 3 root   root   4096 Apr  6 12:33 msp/
# drwxr-xr-x 2 root   root   4096 Apr  6 12:33 tls/

# 文件类型 权限字符串 目录/链接数 所有者 所有者的用户组 修改时间 文件名
```

`drwxr-xr-x` 意思是：

1. 文件的所有者拥有读、写、执行权限；
2. 文件所属用户组有读、执行权限；
3. 其他用户拥有读、执行权限；

#### 文件类型

`-` ：表示普通文件；
`d` ：表示目录；
`l` ：表示链接文件；
`p` ：表示管理文件；
`b` ：表示块设备文件；
`c` ：表示字符设备文件；
`s` ：表示套接字文件；

#### 权限字符串

- 执行： `001` 、 `x` (execute)
- 写： `010` 、 `w` (write)
- 读： `100` 、 `r` (read)

#### 目录/链接个数

- 对于目录文件，就会显示该目录下有几个目录文件，比如上面的代码中 `./` 目录有 4 个目录文件，看输出中的文件的文件类型是有四个目录文件（ `./` 本身和 `../` 都算进去了）；
- 对于其他文件，就会显示链接到这个文件的链接的个数，一个文件至少会有自己链接到自己，所以至少是 1；

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

```code
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
`+n` 删除 pushd 添加的目录，以当前目录为准，从左向右数，删除第 n 个；
`-n` 删除 pushd 添加的目录，以当前目录为准，从右向左数，删除第 n 个；

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

```BASH
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

```BASH
hello, runoob ! hello, runoob !
hello, runoob ! hello, ${your_name} !
```

##### 获取字符串长度

```BASH
string="abcd"
echo ${#string} #输出 4
```

##### 提取子字符串

```BASH
string="runoob is a great site"
echo ${string:1:4} # 输出 unoo
```

##### 查找子字符串

```BASH
string="runoob is a great site"
echo `expr index "$string" io`  # 输出 4
```

#### shell 的变量

`readonly val_name` 只读变量；
`unset val_name` 删除变量（不能删除只读变量）；
`echo val_name` 打印变量；
`$val_name` 或 `${val_name}` 使用变量；

变量也可以指向语句：

```Bash
file=`ls /etc`
```

#### 数组

```BASH
array_name=(value1 value2 ... valuen)

# 读取
array_name[0]

# 获取数组长度
${#array_name[@]}

# for 循环遍历
for i in ${array_name[@]}; do
    echo $i
done

# while 循环遍历
while [ $j -lt ${#array_name[@]} ]
do
    echo $j
    let "$j++"
    # 也可以不加引号，也可以不加 $ 符号
    # 也可以用 ((j++)) 替代
done
```

#### bash 脚本中的 set 命令

`set` 命令是对 shell 的一些设置，
例如 `set -x` 为打开调试回响模式，可以使脚本中的命令在控制台中打印出来。

```BASH
set -x
echo $(uanme -a)
set +x
echo $(uname -a)
```

以上命令会返回两次 Linux 的版本信息，区别是，上一条命令会被显示出来，而下一条不会。

### 流程控制

#### 条件判断

```BASH
if condition1
then
    command1
elif condition2
then
    command2
else
    commandN
fi
```

```BASH
if [[ ! -f tmp/mycc.tar.gz ]]; then
    pushd ~/workspace/chaincode/chaincode_example01/go
        ./build.sh
    popd
fi
```

`-f` 判断文件 `tmp/mycc.tar.gz` 是否存在，若存在则为 `True` 。前面有个非符号，变成 `False` 。

另外，`if [ ... ]` 和 `if [[ ... ]]` 是有区别的，详见 <https://www.cnblogs.com/aaron-agu/p/5700650.html>

##### 多重判断

```BASH
case 值 in
模式1)
    command1
    command2
    ...
    commandN
    ;;
模式2）
    command1
    command2
    ...
    commandN
    ;;
esac
```

#### 循环

```BASH
for var in item1 item2 ... itemN
do
    command1
    command2
    ...
    commandN
done
```

```BASH
while condition
do
    command
done
```
