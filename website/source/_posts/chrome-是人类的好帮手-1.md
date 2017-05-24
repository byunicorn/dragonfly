---
title: chrome 是人类的好帮手(1)
date: 2017-05-20 11:20:18
tags: [lbao,Angularjs,Javascript]
---

问题：想在代码里快速地运行一段代码，需要去调用一个angular factory，但是又不想用karma写test case。

一开始刘凯过来问的时候我说可以在console里面搞定：
先拿到对应的helper instance（怎么拿我在之前的debug angularjs坑里有写），然后存成全局变量，之后就可以直接在console里面直接用这个全局变量了。

![](https://github.com/wflkaaa/dragonfly/blob/master/code/images/chrome-helper1.png?raw=true)

后来去问瑞波，瑞波说不想用console，想要运行的是一段代码，就给提了另一个方案，用chrome develop tool的snippets功能

![](https://github.com/wflkaaa/dragonfly/blob/master/code/images/chrome-helper2.png?raw=true)

这个功能允许你在当前运行环境里执行一段代码，相当于一个build-in的grease monkey插件。

![](https://github.com/wflkaaa/dragonfly/blob/master/code/images/chrome-helper3.png?raw=true)

在chrome develop tool的各项功能变得那么齐全之前，snippet曾经是一个非常有用的功能……不过现在你依然可以用它做很多事情：
https://github.com/bgrins/devtools-snippets
https://github.com/paulirish/break-on-access
上面是之前存的一些有用的snippet库，不过基本上都三四年没更新了，仅供参考。

