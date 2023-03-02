---
title: vscode+remote-ssh插件进行远程开发
tags: []
categories:
  - article
  - 零碎
date: 2021-03-27 00:00:00
---

## vscode+remote-ssh 插件进行远程开发

> 经尝试，如果使用腾讯云提供的 ssh 密钥登录，可以做到 vscode + remote-ssh 远程登录不需要输入密钥。如果是自己生成的 ssh-key 进行配置好像还是要求我输入 rsa 的密钥。

### 插件准备

客户端需要准备的插件：

- remote-ssh
- Remote - SSH: Editing Configuration Files
- Remote - Containers
- Remote - WSL
- Remote Development

服务端需要准备的插件：

- openssh （一般的云服务器都会带有 ssh 功能的插件的，功能类似的就可以了）

### 生成 ssh 公钥

有两种方式可以生成 ssh 公钥：

1. 自己使用 `ssh-genkey` 命令生成 ssh 公钥对，将公钥文件（默认是 `id_rsa.pub` ）放到服务器上（可以使用 `ssh-copy-file` 命令将文件传输到服务器的 `~/.ssh/` 目录中，替换 `authorized_keys` 中的内容；
2. 使用腾讯云控制台中的 ssh 密钥生成工具，创建密钥并绑定到实例中。创建时还会自动将私钥下载下来，是一个 `*pem` 文件；

### 编写配置文档

在 vscode 中点击 `ctrl` + `shift` + `P` ，输入 `remote-ssh:open` 打开默认的第一个配置文档，输入以下内容：

```BASH
Host <Host Name>
    HostName <IP or Domain>
    User <Login Username>
    IdentityFile <Public Key FilePath Like *.pem or Other>
```

然后通过 `remote-ssh:connect a host` 开启到远程的连接便可。

Terminal 卡在这里就表示连接成功了，只需要开启一个新的 Terminal 便可远程操作了。

```bash
Checking server status on port 37403 with wget
d8596fae67b8: start
SSH_AUTH_SOCK====
DISPLAY====
webUiAccessToken====
listeningOn==37403==
osReleaseId==ubuntu==
arch==x86_64==
tmpDir==/run/user/0==
platform==linux==
unpackResult====
didLocalDownload==0==
downloadTime====
installTime====
extInstallTime====
serverStartTime====
connectionToken==51a92f61-ac3c-42c1-92b0-1032c4078bc8==
d8596fae67b8: end
```

### 连接的时候遇到了 permissions are too open 问题

```BASH
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@         WARNING: UNPROTECTED PRIVATE KEY FILE!          @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
Permissions for 'vscode_rsa' are too open.
It is required that your private key files are NOT accessible by others.
This private key will be ignored.
Load key "vscode_rsa": bad permissions
```

问题成因： 私钥文件的权限太开放了， ssh 工具觉得不安全，如果是 Linux 可以使用 `chmod` 命令解决，而 windows 稍微麻烦些。

windows 解决方案：打开配置中设置的 ssh 公钥文件，右键打开 `属性` ， `安全` ， `高级` ， `禁用继承` ， `将已继承的权限转换为此对象的显式权限` ，然后将除了自己以外的用户都删除；

### 需要使用 root 用户进行登录

- 腾讯云

```bash
# 登录服务器后
su root
vim /etc/ssh/ssh_config
# 通过 /[pattern] 的方式搜索到 PermitRoot 那一行
# 在下面重开一行，输入 PermitRoot yes
# 输入 :wq ，退出 vim 编辑器
cat /home/ubuntu/.ssh/authorized_keys >> /root/.ssh/authorized_keys
```
