---
title: 数据库应用
date: 2020-01-01
tags: [数据库（应用知识）]
categories: 
    - [数据库]
---
## SQL 高级

### 关键字

#### 逻辑关键字

- NOT
表否定
- IS
表肯定

#### 搜索关键字

##### LIKE

用于模式搜索。

- 通配符搜索  
`LIKE 'G%'`表G开头的模式  
`LIKE '%oo%`表中间为oo的模式  

###### 通配符

- %  
代替0个或多个字符
- _  
代替一个字符
- [charlist]  
字符列表中的任何一个字符
- [^charlist]/[!charlist]  
不在字符列表中的任何一个字符

##### IN

用于规定多个值，等于其中一个即可  
`IN (value1, value2, ...)`

##### BETWEEN

用于规定范围，在范围内即可  
`BETWEEN valueA AND valueB`

### 别名

为了简化列名和函数书写，我们通常会为列或表声明别名。  
列别名：

```SQL
SELECT [ColumnName] AS [AliasName] FROM [TableName];
```

表别名：

```SQL
SELECT [ColumnName] FROM [TableName] AS [AliasName];
```
