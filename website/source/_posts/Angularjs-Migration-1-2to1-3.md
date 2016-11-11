---
title: Angular.js 版本升级指南 1.2到1.3
date: 2016-11-01 11:31:35
tags: [lbao,Angularjs]
---

Reference: [AngularJS: Developer Guide: Migrating from Previous Versions](https://docs.angularjs.org/guide/migration)

`1.2`到`1.3`版本升级指南：

- `Controller` 禁止使用Global Controller
1.2的版本允许你直接裸写一个controller，angular会自己到window下寻找带controller的变量来注册。

    以前：
    ```JavaScript
    function MyController() {
      // 如果这个变量定义在window context下
      // 那么angular会主动找到它并且注册到自己的controller cache中
    }
    ```

    现在：
    ```JavaScript
    angular.module('myApp', []).controller('MyController', [function() {
      // ...
    }]);
	```

- Angular Expression Parsing ($parse + $interpolate) 

	1. angular expression里面不再支持`.apply`， `.call`, `.bind`等允许你改变执行上下文的操作。
	原本angular expression是在当前scope context下被parse的，如果你改变了执行的context，angular无法保证会发生什么，所以这种用法在1.3中被全面禁止了。[77ada4c](https://github.com/angular/angular.js/commit/77ada4c82d6b8fc6d977c26f3cdb48c2f5fbe5a5)

    ```html
    <div>{{user.sendInfo.call({}, true)}}</div>
    ```

	2. expression中禁用`__proto__`
	`__proto__`这个用法本身已经deprecated，并不是所有浏览器都把它当作一个标准了，所以angular也抛弃了它。[6081f20](https://github.com/angular/angular.js/commit/6081f20769e64a800ee8075c168412b21f026d99)
    不了解`__proto__`的可以试着在Chrome console中运行下面的代码：定义一个构造函数，然后创建一个实例，这个实例里面就有`__proto__`这个属性，而它指向的是构造函数的prototype部分。

    ```JavaScript
    function Bula() {};
    Bula.prototype.aaa = function() {};
    var bula = new Bula();
    console.log(bula.__proto__);
    ```
    
    3. expression中禁用`{define,lookup}{Getter,Setter}`
    `__defineGetter__`,`__defineSetter__`, `__lookupGetter__`, `__lookupSetter__`全部禁用。[48fa3aa](https://github.com/angular/angular.js/commit/48fa3aadd546036c7e69f71046f659ab1de244c6)
    
    4. expression中禁用`Object`
    所以你不能在expression里面用`Object.keys`, `Object.create`等`Object`上带的方法了。[528be29](https://github.com/angular/angular.js/commit/528be29d1662122a34e204dd607e1c0bd9c16bbc) 
    p.s.这条和上一条的原因都非常的tricky，建议闲得蛋疼的同学戳进链接里去看一眼。
    
    5. `'f', '0', 'false', 'no', 'n', '[]'`不会再被当作falsy的值了，只有JavaScript里面原生的falsy值才会被当作false。
    在1.2里，上述这些string值会被当作false来处理，即，后面这段代码里的div不会显示出来`<div ng-show='"false"'>bula</div>`
    
    6. `$parseProvider` 的两个option`unwrapPromises`, `logPromiseWarnings`禁用。[fa6e411](https://github.com/angular/angular.js/commit/fa6e411da26824a5bae55f37ce7dbb859653276d) （说实话，我也不知道这两个option是干啥的，还没用过就被禁了……

	7. `$interpolate`parse的结果以前会放在`.parts`里，现在会放到两个数组里`.expressions`，`.separators` [88c2193](https://github.com/angular/angular.js/commit/88c2193c71954b9e7e7e4bdf636a2b168d36300d)
        以前：
        ```JavaScript
        var parts = $interpolate("a{{b}}C").parts;
        expect(parts.length).toEqual(3);
        expect(parts[0]).toEqual("a");
        expect(parts[1].exp).toEqual("b");
        expect(parts[1]({b:123})).toEqual(123);
        expect(parts[2]).toEqual("C");
        ```
        
        现在：
        ```JavaScript
        var interpolateFn = $interpolate("a{{b}}C"),
        	separators = interpolateFn.separators, expressions = interpolateFn.expressions;
        expect(separators).toEqual(['a', 'C']);
        expect(expressions.length).toEqual(1);
        expect(expressions[0].exp).toEqual('b');
        expect(expressions[0]({b:123})).toEqual('123');
        ```
- Miscellaneous Angular helpers

	1. `Angular.copy` 以前会把原型链上的属性直接拷贝到目标object上，现在会保留原型链。[b59b04f](https://github.com/angular/angular.js/commit/b59b04f98a0b59eead53f6a53391ce1bbcbe9b57)
	
    以前：
    ```JavaScript
    var Foo = function() {};
    var foo = new Foo();
    var fooCopy = angular.copy(foo);
    foo instanceof Foo; // => true
    fooCopy instanceof Foo; // => false
    ```
    
    现在：
    ```JavaScript
    foo instanceof Foo; // => true
    fooCopy instanceof Foo; // => true
    ```
    
    p.s. 因为现在的实现要用到`Object.creaet`和`Object.getPrototypeOf`，而这两个方法和IE8不兼容，所以从1.3之后，Angular.js不支持IE8了。
    
    2. `Angular.forEach`现在会cache array的长度，循环过程中动态往array里面加item，依然会按照调用时的array长度来循环。[55991e3](https://github.com/angular/angular.js/commit/55991e33af6fece07ea347a059da061b76fc95f5)

	3. `Angular.toJSON`不会自动过滤掉`$`开头的属性了，`$$`开头的还是会被过滤掉。[c054288](https://github.com/angular/angular.js/commit/c054288c9722875e3595e6e6162193e0fb67a251)

    ```JavaScript
    expect(toJson({$few: 'v', $$bula: '321'}, false)).toEqual('{"$few":"v"}');
    ```
    
- jqLite / JQuery

	1. jqLite，禁止往Text/Comment节点上append data。[a196c8b](https://github.com/angular/angular.js/commit/a196c8bca82a28c08896d31f1863cf4ecd11401c#diff-8e0d9e5c18fe4f1050484080525d4367)
	
	2. jqLite，调用jQuery的`detach`方法，不会触发`$destroy`事件，如果你想要在删除元素时destroy Angular相关的data，请使用`remove`[d71dbb1](https://github.com/angular/angular.js/commit/d71dbb1ae50f174680533492ce4c7db3ff74df00)
	
    Angular是允许我们使用外部的jQuery的（不是它自己内置的jqLite），以前Angular在检测到外部jQuery时，会往jQuery里删除元素的方法（如remove/empty/html等）上monkey-patch一些逻辑，使得你在调用这些方法时，能够触发Angular内部的事件，但这样做需要依赖于jQuery的实现，如果将来jQuery又添加了一个叫removeChildren的方法，就需要另加一段monkey-patch，所以这个方案并不是future-safe的，现在的解决方案是不monkey-patch单个的方法，而是直接改动jQuery的一个内部方法`jQuery.cleanData`，`cleanData`在jQuery中删除元素的方法有被调用到（detach方法除外），是比较future-safe的。
    
- Angular HTML Compile ($compile)

	1. isolate scope的作用域改变。以前direcitve的isolate scope在创建这个directive的元素上可用，现在只能在directive内部使用了。
	举个简单的例子： `<my-directive isolate-scope-prop="myController.prop" ng-if="isolateScopeProp"></my-directive>`在1.2版本是work的，在1.3就不work了（具体的例子可以看这里：[Plunker](http://plnkr.co/edit/giVsWj1HDjlVN8lEJaHR?p=preview)）[2ee29c5](https://github.com/angular/angular.js/commit/2ee29c5da81ffacdc1cabb438f5d125d5e116cb9)
    
	2. 在一个元素上请求创建一个isolate scope和任何其他的scope会报异常。之前如果两个申请scope的directive执行顺序是先isolate后非isolate，则不会报错，升级到1.3之后，无论执行顺序如何，都会报`multidir`的错。[2cde927](https://github.com/angular/angular.js/commit/2cde927e58c8d1588569d94a797e43cdfbcedaf9)

	3. directive定义里的`replace`flag将在下一个大版本中被删除，这个flag语义有些不明确（比如，element上的attributes会被如何merge）[eec6394](https://github.com/angular/angular.js/commit/eec6394a342fb92fba5270eee11c83f1d895e9fb)  
	p.s.这条争议比较大，闲得蛋疼的同学可以去看看链接里的讨论串。

	4. `attr.$observe`不会再返回observer function，而是会返回一个deregistration function。[299b220](https://github.com/angular/angular.js/commit/299b220f5e05e1d4e26bfd58d0b2fd7329ca76b1)
	
    以前
    
    ```JavaScript
    $observe: function(key, fn) {
    	// do stuff
        return fn; //会返回observer function本身
    }
    ```
    
    现在
    
    ```JavaScript
    $observe: function(key, fn) {
    	// do stuff
        return function() {
          arrayRemove(listeners, fn);
        }; //会返回一个deregistion的function，调用它会将fn从listeners list里面清除
    }
    ```
    
    p.s. 感觉angular很喜欢这种写法，`$emit`和`$boardcast`返回也是deregistion的实现。
    
    5. `$observe`不会再去observe未定义的属性。下面这种写法不会再work。[531a8de](https://github.com/angular/angular.js/commit/531a8de72c439d8ddd064874bf364c00cedabb11)

	以前
    
	```html
    <my-dir></my-dir>
    ```
    
    ```JavaScript
    // Link function for directive myDir
    link: function(scope, element, attr) {
        attr.$observe('myAttr', function(newVal) {
            scope.myValue = newVal ? newVal : 'myDefaultValue';
        });
    }
    ```
    
    现在，需要在注册之前，check是否是undefined
    
    ```JavaScript
    link: function(scope, element, attr) {
        if (attr.myAttr) {
            // register the observer
        } else {
            // set the default
        }
    }
    ```

- Forms, Inputs and ngModel
    1. 如果一个expression用在`ng-pattern`（例如，`ng-pattern="exp"`）或者在`pattern`属性上（例如，`pattern="{{exp}}"`），且这个expression解析出来是个string，那么ngModel上的validator将不会尝试着去把这个string转换成正则表达式。[1be9bb9](https://github.com/angular/angular.js/commit/1be9bb9d3527e0758350c4f7417a4228d8571440#diff-c244afd8def7f268b16ee91a0341c4b2R2178)
    
    以前
    
    ```JavaScript
    $scope.exp = '/abc/i'; // 会尝试把string转换成正则表达式
    ```
    
    现在
    
    ```JavaScript
    $scope.exp = /abc/i; // 必须显式地写成正则表达式
    ```
    
    2. 更改了`NgModalController`上的API [adfc322](https://github.com/angular/angular.js/commit/adfc322b04a58158fb9697e5b99aab9ca63c80bb)
    
    `NgModalController`顾名思义，就是`ngModal`这个directive的controller。
    
    `$setViewValue(value)` - 这个方法依然会改变`$viewValue`，但不会直接将改变apply到`$modalValue`上，直到`updateOn`trigger触发，才会做`$modalValue`的update。
    
    `$cancelUpdate()` - 这个方法更名为`$rollbackViewValue()`，这个方法会把`$viewValue`回滚到`$lastCommittedViewValue`的值，从而取消掉还在pending的debounced update，并重新render input。
    
    3. 对于type为`date`,`time`,`datetime-local`,`month`,`week`的input，ngModal会要求一个`Date`类型作为model. [46bd6dc](https://github.com/angular/angular.js/commit/46bd6dc88de252886d75426efc2ce8107a5134e9)

	4. `input[checkbox]` 现在支持在`ngTrueValue`，`ngFalseValue`上使用常量的expression，包括boolean和int值。之前这两个directive的值会被直接当作string来处理，现在它们将被当作expression来parse，如果这个expression不是常量则会被丢掉。现在想要绑一个string的expression则要像下面的例子一样写： [c90cefe](https://github.com/angular/angular.js/commit/c90cefe16142d973a123e945fc9058e8a874c357)
    
    ```html
    <input type="checkbox" ng-model="..." ng-true-value="'truthyValue'">
    ```
    
- Scopes and Digests ($scope) 

	1. Scope.$id现在是number而不是string了。（有性能concern） [8c6a817](https://github.com/angular/angular.js/commit/8c6a8171f9bdaa5cdabc0cc3f7d3ce10af7b434d)
	
	2. 一旦事件传播结束，`$boardcase`和`$emit`会将event参数的`currentScope`属性设为null。[82f45ae](https://github.com/angular/angular.js/commit/82f45aee5bd84d1cc53fb2e8f645d2263cdaacbc)

- Server Requests ($http, $resource) 

	1. `$http` response拦截器更新 [ad4336f](https://github.com/angular/angular.js/commit/ad4336f9359a073e272930f8f9bcd36587a8648f)
	
    以前
    ```JavaScript
    // register the interceptor as a service
    $provide.factory('myHttpInterceptor', function($q, dependency1, dependency2) {
      return function(promise) {
        return promise.then(function(response) {
          // do something on success
          return response;
        }, function(response) {
          // do something on error
          if (canRecover(response)) {
            return responseOrNewPromise
          }
          return $q.reject(response);
        });
      }
    });

    $httpProvider.responseInterceptors.push('myHttpInterceptor');
    ```
    
    现在
    
    ```JavaScript
    $provide.factory('myHttpInterceptor', function($q) {
      return {
        response: function(response) {
          // do something on success
          return response;
        },
        responseError: function(response) {
          // do something on error
          if (canRecover(response)) {
            return responseOrNewPromise
          }
          return $q.reject(response);
        }
      };
    });

    $httpProvider.interceptors.push('myHttpInterceptor');
    ```
    
	2. `$httpBackend` 在没有参数的情况下调用JSONP回调时不会报错。[6680b7b](https://github.com/angular/angular.js/commit/6680b7b97c0326a80bdccaf0a35031e4af641e0e)
  
	3. `$resource`现在不会自动帮你把`$`开头的变量去掉了，需要自己手动完成。[d3c50c8](https://github.com/angular/angular.js/commit/d3c50c845671f0f8bcc3f7842df9e2fb1d1b1c40)

- Modules and Injector ($inject)

	以前config block可以用来控制provider的注册流程，因为config block是在provider注册之前被调用的。而现在provider的注册会发生在config block运行之前，所以config不再能够控制provider的注册。[c0b4e2d](https://github.com/angular/angular.js/commit/c0b4e2db9cbc8bc3164cedc4646145d3ab72536e)
    
    以前下面这段代码是可以work的，现在不行了：
    
    ```JavaScript
    angular.module('foo', [])
    .provider('$rootProvider', function() {
      this.$get = function() { ... }
    })
    .config(function($rootProvider) {
      $rootProvider.dependentMode = "B";
    })
    .provider('$dependentProvider', function($rootProvider) {
       if ($rootProvider.dependentMode === "A") {
         this.$get = function() {
          // Special mode!
         }
       } else {
         this.$get = function() {
           // something else
         }
      }
    });
    ```
    
- Filters (orderBy)

	`orderBy`现在会把null值当作string的`'null'`来处理。[a097aa9](https://github.com/angular/angular.js/commit/a097aa95b7c78beab6d1b7d521c25f7d9d7843d9)
    
- Animation (ngAnimate)

	1. 在1.2.x里，`$animate.move(element, parentElement, afterElement, [doneCallback]);`和`$animate.enter(element, parent, after, [doneCallback])`默认都会把插入的元素放到container的最前面

// 未完待续