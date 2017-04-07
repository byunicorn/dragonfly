---
title: Deploy war
date: 2017-04-07 12:52:55
tags: [rbzhou,cmd,tool]
---
##目的
为方便更新网站到服务器上，现准备了一些部署的脚本。在`angular_website`目录下新加了一下内容，包括:
    配置文件夹`website_deploy_config`
    部署脚本 `fpackage_wz.sh`

## 使用方法
安装依赖。脚本依赖`jq`和`sshpass`。
```
sudo apt-get install jq
sudo apt-get install sshpass
```


在`website_deploy_config`下新建`TEST.json`,内容如下:
```
{
  "ip": "10.10.31.151",
  "user_name": "ubuntu",
  "password": "12345678",
  "deploy_dir":   "/home/ubuntu/deploy/",
  "runtime_dir": "/home/ubuntu/runtime/" 
}

```
其中，`ip`，`ser_name`,`password`不多说了，`deploy_dir`为安装环境的路径前缀，`runtime_dir`为运行环境前缀。

在`angular_website`路径下执行
```
bash fpackage_wz.sh ${VERSION_NAME} ${CONFIG_NAME}
```

对于文中的例子，
```
bash fpackage_wz.sh 1.8.3 TEST
```
这样，就会打出一个新的包，并更新到服务器上。



