---
title: Ruibo's Angular Notes
date: 2017-02-07 12:59:50
tags: [rbzhou,Angularjs]
---

# $window, $location

1. `$window`和`window`一模一样。
```
function $WindowProvider() {
  this.$get = valueFn(window);
}
```
可见，`$window`就是将`window`作为injectable的service。另外，`location`就是`window.location`，所以和`$window.location`也是同一个。
使用 `window.location.reload()`,`$window.loacation.reload()`,`location.reload()` 都不会触发angular的`digest`，所以的确可能存在写入locationStorage失败的情况，为什么呢？因为angular还没digest完，页面就已经跳转啦.

2. `$route.reload()`会等到digest完再重定向
`$route.reload()`方法中，会有
```
$rootScope.$evalAsync(function() {
  prepareRoute(fakeLocationEvent);
  if (!fakeLocationEvent.defaultPrevented) commitRoute();
});
```

  `$evalAsync`会将新的操作放到异步队列里，然后等`digest`中的下一个循环中触发，所以`reload`前可以认为操作已经做过一轮了。这个时候`reload`应该就是安全的。

3. angular中的url变化是会被`$location`探查到了

  `$location`中会对url以及状态在`$rootScope`进行监控(watch)。所以，当某个地方调用digest的时候，`$rootScope`中的这个watch会被执行。同时，因为是使用的watch，所以当`params`没有变，调用`$location.search(params)`是不会触发任何东西的。

<!-- more -->

# Attributes.$observe VS Scope.$watch

[observe VS watch](http://stackoverflow.com/questions/14876112/angularjs-difference-between-the-observe-and-watch-methods)
```
$observe is only called in directive.
use $observe only when attr="name: {{name}}", otherwise, use $watch on scope.
```

当`scope`中使用`@`来获取时，如果是有`\{\{ \}\}`的情况，link的时候是取不到值的。
```
Use $observe when you need to observe/watch a DOM attribute that contains interpolation (i.e., {{}}'s).
```

因为html中的`\{\{ \}\}`部分在link的时候是undefined！！！
如果使用 `=` 来获取时，link的时候是有数值的。

所以如果attr中有`\{\{ \}\}`时，一定需要`$observe`，因为`$watch`的结果依然是`undefined`.
这个例子已经非常详细了, [example](http://plnkr.co/edit/HBha8sVdeCqhJtQghGxw?p=preview)

# scope & scope.digest()

rootScope.js是非常重要的文件，因为所有与scope相关的部分，包括`$digest`和`$apply`都在这个文件里。
在`rootScope.js`里面查看一些重要的method，结合`angular`的online Doc, 特别重要的是看Definition。
[rootScope.Scope](https://docs.angularjs.org/api/ng/type/$rootScope.Scope)

关于`$digest`，这篇文章真的很生动。有源码的分析，有理解。
[写一个自己的digest](http://teropa.info/blog/2013/11/03/make-your-own-angular-part-1-scopes-and-digest.html)

第三方需要调用scope的`$digest`，可以使用`$timeout( function() {$apply})`或者`$scope.$evalAsync(function() {})`

比如在某个$watch的回调中调用$evalAsync，那么在同一个digest周期内，进入下一个脏值检查的一开始，会先进行eval的动作(比如给scope上的变量赋值)。$timeout则相当于`$digest`完成后再通过`$apply`调用一次`$digest`.

`$apply`阶段会进行`$eval`的动作，然后从`$rootScope`进行`$digest`
`$digest`简单来说就是遍历scope中的watch直到watch的值没有变化为止。先是当前scope，在往下深度遍历子scope。每个html中的双向绑定都是一个watcher，会放在scope的`$$watchers`里面。

$digest中是有个debugger手段的，可以通过$rootScope查看$$popstDigestQueue和$$applyAsyncQueue和$$asyncQueue



