---
title: 关于angular filter
date: 2017-05-20 11:51:47
tags: [lbao,Angularjs,Javascript]
---

前天瑞波问我一个问题，repository页面做内/外部人像库分隔的那部分逻辑（我写的），filter没work。
我写的那段大概长下面这样，传进来的参数就是可用的repo，然后用filter来分离内部库和外部库，是网上查的+我脑补的取反写法的综合：
```
<ul class="all-wrapper">
    <li  ng-repeat="item in availableRepository | filter: ! item.isGlobal">
        {{item.name}}
    </li>
    <li class="single-item global-item">
        <span>外部人像库</span>
    </li>
    <li ng-repeat="item in availableRepository | filter:item.isGlobal">
        {{item.name}}
    </li>
</ul>
```
当时改完跑起来看，全是外部库，没有内部库，我以为数据就长这样，也就没在意……
提问：上面这种写法，其实是做了啥？
答：其实是对item里每个property做了check，只要有一个property的值包含"false"这个字符串，item就会出现在第一个过滤结果中，同理，只要有一个值包含"true"，item就会在第二个过滤结果中……
<!-- more -->
angular的filter，默认行为其实是做字符串查找，而且是不分大小写的那种。
如果你的filter是个function，不会有歧义，item值传进去，你返回true or false就行
如果你的filter是个string/boolean/number，默认会把你的string/boolean/number转成字符串，然后查找item的每个属性，属性值有substring是你的filter值，就算匹配成功，我的那种写法就中了这一条
如果你的filter是个object，比如{isGlobal: true}，那么就会去匹配item里面isGlobal这个property，依然是把值转成string，找子串儿……

网传的取反写法：
filter:'!'+myFilter
http://stackoverflow.com/questions/13464809/reverse-polarity-of-an-angular-js-filter/17811582#17811582
回答最高的那个太误导人了，为啥这么说呢，对于filter是字符串的情况，比如"!bula" 或者 {isGlobal: "!bula"}，是可以的。但如果你的filter是个function，你再写个!checkValue或者'!' + checkValue就再见了，前者!checkValue的实际值是false（非空值取反），后者"!" + checkValue的实际值是'!' + function的定义字符串（记得function toString会返回function定义字符串么）
对于filter是function的情况来说，vote第二高的回答: 加not function才是正解。

对于isGlobal这种值可能是true/ false /undefined的property，如果不想多定义一个filter function，可以写成：
```
<ul class="all-wrapper">
    <li  ng-repeat="item in availableRepository | filter: {isGlobal: '!true'}">
        {{item.name}}
    </li>
    <li class="single-item global-item">
        <span>外部人像库</span>
    </li>
    <li ng-repeat="item in availableRepository | filter: {isGlobal: true}:true">
        {{item.name}}
    </li>
</ul>
```
还是很别扭……你们可能会问filter后面的那个true是啥，其实是filter的第三个参数：comparator的定义，默认值是false，即会做字符串查找，如果设成true，就会调用angular.equal function来做匹配判断，也就是严格匹配，当然你也可以自己定义一个comparator function.

filter逻辑对应源代码 : https://github.com/angular/angular.js/blob/v1.2.29/src/ng/filter/filter.js


