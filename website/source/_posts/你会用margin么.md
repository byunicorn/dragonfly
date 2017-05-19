---
title: 你会用margin么
date: 2017-05-19 12:51:53
tags:
---

这其实是以前我去面阿里前端的时候被问到的问题，今天拿来面小朋友了：

问：两个block元素，上面的那个margin: 10px; 下面的那个margin: 20px; 问这两个元素最终的上下间距是多少

答：so easy，block元素之间的margin会重叠，所以最后的间距是20px

问：嗯，那如果上面的元素margin: -10px；下面的元素margin:-20px; 问这两个元素间距又会是多少呢？

答：应该……会有10px的overlap……吧？（

问：哪个元素在上面呢？如果元素是float的呢？bulabula……

然后就没有然后了……

答案就是：
遇到负的margin，如果是margin-top或者margin-left，元素会往上往左移动，如果是margin-right或者margin-bottom，元素不会动，挨着它的元素会往左或者往上移动。
对于非float的元素，两个元素会重叠（背景色右下覆盖左上，前景的文字重叠，和z-index无关），

如果相邻的两个元素都是负margin，则会取较大的那个margin。

对于float的元素，左上的元素会向左向上留出对应negative margin的空间，右下的元素会完全覆盖空间（背景色+文字）。如果相邻的两个元素都是负margin，则覆盖的部分会是两个margin叠加。

推荐自己到codepen上直接试一试。 [http://codepen.io/byunicorn/pen/KggYVR](http://codepen.io/byunicorn/pen/KggYVR)

reference: [https://www.smashingmagazine.com/2009/07/the-definitive-guide-to-using-negative-margins/](https://www.smashingmagazine.com/2009/07/the-definitive-guide-to-using-negative-margins/)

p.s. 其实前端不难，问题是细节太多，需要经验的积累，像这样的css问题，遇到一次以后就会了，所以鼓励大家多多share自己遇过的坑。