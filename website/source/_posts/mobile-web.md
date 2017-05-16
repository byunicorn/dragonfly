---
title: 移动端web踩坑指南
date: 2017-05-13
tags: [ycma, mobile, web]
---
# 移动端web踩坑指南

----------


## meta标签
[Apple-Specific Meta Tag Keys](https://developer.apple.com/library/content/documentation/AppleApplications/Reference/SafariHTMLRef/Articles/MetaTags.html)
[x5内核定制<meta>标签说明](http://open.mb.qq.com/web/doc?id=1201)
### viewport
```
<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0,  maximum-scale=1.0, user-scalable=no">
```
visual viewport: The visual viewport is the part of the page that's currently shown on-screen.(在屏幕上可以看见的那部分视图，露出到海面上的冰山)
layout viewport: The layout viewport can be considerably wider than the visual viewport, and contains elements that appear and do not appear on the screen.(整座冰山)

content中的各参数解读
width设置的是layout viewport，支持数值， 范围从200到10,000， 默认为980像素，也可以设置成device-width，即屏幕宽度（虚拟像素， 不是实际像素）;
initial-scale， 浮点数， 初始的缩放比例， 范围从0 - 10;
minimum-scale， 浮点数， 允许用户缩放到最小的比例;
maximum-scale， 浮点数， 允许用户缩放到最大的比例；
user-scalable， yes|no， 是否允许用户缩放；

### apple-mobile-web-app-capable
```
<meta name="apple-mobile-web-app-capable" content="yes">
```
是否启动webapp功能， 会删除默认的苹果工具栏和菜单栏。

### apple-mobile-web-app-status-bar-style
```
<meta name="apple-mobile-web-app-status-bar-style" content="black">
```
当启动webpp功能时， 显示手机信号、时间、电池的顶部导航栏的颜色。 默认值为default（白色），可以定位black（黑色）和black-translucent(灰色半透明)

### format-detection
```
<meta name="format-detection" content="telphone=no, email=no">
```
格式检测，忽略页面中的数字识别为电话号码， 邮箱

### X-UA-Compatible
```
<meta name="X-UA-Compatible" content="IE=edge">
```
避免IE使用兼容模式

### x5-orientation
```
<meta name="x5-orientation" content="portrait">
```
QQ强制竖屏

### x5-fullscreen
```
<meta name="x5-fullscreen" content="yes">
```
QQ强制竖屏

### x5-page-mode
```
<meta name="x5-page-mode" content="app">
```
QQ应用模式


----------


## 页面滚动卡顿
在IOS5之前， 页面中不支持局部滚动，如果要实现局部滚动效果， 只能引用第三方库（例如iscroll等）, 但是在IOS5之后，出现了支持局部滚动的css属性， -webkit-overflow-scrolling: touch
如果你在开发中发现滑动卡顿，请尝试添加上述属性


----------


## 点击高亮
IOS上默认会有点击高亮的效果， 如果想要禁用它， 可以添加
```
* {
-webkit-tap-highlight-color: transparent;
}
```


----------


## 隐藏滚动条
在IOS上想要隐藏滚动条， 尝试了如下代码
```
element::-webkit-scrollbar {
	display: none;
}
```
这段代码在PC可以正常work， 但是在IOS无法正常工作。 目前为止， 并没有找到合适办法可以隐藏滚动条。


----------


## 出界问题

在ios里引发出界：
全局滚动：滚动到页面顶部或底部时继续向下向上滑动，就会出现
局部滚动：滚动到页面顶部或底部时，手指离开停下，再继续向下向上滑动，就会出现
大概的效果如下（[盗图一张](**https://github.com/muwenzi/Program-Blog/issues/42**)）：
![enter image description here](https://cloud.githubusercontent.com/assets/12554487/19838265/762bb6ba-9f06-11e6-9de5-1047ad489f91.png)


解决方法：
对于全局滚动
```
document.body.addEventListener('touchmove', function(e){
	// 添加一些橡皮筋动画
	e.stopPropagation();
});
```

对于局部滚动， 一般的dom结构如下：

```
<div class="container">
	<div class="scroller">
		<!-- 这里是正文 -->
	</div>
</div>
```
css 样式如下：
```
	body {
		-webkit-overflow-scrolling: touch;
	}
	.container {
		height: 500px;
	}
```
js如下： 
```
	var startY;
	var scroller = $('.scroller');
	scroller.on('touchstart', function(e) {
		startY = e.touches[0].clientY;
	});

	scroller.on('touchmove', function(e){
		curY = e.touches[0].clientY
		// 根据 curY 和 startY 判断滑动方向
		// 计算当前的滚动到的位置， 然后与滑动方向综合考虑是否还能继续滑动
		// 当已经滑动到底部或者顶部还要继续向下或者向上滑动， 则还可以添加一些橡皮筋效果， 然后阻止事件冒泡
	});
```


----------


## 滚动穿透
在IOS中， 如果在可以滚动的元素外面遮上一层蒙版， 此时， 在蒙版上做滑动操作， 会导致蒙版下面的元素发生滚动， 最常见的DOM结构如下：
```
	<!doctype>
	<html>
		<head>
			<meta charset="UTF-8">
			<meta name="viewport" content="width=device-width, initial-scale=1.0">
		</head>
		<style>
			.mask {
				position: fixed;
				left: 0;
				right: 0;
				top: 0;
				bottom: 0;
				background-color: rgba(0, 0, 0, 0.5);
			}
		</style>
		<body>
			<div>
				<!-- 这个里面有很长很长的内容 -->
			</div>
			<div class="mask"></div>
		</body>
	</html>
```
可以在[手机打开查看效果](http://114.55.133.90/scroll1.html)当mask弹出来后， 滑动操作会导致页面滚动(pc 上和手机上效果一样)。 不过由于我们dom结构，有这样的结果也并不稀奇。 那么可以看下面的代码：
```
html, body {
	height: 100%;
	-webkit-overflow-scrolling: touch;
}
.container {
	height: 100%;
	overflow: auto;
}
```
```
	<div class="container">
		<p>
			<!-- 这里面有很长很长的内容 -->
		</p>
	</div>
	<div class="mask"></div>
```
b可以[点这里查看效果](http://114.55.133.90/scroll.html)， 你会发现现在PC上和手机上的表现不一样了。在PC上， 滑动mask不会造成滚动，但是在手机上还是会有滚动效果。
解决方案：
1、当出现mask时，给原本会滚动的元素加overflow：hidden
对于第一种情况 
```
 html {
	 height: 100%;
	 overflow: hidden;
 }
```
[dom1](http://114.55.133.90/scroll1-css-fix)

对于第二种情况
```
.container {
	height: 100%;
	overflow: hidden;
}
```
[dom2](http://114.55.133.90/scroll-css-fix)

2、 在mask上监听touchmove事件， 并阻止默认行为 preventDefault
```
	$('.mask').on('touchmove', function(e){
		e.preventDefault();
	});
```

3、给body添加position:fixed属性， 这种方法适用于第二种dom结构， 但是其在IOS上，由于浏览器露底， 会出现比较[奇怪的现象](http://114.55.133.90/scroll1-js-fix.html)， 让人不省心

```
body.mask-open{
	position: fixed;
	width: 100%;
}
```
----------
## 适配

移动端适配是一大难题， 原因在于移动终端实在太过于五花八门！ 放个图感受下： 

![](https://raw.githubusercontent.com/wflkaaa/dragonfly/master/code/images/device-list.png)

就苹果一家， 就有这么多， 心累～～

关于图片ICON之类， 需要根据屏幕像素比加载不同分辨率的图片， 之前有这方面的阐述了， 这里不在赘述， 感兴趣的可以上[戳这里](http://yt-dragonfly.tech/dragonfly/2017/03/16/Responsive-Image/)。 本次着重谈下文字适配。
在偷窥了[网易新闻](http://3g.163.com/touch/news/subchannel/all?dataversion=A&version=v_standard)和[阿里手淘](https://m.taobao.com/?sprefer=sypc00#index)后发现两家大厂在对文字的适配上有自己理解。网易认为文字也需要根据屏幕大小变化而变化， 而阿里手淘觉得文字应该在不同的屏幕上显示一样大小的文字。两家虽然理解不同，但在实现手法上大同小异，都是围绕rem做文章。两家具体做法如下：
 - 以设计稿为基准， 计算各机型html的font-size大小。
	 **网易新闻的设计稿是640px的， 基准的font-size是100px。** 基于这个可以计算出各个不同型号的机器的font-size大小。 比如 iphone5的屏幕宽度是320px， 所以设置其font-size = 320px / 6.4 = 50px；
	 **阿里手淘的设计稿是750px， 然后他们倾向于把设计稿分成100份， 每份为1a， 而且规定10a = 1 rem， 所以其基准的html的font-size为75px 。** 那么如果手机从iphone6变成了6plus， html的font-size该怎么计算？ 由于6plus是3倍屏幕， 因此其实际物理像素是3 × 414px = 1242px, 此时，font-size =  1rem = 10a = 1242 / 10 = 124.2px 。 
		为什么阿里和网易在计算像素上会有这个差别？
我猜测阿里的UI输出的尺寸是1:1的（设计尺寸是750px， 输出尺寸也是750px），而网易是2:1的（设计尺寸是640px， 输出尺寸是320px）， 但这只是表象， 真相是阿里前端在设计网页时， 希望按照750px来设计的，而不是375px！  为什么会有这种想法， 而且我怎么把750px的页面放到375px的手机上呢？
 - 根据手机型号和宽度， 动态改变viewport  
阿里手淘根据自己经验，总结出了[lib-flexible](https://github.com/amfe/lib-flexible)这个开源库，类似下面
```
var metaEl = doc.createElement('meta');
var scale = isRetina ? 0.5:1;
metaEl.setAttribute('name', 'viewport');
metaEl.setAttribute('content', 'initial-scale=' + scale + ', maximum-scale=' + scale + ', minimum-scale=' + scale + ', user-scalable=no');
if (docEl.firstElementChild) {
    document.documentElement.firstElementChild.appendChild(metaEl);
} else {
    var wrap = doc.createElement('div');
    wrap.appendChild(metaEl);
    documen.write(wrap.innerHTML);
}
```
其实质是
- 动态改写<meta>标签
-  给<html>元素添加data-dpr属性，并且动态改写data-dpr的值
-  给<html>元素添加font-size属性，并且动态改写font-size的值
在这一点上， 我并没有看出两家有什么差别， 差别在于， 网易的meta标签里面的initial-scale的数值为1.0， 而阿里手淘的initial-scale是根据屏幕倍率变化的， 对于2倍屏， 其值是0.5， 对于3倍屏， 其值是0.33333333！现在可以理解怎么把750px的东西放到375px里面而不溢出了吧！而且，这样做有一个好处， 就是可以轻松解决[border 1px问题](https://jinlong.github.io/2015/05/24/css-retina-hairlines/)， 这个或许就是阿里手淘这么做的真实原因吧
3、计算元素尺寸的rem值
如果用的scss或者less， 可以尝试定义一个辅助方法用于计算， 如下
```
	px2rem（$px）{
		$rem: 75px;
		return $px/$rem * 1rem;
	}
```
网易新闻会把几乎所有的元素尺寸转换成rem的形式， 包括文字字体， 而阿里手淘则稍微复杂点，他们倾向于如下设置字体
```
.selector {
    width: 2rem;
    border: 1px solid #ddd;
}
[data-dpr="1"] .selector {
    height: 32px;
    font-size: 14px;
}
[data-dpr="2"] .selector {
    height: 64px;
    font-size: 28px;
}
[data-dpr="3"] .selector {
    height: 96px;
    font-size: 42px;
}
```
这样设置的字体在所有屏幕上看到的效果是字号没有任何变化

总结： 看完了两个大厂的做法， 各有千秋， 各位看客见仁见智了！









