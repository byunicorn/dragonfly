---
title: tomcat单应用启动
date: 2017-05-19 12:52:34
tags:
---

#### 简述:
tomcat自带了一个管理tomcat容器内web应用的网站，为webapps下的manager。
操作流程为:
1. 修改 `module/website/origin/conf/tomcat-users.xml`, 在`<tomcat-users></tomcat-users>`中加入以下内容: 
    ```xml
    <role rolename="manager-gui" />
    <role rolename="manager-script" />
    <user username="admin" password="admin" roles="manager-gui,manager-script" />
    ```
    其中admin为用户名和密码。

2. 重启tomcat
3. 网页访问 ip:8080/manager/html可以进入管理网页，可以通过点击按钮来起停单个应用。这对应于 manager-gui角色。
4. 命令行操作，以启动为例：
curl --user admin:admin http://ip:8080/manager/text/start?path=/face，其中url中的params对应于需要起停的上下文。这对应于manager-scripts角色。

192.168.2.153上，admin admin，可以使用。

#### 相关链接:
[http://tomcat.apache.org/tomcat-7.0-doc/manager-howto.html
](http://tomcat.apache.org/tomcat-7.0-doc/manager-howto.html)

[http://stackoverflow.com/questions/12622534/tomcat-restart-webapp-from-command-line](http://stackoverflow.com/questions/12622534/tomcat-restart-webapp-from-command-line)