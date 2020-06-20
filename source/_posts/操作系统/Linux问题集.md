---
title: Linux踩坑合集
date: 2019-10-01
tags: [Linux, 操作系统]
categories: 

    - [操作系统]
    - [计算机基础]

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

``` 
ALTER USER 'root'@'localhost' IDENTIFIED BY 'password' PASSWORD EXPIRE NEVER; #修改加密规则`
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

解决方案：  
清除lock file和cache的lock file

``` shell
sudo rm /var/lib/apt/lists/lock
sudo rm /var/cache/apt/archives/lock
sudo rm /var/lib/dpkg/lock
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

上面的 `xenial` 是18.04的版本名，18.10为 `bionic` 

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
