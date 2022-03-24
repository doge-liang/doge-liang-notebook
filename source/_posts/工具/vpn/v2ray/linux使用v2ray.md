---
title: linux使用v2ray
date: 2021-03-28
tags: []
categories:
  - 工具
  - vpn
  - v2ray
---

## linux 使用 v2ray

下载好 v2ray 软件之后，设置好 `config.json` ，启动 v2ray 。

然后配置 `http_proxy` 和 `https_proxy` 两个环境变量，可以使用 `export` 进行临时的配置，也可以写进 `~/.bashrc` 里面，每次启动终端自动执行。
