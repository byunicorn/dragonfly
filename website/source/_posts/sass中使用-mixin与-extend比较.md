---
title: sass中使用@mixin与@extend比较
date: 2016-11-17 14:33:08
tags: [sass, zmzhang, extend, mixin]
---

在sass中使用@mixin和@extend都可以使代码模块化，方便使用一些片段使代码更加简洁，但是什么时候使用@mixin，什么时候使用@extend呢。

<!-- more -->

简单的看一下两者编译代码的区别：

```
.button { 
    background: green; 
}
.button-1 { 
    @extend .button;
}
.button-2 {
    @extend .button;
}

```

编译结果：

```
.button, 
.button-1, 
.button-2 {
    background: green;
}

```

使用@mixin编译的样子：

```
@mixin button {
    background-color: green;
}
.button-1 {
    @include button;
} 
.button-2 {
    @include button;
}

```

编译结果：
 
```
.button {
    background-color: green;
}
.button-1 {
    background-color: green;
} 
.button-2 {
    background-color: green;
}

```

可以看到，@extend的结果貌似比较简洁。
比较结果

* 相比@mixin，@extend编译的代码更符合css dry 风格，代码更加简介
* @mixin更加灵活，可以传递参数、设置默认参数，定义变量，而@extend 不可以
* @extend 在@media中使用有限制，比如：不能横跨多个@media使用@extend
* @extend增加了选择器之间的联系，如果不是为同类型的相关元素设置样式应该使用@mixin
* @mixin 结合gzip压缩也不会产生肿胀的代码，如果@extend结合gzip会破坏代码中的dry
* 

