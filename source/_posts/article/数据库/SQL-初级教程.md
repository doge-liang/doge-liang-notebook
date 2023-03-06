---
title: 数据库应用
tags:
  - 数据库（应用知识）
categories:
  - article
  - 数据库
date: 2020-01-01 00:00:00
---

## SQL 初级使用

### 增删改查

```SQL
//切换到某个数据库
USE [DataBaseName];
//设置字符集
SET [ColumnName] utf8;

//简单查询
SELECT * FROM [TableName];
//条件查询
SELECT [ColumnName,...] FROM [TableName] WHERE [ColumnName [> = < <> >= <= ?] [BETWEEN ? AND ?] [LIKE 'regex'] [IN (?, ?, ?, ...)] [IS NULL]] AND ... OR ... ;
//合并重复值
SELECT DISTINCT ...;
//按某列排序
SELECT ... ORDER BY [ColumnNames, ...] [DESC //是否降序];
//限制最大返回行数
SELECT TOP [MaxSize]...;

//删除记录
DELETE FROM [TableName] WHERE [ColumnName] = ?;
//删除所有记录而保留表结构
DELETE * FROM [TableName];

//更改某几列的值
UPDATE [TableName] SET [ColumnName1] = [value1], ... WHERE some_column = some_value;

//插入
INSERT INTO [TableName][ColumnNames, ...] VALUES [value, ...];
```

### 创建/删除/修改指令

```SQL
CREATE DATABASE [DataBaseName];
CREATE TABLE [TableName];
//创建索引列
CREATE INDEX [IndexName] ON [TableName]([ColumnName,...] [DESC //指定降序]);
//创建唯一索引
CREATE UNIQUE INDEX ...;

DROP DATABASE [DataBaseName];
DROP TABLE [TableName];
DROP INDEX [IndexName] ON [TableName];
```
