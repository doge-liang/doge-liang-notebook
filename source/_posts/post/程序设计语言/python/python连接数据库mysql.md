---
title: python 连接mysql
date: 2019-10-10
tags: []
categories: 
    - 程序设计语言
    - python
---
## python 连接mysql

1. PyMySQL
2. pyodbc

### pyodbc

连接mysql

1. 下载odbc-MySQL驱动安装包
2. 安装驱动并在电脑的管理工具处配置数据源
3. 经测试数据源可用后即可点击确定

各个系统以及数据库的连接模板代码：

```python
import pyodbc

#连接示例: Windows系统, 非DSN方式, 使用微软 SQL Server 数据库驱动

cnxn = pyodbc.connect('DRIVER={SQL Server};SERVER=localhost;PORT=1433;DATABASE=testdb;UID=me;PWD=pass')

cnxn = pyodbc.connect(

#连接示例: Linux系统, 非DSN方式, 使用FreeTDS驱动

cnxn = pyodbc.connect('DRIVER={FreeTDS};SERVER=localhost;PORT=1433;DATABASE=testdb;UID=me;PWD=pass;TDS_Version=7.0')

#连接示例:使用DSN方式

cnxn = pyodbc.connect('DSN=test;PWD=password')

# 打开游标

cursor = cnxn.cursor()
```
