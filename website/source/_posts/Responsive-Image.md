---
title: Responsive Image
date: 2017-03-16 13:48:40
tags: responsive image background
---

## 需求描述
由于高分辨率屏幕的普及，我们需要根据屏幕分辨率加载图片，已达到最好的视觉效果

## 几个概念

#### CSS Pixels

CSS Pixels是浏览器使用的抽象单位，用来精确的、统一的绘制网页内容。
通常，CSS pixels被称为与设备无关的像素（DIPs,device-independent pixels）。
在标准密度显示器（standard-density displays）上，1 CSS pixel对应一个物理像素。

#### Device Pixels

一个设备像素（或者称为物理像素）是显示器上最小的物理显示单元。
在操作系统的调度下，每一个设备像素都有自己的颜色值和亮度值。

#### 失真

当一个位图以原尺寸展示在标准密度显示器上时，一位图像素对应一个物理像素，就是无失真显示。
而在2倍屏上，为了保证同样的物理尺寸，需要用四倍的像素来展示，但由于单个位图像素已经无法再进一步分割，只能就近取色，导致图片变化，如下图所示。
![](https://www.smashingmagazine.com/wp-content/uploads/2012/07/css-device-bitmap-pixels.png)

## 如何响应式的引入图片

### img标签

```
<img src="example.png" width="300px" height="200px">

$(function() {
    // 替换静态资源
    var images = $('img'),
    devicePixelRatio = window.devicePixelRatio;
    images.each(function() {
        var src = this.src;
        if(devicePixelRatio > 1 && devicePixelRatio <= 2.5) {
            replacedSrc = src.replace('.', '@2x.');
            this.src = replacedSrc;
        } else {
            replacedSrc = src.replace('.', '@3x.');
            this.src = replacedSrc;
        }
    });

    // 动态获取
    $.get('someurl', {devicePixelRatio: devicePixelRatio}).then(function(data) {
        data.each(function() {
            // 根据返回回来的src新建image对象，并添加到DOM
            // 当然也可以在返回数据后，根据devicePixelRatio的大小重新组装src
        })
    });
});
```
问题：
* 静态替换时，对于高分辨率会造成流量浪费，并且会让用户看到图片替换
* [devicePixelRatio的兼容性](http://caniuse.com/#search=device-pixel-ratio)

### 背景图片
很多情况下我们会用background-image的方式来使用图片，对于这种情况我们可以：

```

<!-- html结构 -->
<span class="icon icon-right"></span>

// css样式
.icon {
    display: inline-block;
    width: 40px;
    height: 40px;
    background-size: 100% 100%;
}
.icon-right {
    background-image: url(example.png);
    @media only screen and (-Webkit-min-device-pixel-ratio: 1.5),
    only screen and (-moz-min-device-pixel-ratio: 1.5),
    only screen and (-o-min-device-pixel-ratio: 3/2),
    only screen and (min-device-pixel-ratio: 1.5) {
        background-image: url(example@2x.png);
    }
    @media only screen and (-Webkit-min-device-pixel-ratio: 2.5),
    only screen and (-moz-min-device-pixel-ratio: 2.5),
    only screen and (-o-min-device-pixel-ratio: 5/2),
    only screen and (min-device-pixel-ratio: 2.5) {
        background-image: url(example@3x.png);
    }
}
```
[device-pixel-ratio兼容性](http://caniuse.com/#search=device-pixel-ratio)

### 神奇的srcset

```
<！--你可以这么用 -->
<img src="examples.png"
     srcset="
     examples@2x.png 2x,
     examples@3x.png 3x" alt="…">

<!-- 也可以这么用 -->
<img sizes="(max-width: 374px) 64px 128px"
     srcset="
     examples.png 64w,
     examples@2x.png 128w,
     examples@3x.png 256w
     " alt="...">

<!-- 如果你想在css中使用类似的，可以这样 -->

div {
    background-image: image-set( "examples.png" 1x, "examples@2x.png" 2x, "examples@3x.png" 3x);
}
```
使用前你可能需要知道他们的兼容性：
[srcset兼容性](http://caniuse.com/#search=srcset)
[image-set兼容性](http://caniuse.com/#search=image-set)

最后你可能想要在比较老的浏览器使用这么牛逼哄哄的东西，我不会告诉你有个插件叫[Picturefill](http://scottjehl.github.io/picturefill/)(偷偷告诉你，这个我没有用过。。。)

贴一下参考的文章，避免不必要的麻烦：
[<img>](https://developer.mozilla.org/zh-CN/docs/Web/HTML/Element/img#Specifications)
[Responsive Images in CSS](https://css-tricks.com/responsive-images-css/)
[RESPONSIVE IMAGE WORKFLOW](http://jonyablonski.com/2015/responsive-image-workflow/)
[Srcset 和 sizes](https://www.zfanw.com/blog/srcset-and-sizes.html)
[Towards A Retina Web](https://www.smashingmagazine.com/2012/08/towards-retina-web/)
[响应式图片srcset全新释义sizes属性w描述符](http://www.zhangxinxu.com/wordpress/2014/10/responsive-images-srcset-size-w-descriptor/)



