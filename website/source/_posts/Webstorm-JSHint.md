---
title: Webstorm+JSHint
date: 2016-12-07 13:04:55
tags: [rbzhou,tools]
---

在Webstorm里面启用jshint功能，就能对js语法进行提示。
设置方法：
 `File` -> `Settings` -> `Languages & Frameworks` -> `Code Quality Tools` -> `JSHint

勾选`enable`。

JSHint提示很多，有些提示无关紧要，当每个文件都提示，让人很不爽，所以记录一些JSHint的配置。

1. 添加`angular`,`_`,`console`,`confirm`关键词
    ![](https://github.com/wflkaaa/dragonfly/blob/master/code/images/jshint-global-keyword.png?raw=true)
	图中`Relaxing options`上方，找到`Predefined(,separated)`，点击该行后方的`Set`，写入`angular`(有多个关键词时用`,`分隔)

2. global strict mode
	勾选 `Supress warnings about the use of global strict mode`

3. W030
	`Relaxing options`勾选 `Supress aarnings about the use of expressions as statements`
