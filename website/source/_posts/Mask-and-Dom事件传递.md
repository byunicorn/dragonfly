---
title: Mask and Dom事件传递
date: 2016-11-02 19:59:09
tags: [zmzhang, JavaScript, CSS]
---


在网页开发经常遇到需要使用mask的情况，比如：添加水印，reload时候添加蒙板等情况。大多数要使用mask的情况是防止用户点击不必要的元素，但是有些情况（如加水引等）只是显示上的功能，并不希望阻止元素获取事件。

有两种方式实现上述功能

#### 优雅高效的

css 方式实现事件穿透： `pointer-events:none`; pointer-events y允许控制特定的元素何时成为鼠标事件的target

<!-- more -->

```
 初始值    auto
 适用元素   all elements
 语法 pointer-events:  auto | none | visiblePainted | visibleFill | visibleStroke | visible | painted | fill | stroke | all | inherit
```

其中常用的为两种：

* auto： 默认属性，对于svg内容该值与visiblePainted相同
* none: 元素永远不会成为鼠标事件的target，但是，当其后代元素的pointer-events属性指定其他值时，鼠标事件可以指向后代元素，在这种情况下，鼠标事件将在捕获或冒泡阶段触发父元素的事件侦听器。其他属性都只适用于svg元素
*  兼容性：


| Feature | Chrome| Firefox (Gecko)| Internet Explorer| Opera | Safari (WebKit)|
| ------------- | ------------- | ------------- | ------------- | ------------- | ------------- | 
|SVG support |  1.0 | 1.5 (1.8)|    9.0 |9.0 (2.0)| 3.0 (522)|
|HTML/XML content|   2.0|    3.6 (1.9.2)|    11.0|   15.0|   4.0 (530)|


#### 暴力（非万不得已不推荐）

用js进行事件传递，给大家提供一种思路：
用angularjs的directive方式做的demo
template.html

```html
    <canvas><canvas>
    
```

directive.js


```JavaScript
    directives.directive('waterMask', ['configs','canvasHelper', function (configs, canvasHelper) {
    return{
        restrict: 'EA',
        replace: true,
        templateUrl: "template.html",
        link: linkFn
    };
    function linkFn(scope, element, attr) {
        var eventList = getAllEvents(element[0]);
        element.bind(eventList, function (e) {
            $(element).next().trigger(e)
        })
    }
    function getAllEvents(element) {
        var result = [];
        for (var key in element) {
            if (key.indexOf('on') === 0) {
                result.push(key.slice(2));
            }
        }
        return result.join(" ");
    }
}])

```

