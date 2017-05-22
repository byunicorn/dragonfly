---
title: mysql 允许用户远程连接
date: 2017-05-19 12:53:26
tags:
---
开发过程中会遇到数据库不在本机的情况

之前一直尝试mysql中使用命令：
```sql
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY '%password%' WITH GRANT OPTION;
```
root是数据库用户名

localhost可以是 % 来代替

把%password%替换成root用户的密码

但是这种方法不work

尝试之后还需要修改`/etc/mysql/my.cnf`， 把`127.0.0.1` 修改为`0.0.0.0` 允许其他任何主机访问
```
#bind-address           = 127.0.0.1
bind-address            = 0.0.0.0
```
然后重启mysql服务