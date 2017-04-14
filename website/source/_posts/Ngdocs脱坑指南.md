---
title: Ngdocs脱坑指南
date: 2017-04-13 11:46:54
tags: [hbwang,Angularjs,Ngdocs,gulp,browserSync]
---


在用ngdoc写可运行的example的过程中，无数的坑在等待着你。

----------


入门坑
-------------

Ngdocs官方文档三言两语，当我们真正去写注释的时候根本找不到参考，可支持的param参数有哪些种类都查不到，这里推介一个[jsdocs的标准文档](http://usejsdoc.org/)，最重要的推介是直接看[angularjs的源码](https://github.com/angular/angular.js/tree/master/src)，官方文档就是ngdocs生成的，里面的很多例子都很实用。

> **传送门:**

> - [gulp-ngdocs](https://www.browsersync.io/docs/gulp) => 配置
> - [jsdocs的标准文档](http://usejsdoc.org/) => 参考
> - [angularjs的源码](https://github.com/angular/angular.js/tree/master/src) => 例子


----------


中级坑
-------------------

 - 问题1：当开心的写完了一个directive的例子，却发现生产的文档网站里的demo根本没有被解析！原因是demo根本没有引入包含directives的js文件，**颖聪解决方案**：把项目中的js文件全部提取到`build.js`。
 - 问题2：引入的directive找不到html模板，css，images都404，**颖聪解决方案**：browserSync转发

> **传送门:**

> - [browserSync](https://www.browsersync.io/docs/gulp) => 配置

#### ngdocs最终配置 by 颖聪

    var gulp = require('gulp');
	var gulpDocs = require('gulp-ngdocs');
	var conf = require('./conf');
	var path = require('path');
	var browserSync = require('browser-sync');
	require('./script');
	
	gulp.task('ngdocs', ['concatJs'], function() {
		var src = conf.jsToBuild.src;
		src.push('!' + conf.paths.src + '/component/virtualRepeat/*.js');
		var options = {
			html5Mode: false,
			title: 'Face_platform API',
			scripts: ['frontend/built.js'],
			styles: ['frontend/stylesheets/app.css','task/serve/style_rewrite.css'],
			image:'frontend/images/logoNew.png'
		};
		return gulp.src(src)
			.pipe(gulpDocs.process(options))
			.pipe(gulp.dest(path.join(conf.paths.docs, '')))
	});
	
	gulp.task('ngdocs-reload',['ngdocs'], function() {
		browserSync.reload('*.html');
	});

但是引入`frontend/stylesheets/app.css`这个样式文件后，生成的文档网站的背景也变成了和文竹一样的蓝黑色，而且页面没有了滚动条。解决方案是再添加一个style文件在它后面去overwrite文档网站body的样式。

    body{
	    background: white;
	    overflow: auto;
	}

#### 路由转发 by 颖聪

	function browserSyncInit(options) {
	    options = _.assign(defaultOptions, options);
	    var server = {
	        baseDir: options.baseDir,
	        routes: options.routes
	    };
	    browserSync.init({
	        server: server,
	        port: options.port,
	        open: options.open
	    });
	}
	
	gulp.task('serve:docs', ['watchJsForDocs'], function() {
	    browserSyncInit({
	    	baseDir: [conf.paths.docs, conf.paths.src],
	        routes: {
	            "/css/frontend/images": "frontend/images",
	        },
	    	port: 3000,
	    	open: true
	    });
	});


----------


高级坑
-------------

尽管上面的环境都很稳了，但写demo的过程中还是有很多坑等着我们跳。

#### 坑1：引入错误module

    /**
	 * @ngdoc directive
	 * @name directives.directive:ytCheckBox
	 * @restrict EA
	 * @description
	 * The `ytCheckBox` directive is used for balaass
	 *
	 * Created by zmzhang2 on 12/6/16.
	 * @element ANY
	 * @scope
	 * @param {boolean=} checkValue The value of checkbox
	 * @param {number@} true true=1
	 * @param {numeber@} false false=0
	 * @param {boolean=?} isDisabled The value will toggle the disablity of checkbox
	 * @param {string&?} onChange AngularJS expression to be executed when input changes due to user interaction with the ytCheckBox.
	 * @example
	 <example module="directives">
	 <file name="index.html">
	 <div ng-controller="ytCheckBoxCtrl">
	 <yt-check-box check-value="checkValue" true="1" false="0"></yt-check-box>
	 </div>
	 </file>
	 <file name="app.js">
	 angular.module('directives')
	 .controller('ytCheckBoxCtrl', ['$scope', function($scope) {
	     $scope.checkValue = 1;
	 }]);
	 </file>
	 </example>
	 */

> **Note:** 一般的，写example的时候第一行中 `<example module="directives">` 中的module要引入一个包含directives这个module，但是当我们引入app这个总module的时候，demo会运行app这个module，发出很多http请求报404错误。

#### 坑2：缺少依赖注入

    /**
	 * @ngdoc directive
	 * @name directives.directive:ytDropdownList
	 * @restrict EA
	 * @description
	 * The `ytDropdownList` directive is used for
	 *
	 * Created by zmzhang2 on 12/2/16.
	 * @element ANY
	 * @scope
	 * @example
	 <example module="ytDropdownListExample">
	 <file name="index.html">
	 <div ng-controller="ytDropdownListCtrl">
	    <yt-dropdown-list on-click-option="quickSearch" placeholder="something" data-list-1="originSets" data-list-2="originUsers" ng-if="!settings.isUserLazyLoad"></yt-dropdown-list>
	    {{result}}
	 </div>
	 </file>
	 <file name="app.js">
	 angular.module('ytDropdownListExample',['filters','directives'])
	 .controller('ytDropdownListCtrl', ['$scope', function($scope) {
	     $scope.originSets = [
	         {"id":0,"name":"option 1"},
	         {"id":1,"name":"option 2"},
	         {"id":2,"name":"option 3"}
	     ];
	     $scope.originUsers = [
	         {"id":0,"name":"user 1"},
	         {"id":1,"name":"user 2"},
	         {"id":2,"name":"user 3"}
	     ];
	     $scope.quickSearch = function(option){
	         $scope.result = option.name;
	     };
	 }]);
	 </file>
	 <file name="style.css">
	 .yt-dropdown-list{
	    width: 80%;
	 }
	 </file>
	 </example>
	 */

> **Note:** 当写ytDropdownList这个directive的demo的时候，一开始我们使用directives这个module，报出了依赖错误，因为html模板中使用了filter，所以这种状况下必须新建一个module并且包含所有依赖的module（`'filters','directives'`），只有这样，demo才能正常运行。

#### 坑3：Provider


    /**
	 * @ngdoc directive
	 * @name directives.directive:ytSimpleMultiSelector
	 * @restrict EA
	 * @description
	 * The `ytSimpleMultiSelector` directive is used for balaass
	 * @element ANY
	 * @scope
	 * @param {array=} selections The available options
	 * @param {array@} selected the array which contains all the selected items
	 * @param {string@} selectorTitle the selector title which will be translated
	 * @param {string&?} onChange AngularJS expression to be executed when input changes due to user interaction with the ytSimpleMultiSelector.
	 * @example
	 <example module="ytSimpleMultiSelectorExample">
	 <file name="index.html">
	 <div ng-controller="ytSimpleMultiSelectorCtrl">
	    <yt-simple-multi-selector selections="selections" selected="selectedOption" selector-title="cmn.def.cluster"></yt-simple-multi-selector>
	 </div>
	 </file>
	 <file name="app.js">
	 angular.module('ytSimpleMultiSelectorExample',['pascalprecht.translate','filters','directives'])
	 .config(['$translateProvider',function($translateProvider){
	        $translateProvider
	            .useStaticFilesLoader({
	                prefix: './translations/',
	                suffix: '.json'
	            })
	            .useSanitizeValueStrategy('escape')
	            .preferredLanguage('en');
	 }])
	 .controller('ytSimpleMultiSelectorCtrl', ['$scope', function($scope) {
	      $scope.selections = [
	        "A","B","C"
	      ];
	      $scope.selectedOption = ["A","C"];
	 }]);
	 </file>
	 </example>
	 */

> **Note:** 有些directive的demo尽管已经满足了全部依赖，但是还是会报出Provider未配置的错误。比如ytSimpleMultiSelector这个directive的html模板包含translate，这样的话就必须config配置`$translateProvider`，否则会报错。

----------


#### 坑4：services/ui.bootstrap依赖

    /**
	 * @ngdoc directive
	 * @name directives.directive:ytRaceSelector
	 * @restrict EA
	 * @description
	 * The `ytRaceSelector` directive is used for balaass
	 *
	 * Created by ycma 03/28/17.
	 * @element ANY
	 * @scope
	 * @param {number=} selectedRace The selected race id
	 * @example
	 <example module="ytRaceSelectorExample">
	 <file name="index.html">
	 <div ng-controller="ytRaceSelectorCtrl">
	    <yt-race-selector selected-race="selectedRace"></yt-race-selector>
	 </div>
	 </file>
	 <file name="app.js">
	 angular.module('ytRaceSelectorExample',['directives', 'services', 'ui.bootstrap', 'filters'])
	 .controller('ytRaceSelectorCtrl', ['$scope', function($scope) {
	      $scope.selectedRace = 0;
	 }]);
	 </file>
	 </example>
	 */


> **Note:** 
> 
> - ytRaceSelector的demo报出一个$modal的错误，引入ui.bootstrap后解决；
> - 另外还会报出一个ytUrlMapProvider的错误，引入services后解决。



