---
title: MySQL 踩坑合集
tags:
  - 数据库（踩坑）
categories:
  - article
  - 数据库
date: 2020-01-01 00:00:00
---

## MySQL 踩坑合集

### Lock wait timeout exceeded; try restarting transaction (1205) (SQLExecDirectW)

- 查看事务隔离级别

```sql
select @@transaction_isolation;

REPEATABLE-READ // MySQL默认的事务隔离级别就是REPEATABLE-READ
```

- 查看当前数据库的线程情况，寻找运行缓慢的线程，记录 pid；

```sql
SHOW FULL PROCESSLIST;
```

- 查看 innoDB 事务表，缓慢运行的线程的 id 是否在表上；

```sql
SELECT * FROM information_schema.INNODB_TRX;
```

- 手动 kill；

```sql
KILL 124;
```
