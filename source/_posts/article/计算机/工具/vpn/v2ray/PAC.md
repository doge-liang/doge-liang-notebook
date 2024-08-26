---
title: PAC
tags:
  - v2ray
categories:
  - article
  - 计算机
  - 工具
  - vpn
  - v2ray
date: 2021-03-09 00:00:00
---

<style>
.center {
width: auto;
display: table;
margin - left: auto;
margin - right: auto;
}
// 图片居中
img {
position: relative;
left: 50%;
transform: translateX(-50%);
}
</style>

## PAC

### 什么是 PAC

PAC （Proxy auto-config，代理自动配置）是一种网页浏览器技术，用于判断浏览器发出的请求是否应该发往代理服务器。

挂了 v2ray 代理之后，发现上 github 还是加载不出图片。由于 github 在国内的部分 cdn 被 GFW 进行了 DNS 污染。猜测是这个原因导致图片资源无法加载。
方案有几种：

1. 修改 host 文件。这种方法不用挂代理，但是 github 的资源服务器可能更换 IP 。时间一长就很可能失效；
2. 修改 PAC 规则。

由于我已经挂了代理了，所以选择修改 PAC 规则，估计是 v2ray 的弱弱 PAC 规则漏掉了 github 的资源服务器域名。所以在 `user-rule` 文件中添加上就好了。

PAC 的一些编写规则：

1. 通配符支持。比如 `*.example.com/*` 实际书写时可省略 `*` ， 如`.example.com/` ， 和 `*.example.com/*` 效果一样；
2. 正则表达式支持。以 `\` 开始和结束， 如 `\[\w]+:\/\/example.com\` ；
3. 例外规则 `@@` ，如 `@@*.example.com/*` 满足 `@@` 后规则的地址不使用代理；
4. 匹配地址开始和结尾 `|` ，如 `|http://example.com` 、 `example.com|` 分别表示以 `http://example.com` 开始和以 `example.com` 结束的地址；
5. `||` 标记，如 `||example.com` 则 `http://example.com` 、`https://example.com` 、 `ftp://example.com` 等地址均满足条件；
6. 注释 `!` 。 如 `!`我是注释；
7. 分隔符 `^` ，表示除了字母、数字或者 `_` `-` `.` `%` 之外的任何字符；
