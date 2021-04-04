---
title: Linux踩坑合集
date: 2019-10-01
tags: [Linux]
categories: 

    - [操作系统]

---

## Linux 忘记 mysql root密码，修改权限以及密码(mysql version < 5.7.9)

解决方案：  

1. 关掉数据库 `service mysqld stop`
2. 执行 `mysqld_safe --skip-grant-tables`
3. 打开数据库并进入mysql数据库中 `mysql -u root mysql`
4. 查看所有用户的信息 `SELECT user, host, password FROM user;`
5. 修改root用户密码 `UPDATE user set password=password('newpassword') WHERE user='root';`
6. 刷新权限表 `FLUSH PRIVILEGES;`
7. `exit`

## Linux 忘记 mysql root密码，修改权限以及密码(mysql version 8.0)

``` SQL
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_root_password BY 'password';
```

## 连接数据库1251错误码

原因：  
由于mysql8之前的版本中加密规则是mysql_native_password, 而在mysql 8.0之后, 加密规则是caching_sha2_password。  
解决方案：  

1. 升级Navicat驱动
2. 把mysql用户登录密码加密规则还原成mysql_native_password.

我们进行方法二：

1. 进入数据库
2. 输入

``` SQL
ALTER USER 'root'@'localhost' IDENTIFIED BY 'password' PASSWORD EXPIRE NEVER; #修改加密规则
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password'; #更新一下用户的密码
FLUSH PRIVILEGES; #刷新权限
```

## 中文输入法

这里使用的是googlepinyin
安装好相关的包之后，再设置-输入法-管理已安装语言中，安装中文，并修改输入法系统为：fcitx 随后重启。重启之后，右上角应该是有个白色的小按钮，点击之后配置输入法，注意有键盘(keyboard)字样的要放最上面，而且这个不代表输入法，是键盘布局的意思，是不会激活输入法的。

* Ubuntu系

``` shell
su root
apt-get install fcitx fcitx-googlepinyin fcitx-table-wbpy fcitx-pinyin fcitx-sunpinyin
```

* Centos系

``` shell
yum groupinstall chinese support //安装中文环境支持
```

## Ubuntu 修改分辨率

### 方案一（临时性）

``` BASH
cvt 1920 1080
sudo xrandr --newmode xxx # 填写上一条命令出现的modeline信息
sudo xrandr --addmode VGA-1 "1920x1080_60" # 添加显示模式
sudo xrandr --output  VGA-1 --mode "1920x1080_60.00" # 输出显示模式
```

### 方案二（永久性）

> 新版本的 Ubuntu 可能没有这个文件，所以这种方式可能失效。

``` BASH
sudo vim /etc/X11/xorg.conf

# 输入以下内容
"""
Section "Monitor"
Identifier "Configured Monitor"
Modeline "1920x1080_60.00"  173.00  1920 2048 2248 2576  1080 1083 1088 1120 -hsync +vsync
Option "PreferredMode" "1920x1080_60.00"
EndSection
Section "Screen"
Identifier "Default Screen"
Monitor "Configured Monitor"
Device "Configured Video Device"
EndSection
Section "Device"
Identifier "Configured Video Device"
EndSection
"""
```

另外的方式：

1. 把临时替换分辨率的命令写进开机自启动脚本里面比如 `~/.bashrc` 或者 `/etc/profile` 中；
2. 把修改分辨率的命令写进 `systemd` 的启动脚本中；

> systemd 学习：<http://www.ruanyifeng.com/blog/2016/03/systemd-tutorial-commands.html>

## Debian7 apt-get 无法升级

Debian7 官方已经不提供源了，我们应该升级系统。

``` shell
vi /etc/apt/sources.list
```

将所有的wheezy改成jessie  
执行升级：  
`apt-get upgrade`
`apt-get update`
`apt-get dist-upgrade`

删除无用组件： `apt-get autoremove`

重启系统： `reboot`

删除无用内核： `apt purge linux-image-3.2.0-4-amd64 -y`

## Ubuntu apt-get dist-upgrade 无法升级

错误信息：

``` shell
E: Could not get lock /var/lib/dpkg/lock - open (11 Resource temporarily unavailable)
E: Unable to lock the administration directory (/var/lib/dpkg/) is another process using it?
```

问题分析：
有别的进程占用了 `apt` 命令，因为 `apt` 命令只能有一个进程使用，所以我们应该查看什么进程正在使用进程，判断是否需要 `kill` 掉；

解决方案：

1. 清除lock file和cache的lock file

    ``` shell
    sudo rm /var/lib/apt/lists/lock
    sudo rm /var/cache/apt/archives/lock
    sudo rm /var/lib/dpkg/lock
    ```

2. 列出使用中的进程并杀死

    ``` shell
    ps -A | grep apt
    sudo kill -9 xxx
    ```

## Ubuntu 换源

备份原始 sources.list

``` bash
sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
```

修改源文件 sources.list

``` bash
sudo chmod 777 /etc/apt/sources.list # 编辑权限使得可编辑
sudo vim /etc/apt/sources.list # 打开编辑器
```

``` bash
# 删除原来内容，更换为如下
# 清华源
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic main restricted universe multiverse

deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic main restricted universe multiverse

deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-updates main restricted universe multiverse

deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-updates main restricted universe multiverse

deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-backports main restricted universe multiverse

deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-backports main restricted universe multiverse

deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-security main restricted universe multiverse

deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-security main restricted universe multiverse

deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-proposed main restricted universe multiverse

deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-proposed main restricted universe multiverse

# 阿里源
deb http://mirrors.aliyun.com/ubuntu/ xenial main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ xenial-security main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ xenial-updates main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ xenial-proposed main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ xenial-backports main restricted universe multiverse

deb-src http://mirrors.aliyun.com/ubuntu/ xenial main restricted universe multiverse

deb-src http://mirrors.aliyun.com/ubuntu/ xenial-security main restricted universe multiverse

deb-src http://mirrors.aliyun.com/ubuntu/ xenial-updates main restricted universe multiverse

deb-src http://mirrors.aliyun.com/ubuntu/ xenial-proposed main restricted universe multiverse

deb-src http://mirrors.aliyun.com/ubuntu/ xenial-backports main restricted universe multiverse

```

上面的 `bionic` 是18.04的版本名，18.10为 `cosmic`

| 版本号                     | 代号              | 发布时间    |
|---------------------------|-------------------|------------|
| 20.04 LTS                 | Focal Fossa       | 2020/4/23  |
| 19.10                     | Eoan Ermine       | 2019/10/17 |
| 19.04                     | Disco Dingo       | 2019/4/19  |
| 18.10                     | Cosmic Cuttlefish | 2018/10/18 |
| 18.04 LTS                 | Bionic Beaver     | 2018/04/26 |
| 17.10                     | Artful Aardvark   | 2017/10/21 |
| 17.04                     | Zesty Zapus       | 2017/04/13 |
| 16.10                     | Yakkety Yak       | 2016/10/20 |
| 16.04 LTS                 | Xenial Xerus      | 2016/04/21 |
| 15.10                     | Wily Werewolf     | 2015/10/23 |
| 15.04                     | Vivid Vervet      | 2015/04/22 |
| 14.10                     | Utopic Unicorn    | 2014/10/23 |
| 14.04 LTS                 | Trusty Tahr       | 2014/04/18 |
| 13.10                     | Saucy Salamander  | 2013/10/17 |
| 13.04                     | Raring Ringtail   | 2013/04/25 |
| 12.10                     | Quantal Quetzal   | 2012/10/18 |
| 12.04 LTS                 | Precise Pangolin  | 2012/04/26 |
| 11.10                     | Oneiric Ocelot    | 2011/10/13 |
| 11.04（Unity成为默认桌面环境） | Natty Narwhal     | 2011/04/28 |
| 10.10                     | Maverick Meerkat  | 2010/10/10 |
| 10.04 LTS                 | Lucid Lynx        | 2010/04/29 |
| 9.10                      | Karmic Koala      | 2009/10/29 |
| 9.04                      | Jaunty Jackalope  | 2009/04/23 |
| 8.10                      | Intrepid Ibex     | 2008/10/30 |
| 8.04 LTS                  | Hardy Heron       | 2008/04/24 |
| 7.10                      | Gutsy Gibbon      | 2007/10/18 |
| 7.04                      | Feisty Fawn       | 2007/04/19 |
| 6.10                      | Edgy Eft          | 2006/10/26 |
| 6.06 LTS                  | Dapper Drake      | 2006/06/01 |
| 5.10                      | Breezy Badger     | 2005/10/13 |
| 5.04                      | Hoary Hedgehog    | 2005/04/08 |
| 4.10（初始发布版本）          | Warty Warthog     | 2004/10/20 |

## Ubuntu 18.10 安装 vim 失败

``` bash
The following packages have unmet dependencies: 
    vim : Depends: vim-common (= 2:8.0.1453-1ubuntu1.1)
```

可能是 Ubuntu 18.10 版本自带的 vim-common 不满足 vim 的版本要求，解决方案是卸载自带版本，然后直接安装 vim 使用 apt 自行管理依赖。

``` BASH
sudo apt purge vim-common
sudo apt intall vim
```

## Ubuntu 依赖版本不一致问题

上面的版本不一致问题解决方案我觉得不太好，因为如果有两个软件使用的是不同版本的同一个依赖，但是这两个软件都要用，这就很麻烦。

网上检索到除了卸载新版，退版本以外的另一种解决方案（我不知道这个软件具体是是如何实现的，难道只是把退版本这件事自动化了？）：

``` BASH
sudo apt install aptitude

sudo aptitude install xxx
```

## curl 从 github 等网站下载文件出错

类似如下：
curl: (7) Failed to connect to raw.githubusercontent.com port 443: Connection refused

如果打开网址也进不了页面的话，考虑网址被墙了，解决方案有几种：

1. 修改 hosts ，最简单，但是不保证有效；
2. 挂代理（没有相关网络知识会比较麻烦）；
3. 找国内来源（比如百度网盘有没有人共享这些文件等等）；

### 修改 hosts

先备份原有的 hosts

``` shell
sudo cp /etc/hosts /etc/hosts.bak
```

查看网址的ip，我这里使用的是 <http://ip.tool.chinaz.com/>

![picture 14](../../../assets/%E6%93%8D%E4%BD%9C%E7%B3%BB%E7%BB%9F/Linux%E9%97%AE%E9%A2%98%E9%9B%86/539f273abe7af7a48caf67c81e8a5e6e44abee32ebf339c8c56c006bd2c1652c.png)  

修改正使用的hosts

``` shell

## 原文件 ##

127.0.0.1   localhost
127.0.1.1   ubuntu

# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
```

``` shell

## 修改为 ##

127.0.0.1   localhost
127.0.1.1   ubuntu

# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters

151.101.108.133 raw.githubusercontent.com
```

保存文件完成。

### Ubuntu 系统时间错误 时区正确

本来设置了清华的 apt 源，再执行 `apt update` 的时候，还是出现了 `Release file for ... is not valid yet` 的报错，发现是系统时间有问题，刚好是获取更新的 apt 源链接有问题。猜测是获取软件更新的时候需要校准系统时间和服务器的时间。

**解决方案：**
通过服务器校准时间
先安装 `ntpdate`

``` BASH
sudo apt install ntpdate
```

再获取服务器时间校准系统时间

``` BASH
sudo ntpdate ntp.ubuntu.com
sudo ntpdate time.nist.gov
```
