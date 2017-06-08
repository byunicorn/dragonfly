---
title: debug angularjs
date: 2017-05-20 11:27:44
tags: [lbao,Angularjs,Javascript]
---

1. Chrome Extension:
Angular.js 1.x: ng-inspector，第三方开发
可以用来查看scope内部的值，以及scope对应的element在页面上的cover范围（下图淡蓝色区域）
可以通过点击对应的element和scope把值print到console里，从而方便地反查到element在DOM里的位置（console区域）
缺点在于没有filter，想定位到某个scope的某个属性值，只能自己慢慢捞

![](https://github.com/wflkaaa/dragonfly/blob/master/code/images/angular-debug1.png?raw=true)

<!-- more -->

Angular.js 2.x: Augury
亲儿子，Angular Team开发
界面很酷炫，基本功能都提供了，可以查看scope，以及注入到scope的injector内容
可以方便地看到整棵router tree（是否支持lazy load还待确认）
感觉有些比较鸡肋（也可能是用来实验的项目结构比较简单）

![](https://github.com/wflkaaa/dragonfly/blob/master/code/images/angular-debug2.png?raw=true)

2. Chrome Developer Tool
scope是angular用来连系view和model的基本单位，想要的信息一般都能在scope里面捞到，下面说明怎么捞，还有捞回来能做啥。
怎么捞：
比如说，我们想要知道页面管理按钮对应的scope
a. 用elements tab的选取工具，选中manage按钮

![](https://github.com/wflkaaa/dragonfly/blob/master/code/images/angular-debug3.png?raw=true)

b. console 里面输入var target = angular.element($0).scope();
c. 好了，你拿到所需要的scope了。

这里解释一下，$0是chrome developer tool给的一个“快捷方式”，表示你当前选中的元素，$1表示你上一个选中的元素，$2表示上上个，依次类推。
这里angular.element($0)，相当于用angular内部的jqLite选择器给选中的元素包了一层，然后调用scope function会顺着选中的元素往上（往祖先元素）找离自己最近的scope。

scope里面的信息很多，主要有几部分：
a. 该scope的各种亲戚信息（p.s. angularjs整个scope结构是个树状的链表，顶端是单个rootScope，每一节点scope都存有自己parent节点，孩子链表的head/tail，前一个sibling/后一个sibling的信息，方便在destory的时候把自己以及自己的孩子们从整个树形结构中detach掉。
b. scope的watchers：吃性能的大头
c. 各种我们绑到$scope上的属性，方法，bulabula

![](https://github.com/wflkaaa/dragonfly/blob/master/code/images/angular-debug4.png?raw=true)

捞回来可以做甚：
$digest, $eval, $apply, $watch <--- 基本上就是这几种操作了
遇到需要线上debug的情况，直接改变scope的绑定值，然后手动触发 $digest()，查看页面改变还是比较有用的。比如说实际数据里没有外部库 or 内部库，我想要看图像库管理的部分能不能正确render，就可以用这种方法……

其他可能比较有用的：

angular.element($0).injector().get("....")可以拿到各种service/provider，比如：angular.element($0).injector().get("$rootScope");
//是的，rootScope是个provider
angular.element($0).controller("ngModel")
可以拿到当前元素上ngModel directive的controller

写个filter查看插值：
```
app.filter('debug', function() { 
	return function(input) {
		if (input === '') return 'empty string';  
		console.log(input);  
		return input ? input : ('' + input);  
	};
});
```
使用:

```
{{ value | debug }}
```

如果有其他好用的方法，欢迎分享。

