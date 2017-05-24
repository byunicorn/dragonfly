---
title: check undefined的拓展阅读
date: 2017-05-20 11:04:35
tags: [lbao]
---

今天refactor的时候想自己写点脚手架，看到一个关于check undefined的很迷的写法share给大家。
```
if (obj[key] === void 0) obj[key] = source[key];
```
下面是关于void的解释：

The void operator evaluates the given expression and then returns undefined.
... This operator allows inserting expressions that produce side effects into places where an expression that evaluates to undefined is desired.

The void operator is often used merely to obtain the undefined primitive value, usually using "void(0)" (which is equivalent to "void 0"). In these cases, the global variable undefined can be used instead (assuming it has not been assigned to a non-default value).

所以经常看到的长下面这样的html，其实返回的就是undefined：
```
<a href="javascript:void(0)" id="loginlink">login</a>
```

很久之前还有下面这样check undefined的方式：
```
var bula;
if(bula === undefined){ console.log("bula"); }
```
但是因为undefined这个value在ECMAScript 3之后的版本是writable的，所以很快就狗带了。

最后就是```typeof bula === "undefined"```，这个最通用的方法。

总结下来，void 0 应该是我所知道的，代码量最少的check undefined的方式了。如果以后写那种惜字如金的lib代码，可以考虑使用。

当然在angular框架里还是继续推荐大家用angular.isUndefined来check undefined。


