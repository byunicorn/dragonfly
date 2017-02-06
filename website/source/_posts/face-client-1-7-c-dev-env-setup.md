---
title: face_client_1.7.c_dev_env_setup
date: 2017-02-06 14:53:18
tags: [zmzhang,1.7.c,face_client,setup]
---

# 1.7.c dev环境搭建

### 前端
* 切分支: git checkout project/website/face/client/1.7.c
* git pull origin project/website/face/client/1.7.
* webstorm打开项目路径: ficus/website/face/client/react_website
* 安装依赖: npm install
* 修改配置文件: webpack-dev-server.js, proxy 中修改对应后台的api, app.listen(port) 其中port为访问的端口号（注： 与server.listen()的端口号不同）
* 前端server配置
 > run > Edit Configuration

 > 添加node.js

 > Node interpreter: NodePath (推荐适用nvm进行node版本管理)

 > Node parameters: webpack/webpack-dev-server --env.dev

 > run


### java端
* intellij打开ia项目路径: ficus/website/face/client/java_website
* 配置方法：
 > 导入maven项目

 > 修改project structure 配置

 > Project SDK 1.7

 > Modules java_website: Web Module Deployment Descriptor: ficus/website/face/client/java_website/src/main/webapp/web.xml

 > Modules java_website: web Resource Directory: ficus/website/face/client/java_website/src/main/webapp

 > Artifacts 中 java_website:Web exploded 添加右侧所有lib包
 > 设置src/main/java 为source文件夹
