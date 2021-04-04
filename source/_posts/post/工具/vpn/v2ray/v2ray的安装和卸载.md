---
title: v2ray的安装和卸载
date: 2021-03-25
tags: []
categories: 
    - 工具
    - vpn
    - v2ray
---

## v2ray的安装和卸载

安裝和更新 V2Ray

``` BASH
# 安裝執行檔和 .dat 資料檔
bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh)
```

安裝最新發行的 geoip.dat 和 geosite.dat

``` BASH
# 只更新 .dat 資料檔
bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-dat-release.sh)
```

移除 V2Ray

``` BASH
bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh) --remove
```
