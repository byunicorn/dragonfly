---
title: View On Vue
date: 2017-05-27 16:26:21
tags: [rbzhou,Vue]
---
听说Car要回来了，是不是该看看Vue啦？
=====================

一些你需要知道的事情
---------------
* Version
	 [1.0.0 Evangelion](https://github.com/vuejs/vue/releases/tag/1.0.0)
	 [v2.0.0 Ghost in the Shell](https://github.com/vuejs/vue/releases/tag/v2.0.0)
* Author
	[Evan You 尤雨溪](http://baike.baidu.com/link?url=lJZP3a9ddYcWLpqYIegVdCZrWDLWOTM1S-HC9i5DKIkRffb9XNn9DKNBDrSaNXz7DAbAuhgAqgFPNqR4SNm0Oclqik7EvH9zDD3W1twge_w_iVrBo3KttOomvjRyjuFR)
    [加盟阿里巴巴Weex团队](http://www.oschina.net/news/76781/vue-combine-with-weex)

Hello World First!
-------------------
<p data-height="183" data-theme-id="dark" data-slug-hash="zwbWbx" data-default-tab="result" data-user="zhourb21" data-embed-version="2" data-pen-title="zwbWbx" class="codepen">See the Pen <a href="https://codepen.io/zhourb21/pen/zwbWbx/">zwbWbx</a> by zhourb21 (<a href="https://codepen.io/zhourb21">@zhourb21</a>) on <a href="https://codepen.io">CodePen</a>.</p>
<script async src="https://production-assets.codepen.io/assets/embed/ei.js"></script>

Vue的语法
----------------
view的部分在2.0后支持template方式和jsx的方式。官方推荐使用template的方式，因为更符合一贯html写法，但引入virtual dom后，也可以通过jsx写渲染函数。
 
模板写法上，与angular有诸多相似的地方。

*	`v-on`
*	`v-if` / `v-else`
*	`v-show`
*	`v-bind:class`, 缩写成 `:class`
*  `v-on:click`, 缩写成 `@click`
*  可以在html上指定时间类型，不如`@click.stop`, `@keyup.enter`
*  vue的时间机制，`vm.$emit`, `vm.$on`
*  `v-model`, 双向绑定。实际为语法糖。
![](http://confluence.yitu-inc.com/download/attachments/107872563/image2017-4-1%2011%3A11%3A17.png?version=1&modificationDate=1491034369000&api=v2)

是不是和angular非常之像？
 是的。vue在语法上和angular非常相似。

<!-- more -->
 
Vue的特点
-----------------------
* Data binding
* Virtual Dom
* [Computed Properties](https://cn.vuejs.org/v2/guide/computed.html)
* Template/JSX
* 不支持IE8(因为使用了Object.defineProperty)
* 模块化(component, vue文件)

Vue也有全家桶
--------------------
* [vue-router](https://router.vuejs.org/en/)
  vue的路由。
* [vuex](https://vuex.vuejs.org/en/)
  状态机。
* [vue-resource](https://github.com/pagekit/vue-resource)
  http-client
* [vue-cli](https://github.com/vuejs/vue-cli)
   命令行工具，初始化工程，build。
* [vue-devtools](https://github.com/vuejs/vue-devtools)
  chrome插件，支持time travel，查看vue实例中的data，查看vuex中的数据。

 Vue的核心机制
--------------------

#### [深入响应式原理](https://vuejs.org/v2/guide/reactivity.html)
Vue的响应式是通过依赖追踪实现的。把一个 **普通 JavaScript 对象** 传给 Vue 实例的 data 选项，Vue 将遍历此对象所有的属性，并使用 Object.defineProperty 把这些属性全部转为 getter/setter。Object.defineProperty 是仅 ES5 支持，且无法 shim 的特性，这也就是为什么 Vue 不支持 IE8 以及更低版本浏览器的原因。

![](https://cn.vuejs.org/images/data.png)
 
 划重点：
	 **plain JavaScript object** 
	 **普通 JavaScript**  



一些踩过的坑
------------------- 
未必真的是坑，有些是写的过程中需要需要注意的地方。
1. 依赖追踪的必须是`plain JavaScript object`
2. component间的通信，最多只有父子组件可以直接通信，通信方式为prop传下来，通过v-on传上去。
3. 多层component想传来传去，不存在的。怎么办？`mixin` 一个 `Vue` 的实例作为component内的天线，或者上 `Vuex` 全局天线。总之就是天线啦。
4. vuex虽然没有update，但更新的时候，如果原来没有初始化过，或者更新的是object，需要调用Vue.set方法。
5. 类似`$scope.$apply`的异步执行或第三方，`Vue.nextTick(function () {})` 


Diff
-----------------
[官方文档 对比其他框架](https://cn.vuejs.org/v2/guide/comparison.html)



 




References
------------------
[Vue官网](https://github.com/vuejs/vue)
[Evan You](http://evanyou.me/)

	
f