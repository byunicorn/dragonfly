---
title: angularjs directive scope ＆的用法
date: 2017-05-20 11:23:31
tags: [lbao,Angularjs,Javascript]
---

这两天做refactor的过程中，遇到我们代码中经常出现的一种pattern：

html:

```
<my-directive on-click="uploadImage"></my-directive>
```

directive.js:

```
scope: {
    onClick: "&"
},
link: function(scope, element) {
    var callback = scope.onClick();
    doStuff();
    callback();
}
```

<!-- more -->
看得我黑人问号……这是什么写法从未见过，还有为啥要调用两次啊？(scope.onClick(); 一次，callback(); 一次)
其实如果只是想要传一个function的reference进来，为啥不直接用 = 呢
```
scope: {
    onClick: "="
},
link: function(scope, element) {
    doStuff();
    scope.onClick();
}
```
比上面那种要好理解多了……不过不是非常推荐这么写，原因……有时间我再写一篇更长的解释……

其实 & 的原意是想要提供一种在parent scope里执行expression的途径。
注意，这里说的是expression，所以下面这段：
```
<widget on-click="count = count + value"></widget>
```
```
scope: {
    onClick: "&"
},
link: function(scope) {
    scope.onClick();
}
```
会在parent scope里执行 count = count + value，官方的意愿是好的，可大家都不这么写，html里面直接写expression，是挺奇怪的……

对于＆mapping，传到directive的isolate scope里的其实是一个function wrapper：把expression包到parent scope上下文里的一个function。这么说有点绕，看源码简单点：
```
case '&':
    parentGet = $parse(attrs[attrName]);
    isolateScope[scopeName] = function(locals) {
        return parentGet(scope, locals);
    };
    break;
```
先parse传进去的expression，然后wrap一层，最后绑到directive isolate scope上。
我们代码里出现的那种连调两次的写法能work的原因是，第一次调用返回了parent scope里的function reference，第二次才是真正地调用那个function。

最后，是官方推荐写法：
```
$scope.bula = function(p1, p2) {
    console.log(p1 + p2);
};
<my-directive on-click="bula(param1, param2)"></my-directive>
scope: {onClick: "&"},
link: function () {
    scope.onClick({param1: "bula", param2: "eihei"});
}
```
把需要的参数写成一个object map传回去，html里面还要严格对应参数名，个人也不喜欢这种写法，很罗嗦，而且容易忘掉参数mapping，不过它是官方推荐的把isolate scope里面的东西丢回parent scope里的做法。

如果有遗漏欢迎补充。
