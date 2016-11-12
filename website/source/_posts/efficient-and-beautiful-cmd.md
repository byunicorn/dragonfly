---
title: efficient and beautiful cmd
date: 2016-10-29 15:35:32
tags: [cmd,tools,rbzhou]
---

今天简单介绍一些实用且酷炫的cmd工具。
* vim
* tmux
* zsh
* shortcuts

## vim
vim就不多说了，大家或多或少都会一点。

## tmux
tmux是命令行里的窗口管理器, 可以在一个terminal里开多个panel，这样就不用一个一个窗口打开终端了。而且，如果我开着一个tmux，你们可以ssh到我机器上，tmux attach，然后我们就可以同时操作一个窗口了。有种直播的感觉。

<!-- more -->

tmux本身是一个窗口管理，tmux的操作需要先按`ctrl-B`，
tmux基本用法大致如下:

1. 安装`tmux`，`sudo apt-get install tmux`
2. 打开一个`tmux`。`tmux new -s session`
3. 在`tmux`里开一个新的终端，`Ctrl-B C`
4. 不同tab间切换， `Ctrl-B W`
5. 同一个tab里开一个竖屏的终端，`Ctrl-B %`
6. 同一个tab里开一个横屏的终端，`Ctrl-B "`
7. 同一个tab里切换，`Ctrl-B q Number`
8. `Ctrl-B [`，屏幕静止，`q`退出静止

基本这些操作就足够啦。

另外，建议将`Ctrl-B`改成`Ctrl-A`，为什么呢？因为按键靠近啊。建议将tmux设置成vi模式，为什么呢？因为vim方便啊。

## zsh

`zsh`可以理解为`bash`的进化版，可以通过插件，进行很多简便的操作。我们的机器上好像都有`zsh`，直接输入`zsh`应该就能开启。`zsh`兼容`bash`，所以不会有任何不适。`zsh`插件建议装`git`，`zsh-autosuggestions`。为什么呢？提示你所在分支，你说好不好？记录你最常用的指令啊，地址啊，你说好不好？

## shortcuts

一些我觉得比较方便的快捷键。

### terminal的快捷键

| 按键   |      功能     |
|----------|:-------------:|
| Ctrl-Shift-C |  复制terminal中选中的内容   |
| Ctrl-Shift-V |  粘贴到terminal中			|
| Ctrl-L	   |  清空					|
| Ctrl-D	   |  退出					|

### ubuntu有一些非常实用的快捷键，可以完成窗口间的切换。

| 按键   |      功能     |
|----------|:-------------:|
| 长按win键 |  显示左侧tab的数字   |
| win + number| 切换到数字对应的左侧tab |
| alt + \`  | 显示和切换当前程序的窗口(从一个terminal切到到另一个terminal) |
| ctrl-W	| 关闭当前窗口	|

### 配合chrome下的一些按键

| 按键   |      功能     |
|----------		|:-------------:|
| ctrl-W 		| 关闭当前tab     |
| ctrl+number	| 切换到数字对应tab 	|
| ctrl-T 		| 新建一个tab	|

```
PS: 最后说一句，我用的也不是很geek，837的那帮人才是城会玩。
PPS: 我的一些配置文件，在这里: /ficus198/rbzhou/env_config_files/env_configs.tar，都是放在～目录下生效。不生效就source执行一下。还是挺好玩的。
```
