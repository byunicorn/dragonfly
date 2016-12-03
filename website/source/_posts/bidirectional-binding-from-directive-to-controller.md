---
title: bidirectional-binding from directive to controller
date: 2016-11-14 13:11:24
tags: [angular,rbzhou]
---

`angular`中的双向绑定

这个题取大了。其实是关于`ng-if`。

Reference: [ng-if VS ng-show](http://stackoverflow.com/questions/21869283/when-to-favor-ng-if-vs-ng-show-ng-hide??)

上周选择市县的`directive`没有任何问题，我很放心的判断说这个修改work了。然后自作聪明的加上了一句
```
  <city-selector-primary ng-if="lang === 'cn'" province-level="3" person-id-prefix="personIdPrefix"></city-selector-primary>
```

快夸我，我都考虑到了英文下不需要这个控件了。啊，等等，出锅啦!? __WTF__！！！

问题描述:
从directive的attr中传入双向绑定的对象`$scope.personIdPrefix`，但是directive内部修改变量时外部变量却没有跟着一起变。

问题原因:
`ng-if`会创建一个子域。表现的形式为，directive中绑定的元素是`ng-if`的scope中的元素，而不是controller中的元素。

解决方法:
`ng-show`就不会。

所以，`ng-show`不创子域，不删除`dom`元素。良民。`ng-if`创建子域，删除`dom`元素，性能好一点，因为没有多余的`dom`操作。算是个小流氓吧。


