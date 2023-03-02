---
title: Linux 环境配置
tags: []
categories:
  - article
  - 操作系统
  - linux
date: 2021-03-29 00:00:00
---

## Linux 环境配置

Linux 有两种方式来进行环境的配置：

- 交互式 login shell ：这种方式取得 bash 命令需要登录操作，比如系统刚刚开机时候需要输入用户密码才能够取得的相关命令；
- 非交互式 non-login shell ：这种方式取得的 bash 命令则不需要进行登陆操作，比如登录系统之后执行的 `bash` 命令相当于打开了一个子 bash 环境；

![picture 1](../../../../assets/%E6%93%8D%E4%BD%9C%E7%B3%BB%E7%BB%9F/linux/Linux%20%E7%8E%AF%E5%A2%83%E5%8F%98%E9%87%8F/5c04f725230db3370ca9045c2adef6263fc3056f538f89c3019727833f304dee.png)

### 交互式 login shell

交互式 login shell 一般只会读取：

1. `/etc/profile` ：全局配置文件；
2. `[~/.bash_profile | ~/.bash_login | ~/.profile]` ：用户自己的配置文件，这三个只读取一个，按照顺序读取，先命中的则读取；

而通过打开上述的文件我们发现，他们还会判断另外一下配置文件是否存在，存在则执行；比如， `~/.bash_profile` 会去读取 `~/.bashrc` ，而 `~/.bashrc` 会去读取 `/etc/bashrc` 等等。

总结下来如下图所示，实线的方向是系统会自动读取的流程，虚线是文件中调用的配置文件；一般我们都会修改 `~/.bashrc` 进行用户专属的配置，方式管理混乱；

![picture 2](../../../../assets/%E6%93%8D%E4%BD%9C%E7%B3%BB%E7%BB%9F/linux/Linux%20%E7%8E%AF%E5%A2%83%E5%8F%98%E9%87%8F/439e6b62c3c44825587086a54f5c4439ae12663278834307f4664fad3cd13383.png)

### 非交互式 non-login shell

非交互式 non-login shell 只会读取 `~/.bashrc` 文件，所以和上面的其实差不多；

### 通过 su 命令看到以上两者的区别

> `su` - 运行替换用户和组标识的 shell
> 用法： `su [OPTION]... [-] [USER [ARG]...]`
> 参数：
>
>     -, -l, --login
>           使得shell为可登录的shell
>
>     `-c`, --commmand=COMMAND
>            传递单个COMMAND给-c的shell.
>
>     -f, --fast
>            传递-f给shell(针对csh或tcsh)
>
>     -m, --preserve-environment
>            不重置环境变量
>
>     -p     与-m同
>
>     -s, --shell=SHELL
>            如果/etc/shells允许,运行SHELL.
>
>     --help 显示帮助并退出
>
>     --version
>            输出版本信息并退出

通过 `su root` 切换到 root 用户是按照 non-login shell 的方式切换到 root 的 shell 的；
通过 `su -` 或 `su - root` 切换到 root 用户是按照 login shell 的方式切换到 root 用户的 shell 的；
由于这两种方式加载配置文件的方式不一样，所以他们最后的 `env` 环境变量打印出来并不一样。
