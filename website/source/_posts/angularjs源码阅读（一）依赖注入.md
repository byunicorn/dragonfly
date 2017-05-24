---
title: angularjs源码阅读（一）依赖注入
date: 2017-05-20 11:48:53
tags: [lbao,Angularjs,Javascript]
---

javascript语言本身是弱类型的，怎么整依赖注入，这是我看Angular.js 官网时候遇到的一个疑问。
后来看完这部分的源代码，挺佩服能想到这么个实现方案的人的脑洞的。
简单来说，就是把一个function toString，然后用正则表达式把传入的参数parse出来，最后按参数名去找对应的依赖……
首先，把一个function toString会print出这个function的全部定义，这个没什么用的功能我之前是不知道的:

![](https://github.com/wflkaaa/dragonfly/blob/master/code/images/dependency-injection.png?raw=true)

其次就是angularjs会将所有你加载的directive/provider全部存到一个cache object里面（外部不可见），然后按名字加载对应的实例。
这也是angularjs做uglify时候要特别注意的原因，uglify会改变函数参数名（变成简单的一两个字母），如果再按照function toString的方式就找不到了，所以angularjs推荐array的写法（定义provider/directive的时候传入一个数组，dependency写前头，最后一个是方法的实现），因为array里面的string不会被uglify。
<!-- more -->
下面是1.2.29版angularjs对应的代码实现：
```
/**
 * @ngdoc module
 * @name auto
 * @description
 *
 * Implicit module which gets automatically added to each {@link auto.$injector $injector}.
 */

var FN_ARGS = /^function\s*[^\(]*\(\s*([^\)]*)\)/m;
var FN_ARG_SPLIT = /,/;
var FN_ARG = /^\s*(_?)(\S+?)\1\s*$/;
var STRIP_COMMENTS = /((\/\/.*$)|(\/\*[\s\S]*?\*\/))/mg;
var $injectorMinErr = minErr('$injector');
function annotate(fn) {
    var $inject,
        fnText,
        argDecl,
        last;

    if (typeof fn === 'function') {
        if (!($inject = fn.$inject)) {
            $inject = [];
            if (fn.length) {
                fnText = fn.toString().replace(STRIP_COMMENTS, '');
                argDecl = fnText.match(FN_ARGS);
                forEach(argDecl[1].split(FN_ARG_SPLIT), function(arg){
                    arg.replace(FN_ARG, function(all, underscore, name){
                        $inject.push(name);
                    });
                });
            }
            fn.$inject = $inject;
        }
    } else if (isArray(fn)) {
        last = fn.length - 1;
        assertArgFn(fn[last], 'fn');
        $inject = fn.slice(0, last);
    } else {
        assertArgFn(fn, 'fn', true);
    }
    return $inject;
}
```
