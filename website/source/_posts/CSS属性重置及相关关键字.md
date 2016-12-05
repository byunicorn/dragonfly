---
title: CSS属性重置及相关关键字
date: 2016-12-03 14:49:02
tags: [kailiu,css,initial]
---

*注：这里说的css属性重置并不是在css的最开始重置成各浏览器一致的样式*

事情是这样的，有时别人或者第三方库定义了某些元素的style，比如bootstrap会定义：`img:{max-width:100%;}`

但是在下图的table中，想要实现图片放大镜效果，如果不重置掉img的max-width属性，放大图片的宽高比会变（拉伸）

![](http://ohpf8h425.bkt.clouddn.com/hexo.jpg) 

对这个case，做法可以是 `img{max-width：auto;}` 或者 `img{max-width：initial;}`

#### 但是区别究竟是什么，重置其他元素的属性时该选哪个？

**简单来说，不考虑IE的情况下，全部用initial**

*详细说明：元素的属性有默认值，但不一定都是auto。为了避免每次查表，可以统一用initial。initial对除IE之外的浏览器支持度很好（早期版本就已支持），但是IE即使高版本也不支持。如果要兼容IE，请手动查表找到默认值。*

需要重置样式的场景，不仅仅是被覆盖，也有可能是来自继承，比如定义了div的color，内部span的color会继承。

<!-- more -->

#### 那么，哪些属性会被默认继承？

- 不可继承的：display、margin、border、padding、background、height、min-height、max-height、width、min-width、max-width、overflow、position、left、right、top、bottom、z-index、float、clear、table-layout、vertical-align、page-break-after、page-bread-before和unicode-bidi。

- 所有元素可继承：visibility和cursor。

- 内联元素可继承：letter-spacing、word-spacing、white-space、line-height、color、font、font-family、font-size、font-style、font-variant、font-weight、text-decoration、text-transform、direction
。
- 终端块状元素可继承：text-indent和text-align。

- 列表元素可继承：list-style、list-style-type、list-style-position、list-style-image。

- 表格元素可继承：border-collapse。

#### 对继承的属性重置，也用initial

这里顺便介绍一下几个相关的选项： `initial,inherit,unset`

*inherit: 继承父元素的属性*

<p data-height="265" data-theme-id="0" data-slug-hash="RoMPrE" data-default-tab="html,result" data-user="wflkaaa" data-embed-version="2" data-pen-title="RoMPrE" class="codepen">See the Pen <a href="http://codepen.io/wflkaaa/pen/RoMPrE/">RoMPrE</a> by wflkaaa (<a href="http://codepen.io/wflkaaa">@wflkaaa</a>) on <a href="http://codepen.io">CodePen</a>.</p>
<script async src="https://production-assets.codepen.io/assets/embed/ei.js"></script>

inherit有如下特性：

- inherit的css优先级接近单class，具体：`id > .parent .child > inherit > .child > label`
- inherit会沿路径向root走，找到第一个非默认的并使用
- 对继承来的属性，initial也会重置到初始值（不受继承行为的影响）

#### 关于unset

新属性，与initial作用相似，各浏览器兼容性非常不好，感兴趣的可以自己查查


