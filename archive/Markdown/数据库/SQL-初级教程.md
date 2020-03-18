# SQL 初级使用

## 增删改查

```SQL
USE [DataBaseName]; //切换到某个数据库
SET [ColumnName] utf8; //设置字符集

SELECT * FROM [TableName];//简单查询
SELECT [ColumnName,...] FROM [TableName] WHERE [ColumnName [> = < <> >= <= ?] [BETWEEN ? AND ?] [LIKE 'regex'] [IN (?, ?, ?, ...)] [IS NULL]] AND ... OR ... ; //条件查询
SELECT DISTINCT ...; //合并重复值
SELECT ... ORDER BY [ColumnNames, ...] [DESC //是否降序]; //按某列排序
SELECT TOP [MaxSize]...; //限制最大返回行数

DELETE FROM [TableName] WHERE [ColumnName] = ?; //删除记录
DELETE * FROM [TableName]; //删除所有记录而保留表结构

UPDATE [TableName] SET [ColumnName1] = [value1], ... WHERE some_column = some_value; //更改某几列的值

INSERT INTO [TableName][ColumnNames, ...] VALUES [value, ...]; //插入

```

## 创建/删除/修改指令

```SQL
CREATE DATABASE [DataBaseName];
CREATE TABLE [TableName];
CREATE INDEX [IndexName] ON [TableName]([ColumnName,...] [DESC //指定降序]); //创建索引列
CREATE UNIQUE INDEX ...; //创建唯一索引

DROP DATABASE [DataBaseName];
DROP TABLE [TableName];
DROP INDEX [IndexName] ON [TableName];
```


