---
title: 你不知道的z-index
date: 2016-11-07 19:34:26
tags: [lbao, CSS]
---

上周六帮瑞波做一个小feature，简单来说就是一堆相同大小形状的图片叠在同一个地方，页面上触发某个事件之后，这些图片中的其中一张会慢慢放大，并遮盖其他的图片。

本来挺简单的一件事，图片是`abusolute`的，我瞬间就想到用z-index + transform，于是分分钟给他写了下面这两段：

```html
<img ng-src="/bula.png" ng-class="{true: 'zoom-in'}[isSelected(hit)]">
```
<!-- more -->

```less
img {
    z-index: 9;
	position: abusolute;
    transition: all .2s ease-in-out;
    &.zoom-in {
        transform: scale(1.4);
        transform-origin: bottom center;
        z-index: 10;
    }
}
```

因为当时我的本地环境拿不到数据，我在developer tool里面简单地试了下放大后的效果就跑路了……然后瑞波就掉进我挖的坑里了。
这个坑长下面这样：
事件触发后，图像会放大，但是慢慢放大的过程中，前方一直有其他的小图片遮挡，直到放到最大，放大的图片才会遮挡住其他的小图片。

其实原因很简单，因为我的`transition`写的应用属性是`all`，z-index也是可以transfrom的，具体可以参考下面的codepen，点击红色的区域，红色的box会慢慢变大，z-index也会慢慢增加，一开始都会被前方的box遮挡，直到它的z-index增长到大于前方box z-index的整数，才会完全显示出来。
所以最简单的改法就是把`trasition: all`改成`transition: transform`，就不会有问题了……

<p data-height="265" data-theme-id="0" data-slug-hash="YpPoem" data-default-tab="css,result" data-user="byunicorn" data-embed-version="2" data-pen-title="Stacking Order (solution)" class="codepen">See the Pen <a href="http://codepen.io/byunicorn/pen/YpPoem/">Stacking Order (solution)</a> by unicorn by (<a href="http://codepen.io/byunicorn">@byunicorn</a>) on <a href="http://codepen.io">CodePen</a>.</p>
<script async src="https://production-assets.codepen.io/assets/embed/ei.js"></script>

## 扩展阅读：

今天查了下资料，`z-index`除了有和`position`非`static`的属性一起使用的限制之外，还有一些其他不太会被人注意到的限制。

在开始下面的内容之前，先要做一个关于层叠上下文（Stacking Contexts）的简单科普：

```
层叠上下文是HTML元素的三维概念，这些HTML元素在一条假想的相对于面向（电脑屏幕的）视窗或者网页的用户的z轴上延伸，HTML元素依据其自身属性按照优先级顺序占用层叠上下文的空间。

通常你可以通过下面几种方法让一个元素形成层叠上下文：
1. 非static的position属性 + 非auto的z-index值
2. position: fixed
3. 小于1的opacity
4. 非none的transform属性
5. 还有一些非常见的神奇属性，例如：filter, isolation等
```

这些元素层叠的规则是这样的：

```
当前层的根元素（形成层叠的元素）
position非static + 负z-index的元素（以及它的子元素，如果z-index，则后出现的元素覆盖先出现的元素，下同）
position为static的元素
position非static + z-index为auto的元素
position非static + 正z-index的元素
```

所以，如果你的z-index不work，可以检查一下层叠上下文。假设你要把一个元素置前，而它有一个层叠顺序很低的parent，那么很可能无论你怎么调整，都可能会被与parent平级的其他层叠顺序更高的元素遮挡。

References:
- [What No One Told You About Z-Index — Philip Walton](https://philipwalton.com/articles/what-no-one-told-you-about-z-index/)
- [The stacking context - CSS | MDN](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Positioning/Understanding_z_index/The_stacking_context)
