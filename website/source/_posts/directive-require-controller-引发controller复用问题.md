---
title: directive require controller 引发controller复用问题
date: 2017-05-20 11:45:51
tags: [zmzhang,Angularjs,Javascript]
---

使用情景：
1、多个template 使用同一个controller：
( 1 )在需要使用某一个controller的地方使用ng-controller，例如在ng-include添加的template添加controller；例如：
```
<div class="metro-tile" ng-mouseover="hoverIn()" ng-mouseleave="hoverOut()">
   <div class="status-tile tile-default" ng-show="tileData.status == 0">
          <div class="tile-include" ng-include="template.html"></div>
   </div>
</div>
```
template.html:
```
<div class="row one-n-task" ng-controller="oneNTaskTileCtrl">
     ......
</div>
```
<!-- more -->

( 2 )业务逻辑相同但是template不同的directive共用一个controller，例如：
```
function myExample() {
    var directive = {
        restrict: 'EA',
        templateUrl: 'app/feature/example.directive.html',
        scope: {
            max: '='
        },
        link: linkFunc,
        controller : ExampleController,
        controllerAs: 'vm',
        bindToController: true // because the scope is isolated
    };

    return directive;
    function linkFunc(scope.elem, attr, ctrl){
        console.log("This is link funciton")
    }
}
function example1() {
    var directive = {
        restrict: 'A',
        controller : ExampleController,
        controllerAs: 'vm',
        bindToController: true // because the scope is isolated
    };
    return directive;
}
```
2、上下级controller:     
子级的controller会默认集成父作用域，无论是基本类型和引用类型都会继承例如：
```
<body ng-controller="parentController">
    <h1>基本类型:{{value}}</h1>
    <h1>引用类型:{{obj.value}}</h1>
    <input type="button" ng-click="parentChange('parent')" value="parent"/>
    <div ng-controller="childController">
        <h1>基本类型:{{value}}</h1>
        <h1>引用类型:{{obj.value}}</h1>
        <input type="button" ng-click="childChange('child')" value="child"/>
    </div>
</body>
```
3、controller的继承
假设有两个页面，它们的大部分功能都相同，其中完全相同的功能超过50%。两个页面的视图完全不同但是可能视图后面的逻辑非常相似。在这种情形中你可以创建一个基本的控制器来封装基本的逻辑，然后再创建两个自控制器来继承它。
可以使用AngularJS内置的 $controller service, 通过依赖注入的方式实现继承； 也可以不依赖$scope的情况下也可以使用javascript原生继承方式 
创建一个base.controller.js文件
```
(function() {
    'use strict';
    angular.module('DemoApp').controller('BaseCtrl', BaseCtrl);
    //手动注入一些服务
    BaseCtrl.$inject = ['$scope','CRUDServices'];
    /* @ngInject */
    function BaseCtrl($scope,CRUDServices) {
        var _this = this;
        _this.doSomething = doSomething;
        activate();
        //初始化
        function activate() {
             _this.bList =  CRUDServices.getList();
        }
        function doSomething(){
            //do some thing
            return false;
        }
    }
})();
```
创建一个child.controller.js文件
```
(function() {
    'use strict';
    angular.module('DemoApp').controller('ChildCtrl', ChildCtrl);
    //其中的ExtendServices 用来提供数据的 Servie
    ChildCtrl.$inject = ['$scope', '$controller','ExtendServices'];
    /* @ngInject */
    function ChildCtrl($scope, $controller,ExtendServices) {
        var vm = this;
        //调用base controller 传递locals参数进去
        var parentCtrl = $controller('BaseCtrl', { $scope：$scope,CRUDServices:ExtendServices })
        //通过 angular.extend 把父控制器上的 方法和属性 绑定到 子的对象上
        angular.extend(vm, parentCtrl);
        //初始化
        activate();
        function activate() {
            //调用base controller 的 doSomething 方法
            vm.doSomething();
        }
    }
})();
```
可以直接在child的html文件中直接调用
```
<div>
    <!--  直接绑定 vm.bList 就会看到输出结果-->
    <div ng-repeat="item in vm.bList">{{item}}</div>
</div>
```
 
4、directive中的controller的引用
当多个directive 有类似的逻辑，可以require其他directive的controller： require 同级，require父级； 
[坑] require同级必须两个指令在同一个html标签上
```
var zmForm = angular.module('zmFormReq',[]);
zmForm.directive('zmForm', function () {
    return{
        restrict: 'EA',
        replace: true,
        controller: function ($scope) {
            var _this = this;
            _this.isAvailable = [];
            _this.addAvailable = function (req) {
                _this.isAvailable.push(req)
            };
            _this.submit = function () {
                for (var i=0; i < _this.isAvailable.length; i++){
                    var req = _this.isAvailable[i];
                    if (!req.isValid){
                        if (req.message){
                            alert(req.message);
                        }else {
                            $(req.element).addClass('zm-form-alert');
                            $(req.element).focus();
                        }
                        return false;
                    }
                }
            }
            function createAlertClass() {
                var style = $('<style>' +
                    '.zm-form-alert{border: 1px solid red !important;}' +
                    '.zm-form-alert:focus{outline: red auto 5px;}' +
                    '</style>');
                $('html > head').append(style);
            }
            createAlertClass();
        },
    }
});
zmForm.directive('zmSubmit', function () {
    return{
        restrict: 'EA',
        replace: true,
        require: '^zmForm',
        scope:{
            zmClick:"&"
        },
        link: function (scope, element, attr, zmFormCtrl) {
            var zmClick;
            if (angular.isUndefined(scope.zmClick)){
                zmClick = scope.zmClick();
            }else {
                zmClick = function () {};
            }
            $(element).bind('click', function () {
                if (zmFormCtrl.submit()){
                    zmClick();
                }
            })
        }
    }
});
zmForm.directive('zmRequired', function ($interval) {
    return{
        restrict: 'EA',
        // replace: true,
        scope:{
            zmType:"@?", zmAlert:"@?", zmPattern:"=?"
        },
        require: ['^zmForm','ngModel'],
        // require: ['?zmSubmit', '?ngModel'],
        link: function (scope, element, attrs, Ctrls) {
            var zmFormCtrl = Ctrls[0];
            var ngModelCtrl = Ctrls[1];
            var reg = /n*/;
            scope.req = {isValid: false, message: scope.zmAlert, element: element};
            if (scope.zmType){
                switch (scope.zmType){
                    case 'int':
                        reg = /^-?[1-9]\d*$/; //匹配整数
                        break;
                    case 'email':
                        reg =  /^(\w)+(\.\w+)*@(\w)+((\.\w+)+)$/;
                        break;
                }
            }else if(scope.zmPattern) {
                reg = scope.zmPattern;
            }
            zmFormCtrl.addAvailable(scope.req);
            var test = function (value) {
                $(element).removeClass("zm-form-alert");
                if (ngModelCtrl.$isEmpty(value)){
                    scope.req.isValid = false;
                }else if(reg.test(value)){
                    scope.req.isValid = true;
                }else {
                    scope.req.isValid = false;
                }
                return value;
            };
            ngModelCtrl.$parsers.unshift(test);
            ngModelCtrl.$formatters.unshift(test)
        }
    }
});
```

