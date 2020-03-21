# Lock wait timeout exceeded; try restarting transaction (1205) (SQLExecDirectW)

1. 查看事务隔离级别
```sql
select @@transaction_isolation;

REPEATABLE-READ // MySQL默认的事务隔离级别就是REPEATABLE-READ
```
2. 查看当前数据库的线程情况，寻找运行缓慢的线程，记录pid；
```sql
SHOW FULL PROCESSLIST;
```

3. 查看innoDB事务表，缓慢运行的线程的id是否在表上；
```sql
SELECT * FROM information_schema.INNODB_TRX;
```

4. 手动kill；
```sql
KILL 124;
```

