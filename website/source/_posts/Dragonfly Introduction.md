---
title: Dragonfly Introduction
date: 2016-10-28 12:06:41
tags: hexo
---


## Install

```
git clone https://github.com/wflkaaa/dragonfly.git
cd dragonfly/website
npm install
```

## Create New Post

```
hexo new "Your Post Name"
```

hexo will generate a new md file under source/_post folder, you can open that file and start write your greate article
<!-- more -->
## Generate html and Deploy

```
hexo generate // genreate html from md file
hexo server   // host a local server, you can preview your article by visiting localhost:4000/dragonfly
hexo deploy   // deploy your site to https://wflkaaa.github.io/dragonfly/
```

deploy with one command:

```
hexo d --generate
```

## Push your modification to Git

Actually, gitpage is hosting on the gh-page branch of a project, so hexo is pushing generated content to that branch.
After you update the website, remember also commit your change to git master branch.

```
cd dragonfly
git add -A
git commit -m "Your new post name"
git push
```
