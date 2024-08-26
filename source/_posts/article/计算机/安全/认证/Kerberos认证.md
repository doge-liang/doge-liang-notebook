---
title: Kerberos认证
tags: []
categories:
  - article
  - 计算机
  - 安全
  - 认证
date: 2022-07-17 00:00:00
---

## Kerberos 认证

### 引导

以 Windows 登录过程来引入，当用户按下 `Ctrl` + `Alt` + `Del` 时， Winlogon 服务将会被调用，同时提示用户输入用户名和密码。 Winlogon 读取完用户的身份凭证之后，会把它交给本地安全机构（LSA），LSA 对用户凭证进行加密操作比如 MD4 加密，加密后交给 SSPI （安全支持提供者接口），该接口负责与 Kerberos 和 NTLM 服务沟通。 LSA 根据用户输入的 UPN 等信息会事先把身份认证请求传到 Kerberos SSP 中。

Kerberos SSP 验证用户登入目标是本地计算机还是域，如果是域则继续向下处理，如果是本地计算机则会向 SSPI 返回一条错误消息， SSPI 将这个任务交回给 GINA 处理。

SSPI 现在发送请求到下一个安全提供程序，NTLM 。NTLM SSP 会将请求交给 Netlogon 服务针对 LSAM (Local Security Account Manager，本地安全账户管理器)数据库进行身份认证。使用 NTLM SSP 的身份认证过程与 Windows NT 系统的身份认证方法是相同的。

![picture 2](../../../../assets/%E5%AE%89%E5%85%A8/%E8%AE%A4%E8%AF%81/Kerberos%E8%AE%A4%E8%AF%81/2da7dce4627606e18549b8fd770c54f9c54bed8846493242b8fcd579221447de.png)  

### 基础概述

- 一个思想：Kerberos 认证只做认证，不鉴权，鉴权是服务账户所做的； 
- 关键角色：
  - PAC
  - KDC
  - TGT