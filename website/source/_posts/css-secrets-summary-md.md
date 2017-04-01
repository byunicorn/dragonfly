---
title: 《CSS揭秘》概要
date: 2017-03-23 20:30:23
tags: [kailiu,css]
---
## 前言

学姐推荐的《CSS揭秘》是本好书，我总结了一些我们可能用的到的知识点，建议有时间还是看原书。

## 第一章

- css3：非正式集合，属性版本<=3
- 浏览器前缀，“史诗般的失败”：`-webkit-border-radius:10px; border-radius:10px;`
- [CSS编码技巧 - *减少改动时需要同时编辑的地方*]：
  - `font-size:20px; line-height:30px;` --> `font-size:20px; line-height:1.5;`  
  - `rem,em,%`
  - `button: border-color,box-shadow,text-shadow,background-color`
  - `border-width:10px 10px 10px 0;` --> `border-width:10px;border-left-width:0;`
  - `currentColor与inherit` [默认继承与优先级](http://yt-dragonfly.tech/dragonfly/2016/12/03/CSS%E5%B1%9E%E6%80%A7%E9%87%8D%E7%BD%AE%E5%8F%8A%E7%9B%B8%E5%85%B3%E5%85%B3%E9%94%AE%E5%AD%97/)

- [CSS编码技巧 - *避免不必要的媒体查询*]
  - 媒体查询的断点不应该由具体设备决定
  - 可替换元素设置`max-width:100%;`

- [CSS编码技巧 - *合理使用简写*]
  - 展开式属性：覆盖具体属性；简写：覆盖全部属性。例，如果想得到纯色背景：`background:green;` vs `background-color:green;`
  - 属性值可以扩散并应用到列表属性的每一项：
    ```
    background:url(tr.png) no-repeat top right,
               url(br.png) no-repeat bottom right,
               url(bl.png) no-repeat bottom left;
    ```
    ```
    background:url(tr.png) top right,
               url(br.png) bottom right,
               url(bl.png) bottom left;
    background-repeat:no-repeat;           
    ```

## 第二章

第二章开始为近50个难题的solution。

### *背景与边框*

#### 1.半透明边框

*知识点：background-clip*

<p data-height="265" data-theme-id="0" data-slug-hash="yMEMLb" data-default-tab="css,result" data-user="wflkaaa" data-embed-version="2" data-pen-title="yMEMLb" class="codepen">See the Pen <a href="http://codepen.io/wflkaaa/pen/yMEMLb/">yMEMLb</a> by wflkaaa (<a href="http://codepen.io/wflkaaa">@wflkaaa</a>) on <a href="http://codepen.io">CodePen</a>.</p>
<script async src="https://production-assets.codepen.io/assets/embed/ei.js"></script>

#### 2.多重边框

*知识点：box-shadow,inset,outline*

<p data-height="265" data-theme-id="0" data-slug-hash="WpypwG" data-default-tab="css,result" data-user="wflkaaa" data-embed-version="2" data-pen-title="WpypwG" class="codepen">See the Pen <a href="http://codepen.io/wflkaaa/pen/WpypwG/">WpypwG</a> by wflkaaa (<a href="http://codepen.io/wflkaaa">@wflkaaa</a>) on <a href="http://codepen.io">CodePen</a>.</p>
<script async src="https://production-assets.codepen.io/assets/embed/ei.js"></script>

#### 3.灵活的背景定位

*知识点：background-position,background-origin*

<p data-height="265" data-theme-id="0" data-slug-hash="LWrWXw" data-default-tab="css,result" data-user="wflkaaa" data-embed-version="2" data-pen-title="LWrWXw" class="codepen">See the Pen <a href="http://codepen.io/wflkaaa/pen/LWrWXw/">LWrWXw</a> by wflkaaa (<a href="http://codepen.io/wflkaaa">@wflkaaa</a>) on <a href="http://codepen.io">CodePen</a>.</p>
<script async src="https://production-assets.codepen.io/assets/embed/ei.js"></script>

#### 4.边框内圆角

*知识点：box-shadow,outline*

![](http://ohpf8h425.bkt.clouddn.com/inner-corder.png)

<p data-height="265" data-theme-id="0" data-slug-hash="mWKmbr" data-default-tab="css,result" data-user="wflkaaa" data-embed-version="2" data-pen-title="mWKmbr" class="codepen">See the Pen <a href="http://codepen.io/wflkaaa/pen/mWKmbr/">mWKmbr</a> by wflkaaa (<a href="http://codepen.io/wflkaaa">@wflkaaa</a>) on <a href="http://codepen.io">CodePen</a>.</p>
<script async src="https://production-assets.codepen.io/assets/embed/ei.js"></script>

#### 5.条纹背景

*知识点：linear-gradient,background-size*

<p data-height="265" data-theme-id="0" data-slug-hash="vxrmex" data-default-tab="html,result" data-user="wflkaaa" data-embed-version="2" data-pen-title="vxrmex" class="codepen">See the Pen <a href="http://codepen.io/wflkaaa/pen/vxrmex/">vxrmex</a> by wflkaaa (<a href="http://codepen.io/wflkaaa">@wflkaaa</a>) on <a href="http://codepen.io">CodePen</a>.</p>
<script async src="https://production-assets.codepen.io/assets/embed/ei.js"></script>

#### 6.复杂的背景图案（略）

*知识点：linear-gradient,background-size*

<p data-height="265" data-theme-id="0" data-slug-hash="MpXXvL" data-default-tab="css,result" data-user="wflkaaa" data-embed-version="2" data-pen-title="MpXXvL" class="codepen">See the Pen <a href="http://codepen.io/wflkaaa/pen/MpXXvL/">MpXXvL</a> by wflkaaa (<a href="http://codepen.io/wflkaaa">@wflkaaa</a>) on <a href="http://codepen.io">CodePen</a>.</p>
<script async src="https://production-assets.codepen.io/assets/embed/ei.js"></script>

#### 7.伪随机背景（略）

#### 8.连续图片边框

*知识点：border-image,background-image*

<p data-height="265" data-theme-id="0" data-slug-hash="BWPaKq" data-default-tab="css,result" data-user="wflkaaa" data-embed-version="2" data-pen-title="BWPaKq" class="codepen">See the Pen <a href="http://codepen.io/wflkaaa/pen/BWPaKq/">BWPaKq</a> by wflkaaa (<a href="http://codepen.io/wflkaaa">@wflkaaa</a>) on <a href="http://codepen.io">CodePen</a>.</p>
<script async src="https://production-assets.codepen.io/assets/embed/ei.js"></script>

### *形状*

#### 9.自适应椭圆

*知识点：border-radius*

<p data-height="265" data-theme-id="0" data-slug-hash="MpBWbY" data-default-tab="css,result" data-user="wflkaaa" data-embed-version="2" data-pen-title="MpBWbY" class="codepen">See the Pen <a href="http://codepen.io/wflkaaa/pen/MpBWbY/">MpBWbY</a> by wflkaaa (<a href="http://codepen.io/wflkaaa">@wflkaaa</a>) on <a href="http://codepen.io">CodePen</a>.</p>
<script async src="https://production-assets.codepen.io/assets/embed/ei.js"></script>

#### 10.平行四边形

*知识点：transform,pseduo*

<p data-height="265" data-theme-id="0" data-slug-hash="zZJyOo" data-default-tab="css,result" data-user="wflkaaa" data-embed-version="2" data-pen-title="zZJyOo" class="codepen">See the Pen <a href="http://codepen.io/wflkaaa/pen/zZJyOo/">zZJyOo</a> by wflkaaa (<a href="http://codepen.io/wflkaaa">@wflkaaa</a>) on <a href="http://codepen.io">CodePen</a>.</p>
<script async src="https://production-assets.codepen.io/assets/embed/ei.js"></script>

#### 11.菱形图片

*知识点：transform,clip-path*

<p data-height="265" data-theme-id="0" data-slug-hash="QpVRMM" data-default-tab="css,result" data-user="wflkaaa" data-embed-version="2" data-pen-title="QpVRMM" class="codepen">See the Pen <a href="http://codepen.io/wflkaaa/pen/QpVRMM/">QpVRMM</a> by wflkaaa (<a href="http://codepen.io/wflkaaa">@wflkaaa</a>) on <a href="http://codepen.io">CodePen</a>.</p>
<script async src="https://production-assets.codepen.io/assets/embed/ei.js"></script>

#### 12.切角效果

*知识点：linear-gradient*

<p data-height="265" data-theme-id="0" data-slug-hash="GWYKYj" data-default-tab="css,result" data-user="wflkaaa" data-embed-version="2" data-pen-title="GWYKYj" class="codepen">See the Pen <a href="http://codepen.io/wflkaaa/pen/GWYKYj/">GWYKYj</a> by wflkaaa (<a href="http://codepen.io/wflkaaa">@wflkaaa</a>) on <a href="http://codepen.io">CodePen</a>.</p>
<script async src="https://production-assets.codepen.io/assets/embed/ei.js"></script>

#### 13.梯形标签页

*知识点：transform3D*

<p data-height="265" data-theme-id="0" data-slug-hash="xqQKKY" data-default-tab="css,result" data-user="wflkaaa" data-embed-version="2" data-pen-title="xqQKKY" class="codepen">See the Pen <a href="http://codepen.io/wflkaaa/pen/xqQKKY/">xqQKKY</a> by wflkaaa (<a href="http://codepen.io/wflkaaa">@wflkaaa</a>) on <a href="http://codepen.io">CodePen</a>.</p>
<script async src="https://production-assets.codepen.io/assets/embed/ei.js"></script>

#### 14.饼图

*知识点：transform,animate,svg*

<p data-height="265" data-theme-id="0" data-slug-hash="vxQdrq" data-default-tab="css,result" data-user="wflkaaa" data-embed-version="2" data-pen-title="vxQdrq" class="codepen">See the Pen <a href="http://codepen.io/wflkaaa/pen/vxQdrq/">vxQdrq</a> by wflkaaa (<a href="http://codepen.io/wflkaaa">@wflkaaa</a>) on <a href="http://codepen.io">CodePen</a>.</p>
<script async src="https://production-assets.codepen.io/assets/embed/ei.js"></script>

### *视觉效果*

#### 15.单侧投影

*知识点：box-shadow*

<p data-height="265" data-theme-id="0" data-slug-hash="QpzdOa" data-default-tab="css,result" data-user="wflkaaa" data-embed-version="2" data-pen-title="QpzdOa" class="codepen">See the Pen <a href="http://codepen.io/wflkaaa/pen/QpzdOa/">QpzdOa</a> by wflkaaa (<a href="http://codepen.io/wflkaaa">@wflkaaa</a>) on <a href="http://codepen.io">CodePen</a>.</p>
<script async src="https://production-assets.codepen.io/assets/embed/ei.js"></script>

#### 16.不规则投影

*知识点：box-shadow,[svg filter](http://www.baidu.com/link?url=hSqKyuAoxAfgHWK7zrAnPgKLPIe9byQDIGonpeGidgf3YZGZS_h32Oe4AfsDTP9aSxgPAFIf8viBrCCk_eW15q&wd=&eqid=a17c1a19000005eb0000000458ddfa30)*

<p data-height="265" data-theme-id="0" data-slug-hash="RpEpRZ" data-default-tab="css,result" data-user="wflkaaa" data-embed-version="2" data-pen-title="RpEpRZ" class="codepen">See the Pen <a href="http://codepen.io/wflkaaa/pen/RpEpRZ/">RpEpRZ</a> by wflkaaa (<a href="http://codepen.io/wflkaaa">@wflkaaa</a>) on <a href="http://codepen.io">CodePen</a>.</p>
<script async src="https://production-assets.codepen.io/assets/embed/ei.js"></script>

#### 17.染色效果

*知识点：filter,blend-mode*

<p data-height="265" data-theme-id="0" data-slug-hash="gmZmjj" data-default-tab="css,result" data-user="wflkaaa" data-embed-version="2" data-pen-title="gmZmjj" class="codepen">See the Pen <a href="http://codepen.io/wflkaaa/pen/gmZmjj/">gmZmjj</a> by wflkaaa (<a href="http://codepen.io/wflkaaa">@wflkaaa</a>) on <a href="http://codepen.io">CodePen</a>.</p>
<script async src="https://production-assets.codepen.io/assets/embed/ei.js"></script>

#### 18.毛玻璃效果

*知识点：filter*

<p data-height="265" data-theme-id="0" data-slug-hash="mWaxPy" data-default-tab="css,result" data-user="wflkaaa" data-embed-version="2" data-pen-title="mWaxPy" class="codepen">See the Pen <a href="http://codepen.io/wflkaaa/pen/mWaxPy/">mWaxPy</a> by wflkaaa (<a href="http://codepen.io/wflkaaa">@wflkaaa</a>) on <a href="http://codepen.io">CodePen</a>.</p>
<script async src="https://production-assets.codepen.io/assets/embed/ei.js"></script>

#### 19.折角效果

*知识点：linear-gradient,transform*

<p data-height="265" data-theme-id="0" data-slug-hash="mWaxPy" data-default-tab="css,result" data-user="wflkaaa" data-embed-version="2" data-pen-title="mWaxPy" class="codepen">See the Pen <a href="http://codepen.io/wflkaaa/pen/mWaxPy/">mWaxPy</a> by wflkaaa (<a href="http://codepen.io/wflkaaa">@wflkaaa</a>) on <a href="http://codepen.io">CodePen</a>.</p>
<script async src="https://production-assets.codepen.io/assets/embed/ei.js"></script>






