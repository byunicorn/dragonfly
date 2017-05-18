---
title: Study Of Promise
date: 2017-05-17 22:09:22
tags: [lbao,JavaScript]
---

## 前言
如果回答下面的问题对你来说有点困难，那么这篇文章可能对你还是有些帮助的：

1. 下面的代码会console出啥：

	```JavaScript
	let promise = $q(function(resolve, reject) {
		resolve(233);
	});
	promise
	.then(function() { throw 123; })
	.then(function() { console.log(1); })
	.then(function() { console.log(2); }, function() {console.log(3);})
	.then(function() { console.log(4); }, function() {console.log(5);});
	```

2. 给你一个基础的promise实现，让你extend一个finally function出来，你咋写？

<!-- more -->

## 定义

具体的定义在这里：http://wiki.commonjs.org/wiki/Promises/A

这里就讲重要的两点：

> A promise represents the eventual value returned from the single completion of an operation. A promise may be in one of the three states, unfulfilled, fulfilled, and failed. 

> A promise is defined as an object that has a function as the value for the property 'then':
> `then(fulfilledHandler, errorHandler, progressHandler)`

一个promise有三个状态：`unfulfilled`， `fulfilled`， 和`failed`，也有一些实现叫做`pending`，`fulfilled`和`rejected`。
状态改变只可能从`pending`到`fulfilled`或者从`pending`到`rejected`。当一个promise的状态变为了`fulfilled`或者`rejected`，这个promise的值就像一个primitive（值类型）一样，不可以再改变了。得益于这样的不可变性，我们可以避免listener带来的不可预期的副作用，可以把promise像一个primitive一样传给不同的function，而不用担心它的状态或者值被修改。

then function 中所有的参数都是可选的，promise resolve了调用 fulfilled handler，reject了则调用 error handler。p.s. 至于progress handler，不但handler的参数是可选的，连progress event 也是可选的，很多promise的实现都无视了progress这个阶段。

then function会返回一个新的promise，这就允许了我们链式地去操作promise。如果callback里throw了error，那么返回的promise状态会被置为rejected；如果callback顺利执行，那么返回的promise状态会被置为fulfilled。若在这个返回的新promise后再接then，该then的fulfillHandler拿到的参数值，就是前面promise的fulfill值；于此相对，errorHandler拿到的参数值，是前面promise的reject值。

```JavaScript
let promise = $q.when(123);
promise
.then(function(value) {console.log(value); throw value;}) // fulfillhandler value: 123
.then(function() {}, function(err) { console.log(err); return 321;})  // errorhandler err: 123
.then(function(value) { console.log(value); }); // fulfillhandler value: 321
```

那么你可能会问，如果在handler里，return的是一个promise的话会发生什么？这个行为在promise/A spec里并没有定义，但是在spec的Test Suite里，有这么一条：
[promises-tests/2.3.2.js at master · promises-aplus/promises-tests](https://github.com/promises-aplus/promises-tests/blob/master/lib/tests/2.3.2.js)

简单地总结: `2.3.2: If x is a promise, adopt its state",`

详细地总结： 如果在handler里return一个promise(称为pA)，那么then返回的promise(称为pB)会过继pA的状态。（只是继承状态，两个promise不是同一个实例）


```JavaScript
let p = $q.when(123);
let p1;
let p2 = p.then(function(value) {console.log(value); p1 = $q.when(value + 1); return p1;}); // console 123
console.log(p1 === p2); // console false
let p3;
let p4 = p2.then(function(value) {console.log(value); p3 = $q.reject(value + 1); return p3; });	// console 124
console.log(p3 === p4);	// console false
let p5 = p4.then(function() {}, function(value) {console.log(value);}); // console 125
```

## 用来做什么

> aggregate callback只是Promise的很小一部分功能，Promise解决了更加深层的问题：它提供了同步function和异步function之间的直接对应。

同步function有两个很重要的功能点：

- 返回值：你可以把返回值丢给后续执行的function
- 抛异常：如果一个function的执行过程中出现了问题，可以抛出异常，然后绕过所有后续的组合层，直到有人把它`catch`住。

但在异步的世界里，你无法返回值：因为在那个时间点，应该返回的值还没ready。类似的，你也不能抛异常，因为抛出异常的时候，没有人在接它。所以我们会遇到所谓的回调地狱：你需要把返回值和抛出的异常手动地chain起来。

```JavaScript
step1(function (value1) {
	step2(value1, function(value2) {
	    step3(value2, function(value3) {
	        // bula bula
	    });
	}, function(err2) {
		// recover or something else
	});
}, function(err1) {
	// recover or something else
});
```

如果你使用了一个正确地实现了then方法的promise library，那么下面这段异步function，相当于后续的同步代码：

```JavaScript
step1() // promise-returning function
.then(step2)
.then(step3)
.then(
    function (result) {
      console.log("yeah, succeed!", result);
    },
    function (error) {
      console.error("oops, something happened!", error);
    }
);
```

```JavaScript
try {
  var value1 = step1(); // blocking function
  var value2 = step2(value1);
  var value3 = step3(value2);
  console.log("yeah, succeed!", result);
} catch (error) {
  console.error("oops, something happened!", error);
}
```


## 3.0 之前的jquery promise实现是个坑

[promise - Problems inherent to jQuery $.Deferred (jQuery 1.x/2.x) - Stack Overflow](http://stackoverflow.com/questions/23744612/problems-inherent-to-jquery-deferred-jquery-1-x-2-x)

有兴趣的同学可以去这条里看一下，这里给个简单的总结：

### 错误的Error Handler

首先unsafe throw error不会被catch住：开篇提到的console结果的问题，在jquery promise的实现里，输出会不同，throw 完 error就go die了。

其次，下面这段代码，console的会是3,5，而不是3,4：

```JavaScript
var d = $.Deferred();
d
.then(function() { console.log(1); })
.then(function() { console.log(2); }, function() {console.log(3);})
.then(function() { console.log(4); }, function() {console.log(5);});

d.reject();
```

如果你想在console完3之后让promise回归正常的路径，你必须return一个新的defer。

```JavaScript
var d = $.Deferred();
d
.then(function() { console.log(1); })
.then(function() { console.log(2); }, function() {
  console.log(3); 
  var tmp = $.Deferred(); 
  tmp.resolve(); 
  return tmp;
})
.then(function() { console.log(4); }, function() {console.log(5);});

d.reject();
```

### 无法预测的执行顺序

对于已经resolve or reject的promise，jquery会立即执行then里的callback。

```JavaScript
var d = $.Deferred();
console.log("what");
d
.then(function() { console.log("hell"); });
console.log("the");
d.resolve();

console.log("what");
d
.then(function() { console.log("hell"); });
console.log("the");
```

前半部分会console "what the hell"， 后半则会console "what hell the"。

推荐使用implement了Promises/A规范的库，比如q.js，另外我们使用的angular.js里的$q，就完整地follow了这个规范，顺便做了一些自己的扩展。


## 写在最后

当然是答案啦：

1.  https://codepen.io/anon/pen/ybxNmO?editors=1111
2.  课后作业


## References
[You're Missing the Point of Promises](https://gist.github.com/domenic/3889970)