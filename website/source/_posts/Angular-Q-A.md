---
title: Angular Q&A
date: 2017-06-07 17:30:17
tags: [Angularjs,ytWebsite]
---

[Modern Angular 1.x essential interview questions](https://toddmotto.com/modern-angular-interview-questions)

<!-- more -->

[TOC]

## Components 

### 什么是 “component”？

这个是Angular.js 1.5之后的概念，在Face Platform的上下文中表示带有Template里的Directive。


## Performance and debugging

### 怎样会在AngularJS里造成一个内存泄露？

比较容易的方式是`$scope`已经call `$destory`了，但还有外部的引用没有取消掉。
	
- `$scope`销毁时没有把`$interval`给cancel掉，类似的还有`$timeout`。
	
```JavaScript
app.module("controllers").controller("memoryLeak", function($interval){
	var counter = 0;
	var timer = $interval(function() {
		counter += 1;
	}, 1000);

	$scope.on("$destory", function() {
		$interval.cancel(timer);
	});
});
```

- `$scope`销毁时没有把添加的Event Listener解绑。（如果event listener是绑在directive对应的template上，则不需要手动解绑，scope destroy时Angular.js会调用`$element.remove`把template上绑定的事件给清理掉。

```JavaScript
var onDocumentClick = function (event) {
	// callback bula
};

$document.on("click", onDocumentClick);

eventBridgeService.on("someEvent", onDocumentClick);

$scope.$on('$destroy', function () {
    $document.off("click", onDocumentClick);
    eventBridgeService.off("someEvent", onDocumentClick);
});
```


### 如何加速`ng-repeat`？

- 使用`track by`，`track by __identifier__`会把DOM Element和scope对应起来，可以避免重复create DOM。`ng-repeat`内部会保存一个blockMap，key是repeat item的hashKey，value是对应item的scope以及DOM Element信息 。如果hashKey已存在，则直接复用，否则会新建DOM Element。这里的hashKey和我们平时理解的不同，如果item为Object / Function，则使用Angular.js内部的UUID（就是一个数字不停往上加1，与object的内容无关），否则使用`type + item value`。

- 在性能压力较大，repeat的内容高度固定时，可以考虑使用`md-virtual-repeat` + `md-virtual-repeat-container`，这两个directive通过循环利用repeat item的DOM，以及只渲染view port内item的方式，来提高repeat性能。

### 使用一次性绑定的好处？

具体可以参考官方文档：[AngularJS: Developer Guide: Expressions](https://docs.angularjs.org/guide/expression#one-time-binding)
这里简单说明一下：一次性绑定会在绑定数据stable（变成非undefined的值）的时候注销watcher，可以减少不必要的watcher。

### `$evalAsync`和`$applyAsync`区别是什么？

`$evalAsync`会把callback push到ayncQueue里；`$applyAsync`会schedule一个新的`$digest`。
`$evalAsync`理论上会在当前的`$digest`循环比较靠后的时间运行callback，`$applyAsync`则会在当前`$digest`结束后，唤起一个新的`$digest`。

digest 的伪代码：

```
Do:
- - - If asyncQueue.length, flush asyncQueue.
- - - Trigger all $watch handlers.
- - - Check for "too many" $digest iterations.
While: ( Dirty data || asyncQueue.length )
```

TL;TR

- [`$scope.$evalAsync()` vs. `$timeout()` In AngularJS](https://www.bennadel.com/blog/2605-scope-evalasync-vs-timeout-in-angularjs.htm)
- [`$scope.$applyAsync()` vs. `$scope.$evalAsync()` in AngularJS 1.3](https://www.bennadel.com/blog/2751-scope-applyasync-vs-scope-evalasync-in-angularjs-1-3.htm)

### `$watch`和`$watchCollection`的区别是什么？

angular本身提供了三种 watch function：$watch, $watchGroup和$watchCollection。

三者的函数签名分别为:

```JavaScript
$watch(watchExpression: string | function, listener, objectEquality: boolean): UnregisterFn
* Registers a `listener` callback to be executed whenever the `watchExpression` changes.

$watchGroup(watchExpression: Array<string> | function, listener): UnregisterFn
* A variant of {@link ng.$rootScope.Scope#$watch $watch()} where it watches an array of `watchExpressions`.
* If any one expression in the collection changes the `listener` is executed.
*
* - The items in the `watchExpressions` array are observed via standard $watch operation and are examined on every
* call to $digest() to see if any items changes.
* - The `listener` is called whenever any expression in the `watchExpressions` array changes.

$watchCollection(watchExpression: string | function, listener): UnregisterFn
* Shallow watches the properties of an object and fires whenever any of the properties change
* (for arrays, this implies watching the array items; for object maps, this implies watching
* the properties). If a change is detected, the `listener` callback is fired.
```

三者都接受watchExpression 和 listener function作为参数，返回一个用来unregister自身的函数。

然后是大家关注的重点，三者check equal的策略。这里列一个结论：
$watch 不传第三个参数objectEquality（默认值为false），则做reference equality check，objectEquality为true的情况下，会调用Angular.equals function来做equality check（deep equal，即递归地检查每个prop）。另外，若objectEquality为true，angular在做脏值检测的时候会deep copy一份expression eval的结果保存下来作为last evaluated value，因此经常看到说objectEquality为true会影响性能（deep check，deep copy）。
$watchGroup 是$watch function的一个变种，可以watch一个expression list，任何一个expression的reference equality发生改变，都会触发listener。
$watchCollection，如果watch的是一个array，则会watch array 的reference，长度，以及里面的每一个item（reference），如果watch的是一个object，则会 watch object上的properties （reference equality，只检查OwnProperty不check原形链）。

### 你熟悉的Angular.js debug工具？

推荐chrome插件：AngularJS Inspect Watchers，ng-inspector for AngularJS。
详情见[debug angularjs | Dragonfly Infinity](http://yt-dragonfly.tech/dragonfly/2017/05/20/debug-angularjs/)

### 什么是strict-di模式？它是如何影响运行时性能的？
strict-di即Strict Dependency Injection模式，要求开发者使用依赖注入时显式地指定dependency（用array声明的方式，或者用`$inject = [dependencies]`）

对运行时性能并无太大影响：[javascript - What is the benefit of AngularJS Strict DI mode? - Stack Overflow](https://stackoverflow.com/questions/33494022/what-is-the-benefit-of-angularjs-strict-di-mode)

Ref: [angularjs源码阅读（一）依赖注入 | Dragonfly Infinity](http://yt-dragonfly.tech/dragonfly/2017/05/20/angularjs%E6%BA%90%E7%A0%81%E9%98%85%E8%AF%BB%EF%BC%88%E4%B8%80%EF%BC%89%E4%BE%9D%E8%B5%96%E6%B3%A8%E5%85%A5/)

### 什么是`$templateCache`？
`$templateCache`是Angular.js的一个Service，用来存放template的缓存，directive templateUrl对应的html资源会存放在`$templateCache`里。可以preload部分template到`$templateCache`里，来加速页面render。

[offline - Is there a way to preload templates when using AngularJS routing? - Stack Overflow](https://stackoverflow.com/questions/18714690/is-there-a-way-to-preload-templates-when-using-angularjs-routing)

### 如何加快`$digest`?

两个方面的考量：减少watcher数量，减少loop次数。

减少watcher数量：

- 使用一次性绑定
- use`ng-if` over `ng-show`/`ng-hide` （这条需要by case

减少loop次数：
	
- 没有直接的方法能够减少loop次数，但是必须要避免增加digest loop次数的写法。举个栗子，ytInfoCardContainer里的isResponsive attribute就是个为了功能牺牲性能的case。`$scope`上watch了detailPanel的高度，在detailPanel的DOM完全长出来（outerHeight稳定）之前，这个watcher会导致整个scope不停digest。

```JavaScript
$scope.$watch(function () {
    return detailPanel && detailPanel.outerHeight(true);
}, extendInfoCard);

function extendInfoCard (newValue) {
    if (!newValue)return;
    infoCard.css('margin-bottom', detailPanel.outerHeight(true) + 40);
}
```

// ---------------------- out of scope -------------------------------

## Directives

### Why use ng-click over addEventListener?

### When would you use addEventListener?

### What is the link function and when should you use it?

### How do you use the link function to communicate back to the controller?
What logic should live inside link, and what logic should live in the controller?
What is the compile function and what can it return?
What are the pre and post link lifecycle methods?
Why can the compile function be more effective than link?
When would you use a directive over a component?
What are event directives, and what are structural directives?
What problems have you faced when using directives?
What practices should you avoid when using directives?
What types of bindings can a directive receive?
When would you use require, and what effect does it have on link?
What is transclusion?
What directive properties would you recommend avoiding?
What directives do you tend to avoid and why?
What different types of scope are there?
What is JQLite and does it have any limitations?

## Forms
How would you implement form validation using the form’s controller?
What do dirty, pristine, touched and untouched mean?
What limitations do AngularJS forms have?
What are some of the built-in validators?
What are $parsers and $formatters, and when should you use them?
What is the $validators pipeline, and when should you use it?
What is ngModelOptions and is it a good directive to implement?

## Routing (ui-router 1.0.0)
What is routing?
What is component routing?
When would you use a template route, if ever?
What is a dynamic route and how do you implement it?
What is “HTML5 mode”?
How would you render a view only when the data has become available?
What are transition hooks and what role do they play in routing?
How do you create sibling views?

## Controllers

What is the role of a controller?
How would you get data into a controller?
When would you use $scope.$watch? Should you? How do you unwatch?
Explain when you would use controllerAs and the effect it has
When should you use $scope inside a controller?
When would you consider using a nested controller? Is it good practice?

## Filters
What is a filter?
How does a filter actually work?
What is the most performant approach to filtering data and why?
How do you use multiple filters at once in templates?
How do you use multiple filters at once inside a controller?
How do you pass arguments to a custom filter?

## Services and HTTP
What is a service?
What is a factory?
What is a provider?
What design patterns do services and factories promote?
What is a service’s role in an Angular application?
What’s the difference between $http and $resource?
When could it make sense to use $resource over $http?
What is a Promise? Name some places Angular uses them.
What is $q and when would you use it?
What is an http interceptor and what are good use cases for it?
What different types of authentication have you implemented?

## Events
When should you use events in AngularJS?
What’s the difference between $emit and $broadcast?
What’s the difference between $scope.$emit and $rootScope.$emit?
How does event unbinding differ in $scope and $rootScope?

## Testing and tooling
What is the difference between a unit and end-to-end (e2e) test?
What tools have you used for unit testing?
What tools have you used for end-to-end (e2e) testing?
What tooling are you familiar with?
Describe how lazy-loading works
What build step processes are effective for faster Angular applications?
Are you using ES6 transpilers or TypeScript?


## Modules and internals

### What are the key building blocks of an Angular application?

How would you describe a module?
What use case do sub-modules have?
What have you learned from studying the Angular source code?
How do you bootstrap Angular asynchronously?
How can you bootstrap multiple applications at once?
What is dependency injection (DI)?
Why is dependency injection useful in Angular?
How does the $digest cycle work?
What is $rootScope and how does it differ to $scope?
When have you used $scope.$apply, and why?
