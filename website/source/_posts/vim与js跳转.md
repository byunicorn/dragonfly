---
title: vim与js跳转
date: 2016-10-28 21:24:41
tags: [JavaScript,vim,rbzhou]
---

webstorm的跳转已经那个不能忍受了。sublime可以，但我已经用不惯了。我要读源码，要跳转，怎么办？还是用vim吧。

使用vim来读取js代码，有几个可以配合使用的vim插件。
首先附上相关链接：
vim+ctags: https://andrew.stwrt.ca/posts/vim-ctags/
tagbar: https://github.com/majutsushi/tagbar
exuberant ctags: http://ctags.sourceforge.net/

<!-- more -->
vim指令:
  1. 进入函数定义 ctrl-]
  2. 回到原先的位置 ctrl-t
  3. :tag function_name
  4. ctrl-w + 方向键 切换panel
  5. :CtrlPTag ctrlP插件，搜索tag标签

操作方法：
sudo apt-get install exuberant-ctags
安装vim插件 tagbar
ctags-exuberant -R ＊ 建立tag标签
然后在vim里面就可以跳转啦。