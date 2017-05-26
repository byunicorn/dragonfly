---
title: underscore.js学习
date: 2017-05-25 10:45:13
tags: [Javascript,axxia]
---
underscore是一个操作数据对象的好帮手，常用的方法分为以下几类：

##### 凹造型：each,reduce,map,pluck(ES6方法forEach,map,reduce)
##### 数据查找：find,filter,reject,findWhere,where(ES6方法find,filter)
##### 排序和分组：sortBy,groupBy,indexBy,countBy
##### 判断：every,some,contain(ES6方法every,some,includes)

目前ES6已经能够支持多数方法，但对浏览器有一定要求，一般要求如下：
![](https://github.com/wflkaaa/dragonfly/blob/master/code/images/underscore-img1.png?raw=true)

个别方法如find对浏览器的版本要求比较高：
![](https://github.com/wflkaaa/dragonfly/blob/master/code/images/underscore-img2.png?raw=true)

<!-- more -->

##### 凹造型示例：
```
var srcList = [
    {"name": "aaa", "id": 0},
    {"name": "bbb", "id": 1},
    {"name": "ccc", "id": 2}
];//期望输出一个destList["aaa", "bbb", "ccc"]
var destList = _.reduce(srcList,function (list,item) {
    list.push(item.name);
    return list;
},[]);
//reduce可以用于凹出更复杂的造型
var destList = _.map(srcList,function (item) {
    return item.name;
});
//map就是映射关系
var destList = _.pluck(srcList,"name");
//pluck是其实是map的一种特殊情况，只限于按某个key取数组
```

关于_.map(list, iteratee, [context])，补充如下：
其中iteratee可以是函数、对象、字符串等，underscore将不同类型的iteratee统一处理成一个函数cb，并由cb对参数的类型做判断，返回不同的处理方式。
总的来说，如果没有传入iteratee，会返回list本身；
如果iteratee是一个function，会返回新的optimizeCb，并根据参数个数做进一步处理。
如果iteratee是一个对象，返回list是否匹配这个对象（返回true/false）
如果iteratee是一个字符串，该字符串会指向list中对应的属性值
详情可以看underscore源码，或者[戳这里](https://yoyoyohamapi.gitbooks.io/undersercore-analysis/content/base/%E8%BF%AD%E4%BB%A3%EF%BC%81%E8%BF%AD%E4%BB%A3%EF%BC%81%E8%BF%AD%E4%BB%A3%EF%BC%81.html)

##### 数据查找
find和findWhere返回匹配的第一个值
filter,reject,where返回匹配的所有值，filter和reject结果正好相反
findWhere和where可以传入properties作为参数并找到匹配的key-value pair

##### 判断
every,some,contain都返回true/false，判断list元素是否满足某个条件

上述方法对Array和Object均适用，下面是Array或Object独有的：

#### Array独有的方法
flattern 扁平化数组，名字很形象
zip 示例说明一切
_.zip(['moe', 'larry', 'curly'], [30, 40, 50], [true, false, false]);
=> [["moe", 30, true], ["larry", 40, false], ["curly", 50, false]]
unzip
object
_.object(['moe', 'larry', 'curly'], [30, 40, 50]);
=> {moe: 30, larry: 40, curly: 50}

_.object([['moe', 30], ['larry', 40], ['curly', 50]]);
=> {moe: 30, larry: 40, curly: 50}
uniq 删除数组中的重复元素

#### Object独有
values
_.values({one: 1, two: 2, three: 3});
=> [1, 2, 3]

extend,extendOwn
pick跟filter类似，但允许传一个参数指定返回的键名
defaults如果传入的参数中存在原对象undefined的属性，则加上该属性
另有一些针对对象的判断isEmpty isEqual isMatch isArray isObject isString isNumber isUndefined

chain
_.chain( uri.split('&') )
    .map(function(item) { if (item) { return item.split('='); }})
    .compact()
    .object()
    .value();