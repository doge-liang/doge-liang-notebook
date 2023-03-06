---
title: ubuntu-apt
tags:
  - ubuntu
  - apt
categories:
  - article
  - 操作系统
  - linux
date: 2020-06-21 00:00:00
---

## ubuntu-apt 命令使用

`apt-cache search package` 搜索包

`apt-cache show package` 获取包的相关信息，如说明、大小、版本等

`apt install package` 安装包

`apt install package - - reinstall` 重新安装包

`apt -f install` 修复安装

- `-f = --fix-missing`

`apt remove package` 删除包（会留下个人配置）

`apt purge package` 删除包以及配置

`apt remove package --purge` 删除包，包括删除配置文件等

`apt update` 更新源

`apt upgrade` 更新已安装的包

`apt dist-upgrade` 升级系统

`apt dselect-upgrade` 使用 dselect 升级

`apt-cache depends package` 了解使用依赖

`apt-cache rdepends package` 是查看该包被哪些包依赖

`apt build-dep package` 安装相关的编译环境

`apt source package` 下载该包的源代码

`apt clean && sudo apt autoclean` 清理无用的包

`apt-get check` 检查是否有损坏的依赖
