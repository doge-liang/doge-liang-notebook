# Linux 忘记 mysql root密码，修改权限以及密码(mysql version < 5.7.9)
解决方案：  
1. 关掉数据库`service mysqld stop`
2. 执行`mysqld_safe --skip-grant-tables`
3. 打开数据库并进入mysql数据库中`mysql -u root mysql`
4. 查看所有用户的信息`SELECT user, host, password FROM user;`
5. 修改root用户密码`UPDATE user set password=password('newpassword') WHERE user='root';`
6. 刷新权限表`FLUSH PRIVILEGES;`
7. `exit`

# Linux 忘记 mysql root密码，修改权限以及密码(mysql version 8.0)

```SQL
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_root_password BY 'password';
```

# 连接数据库1251错误码

原因：  
由于mysql8之前的版本中加密规则是mysql_native_password,而在mysql 8.0之后,加密规则是caching_sha2_password。  
解决方案：  
1. 升级Navicat驱动
2. 把mysql用户登录密码加密规则还原成mysql_native_password. 

我们进行方法二：
1. 进入数据库
2. 输入
```
ALTER USER 'root'@'localhost' IDENTIFIED BY 'password' PASSWORD EXPIRE NEVER; #修改加密规则`
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password'; #更新一下用户的密码
FLUSH PRIVILEGES; #刷新权限
```

# 中文输入法

这里使用的是googlepinyin
Ubuntu系
```shell
su root
apt-get install fcitx fcitx-googlepinyin fcitx-table-wbpy fcitx-pinyin fcitx-sunpinyin
```
Centos系
```shell
yum groupinstall chinese support //安装中文环境支持
```
# Debian7 apt-get 无法升级

Debian7 官方已经不提供源了，我们应该升级系统。
```shell
vi /etc/apt/sources.list
```
将所有的wheezy改成jessie  
执行升级：  
`apt-get upgrade`  
`apt-get update`  
`apt-get dist-upgrade`  

删除无用组件：`apt-get autoremove`  

重启系统：`reboot`  

删除无用内核：`apt purge linux-image-3.2.0-4-amd64 -y`

# Ubuntu apt-get dist-upgrade 无法升级

错误信息：
```shell
E: Could not get lock /var/lib/dpkg/lock - open (11 Resource temporarily unavailable)
E: Unable to lock the administration directory (/var/lib/dpkg/) is another process using it?
```

解决方案：  
清除lock file和cache的lock file
```shell
sudo rm /var/lib/apt/lists/lock
sudo rm /var/cache/apt/archives/lock
sudo rm /var/lib/dpkg/lock
```
