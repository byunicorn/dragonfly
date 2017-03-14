---
title: git pull vs git pull origin master
date: 2017-03-14 20:33:19
tags:
---

今天本来要拉某个分支

	git pull origin branch_name
但手一抖执行了

	git pull origin
发现git log诡异的变化，google后发现

	git pull origin = git pull = git fetch origin + git merge origin/master
(merge的对象是.gitconfig中默认的remote upstream)


