---
title: python-pip配置
tags:
  - pip
categories:
  - article
  - 计算机
  - 程序设计语言
  - python
date: 2020-07-03 00:00:00
---

## python pip 配置

- [python pip 配置](#python-pip-配置)
  - [配置国内代理](#配置国内代理)
  - [配置国内镜像](#配置国内镜像)

### 配置国内代理

- 单次设置

```shell
pip install -r [package] --proxy=[IP]:[PORT]
```

- 永久设置

```shell
# Unix 系
vim /etc/profile：
    export http_proxy='http://[IP]:[PORT]'
    export https_proxy='http://[IP]:[PORT]'
source /etc/profile

# Windows
cd %HOMEPATH%
md pip & cd pip
echo [global]>>pip.ini
echo. proxy='http://[IP]:[PORT]'>>pip.ini
echo. proxy='http://[IP]:[PORT]'>>pip.ini
```

### 配置国内镜像

- 单次设置

```shell
pip install [package]  -i http://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com
```

- 永久设置

```shell
# Unix 系
vim ~/.pip/pip.conf:
    [global]
    index-url = https://pypi.tuna.tsinghua.edu.cn/simple
source /etc/profile

# Windows
cd %HOMEPATH%
md pip & cd pip
echo. timeout = 6000>>pip.ini
echo. index-url = https://pypi.tuna.tsinghua.edu.cn/simple>>pip.ini
echo. trusted-host = https://pypi.tuna.tsinghua.edu.cn>>pip.ini
```
