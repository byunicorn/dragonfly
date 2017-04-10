---
title: angularjs filter准确过滤
date: 2017-04-10 11:52:03
tags: [hbwang,Angularjs,filter]
---

AngularJS中用filter过滤某个id，比如

    $scope.users = [
	    {"id":1,"username":"simon",},
	    {"id":8,"username":"betty",},
	    {"id":14,"username":"archie",},
	    {"id":3,"username":"jumbo1"}
	]
  
  要把id为1的simon这个user过滤出来，如果写成

    $scope.users =  $filter('filter')($scope.users,{id:1}）；

得到的结果是

    $scope.users = [
	    {"id":1,"username":"simon",},
	    {"id":14,"username":"archAngularJS中用filter过滤某个id，比如

    $scope.users = [
	    {"id":1,"username":"simon",},
	    {"id":8,"username":"betty",},
	    {"id":14,"username":"archie",},
	    {"id":3,"username":"jumbo1"}
	]
  
  要把id为1的simon这个user过滤出来，如果写成
ie",}
	]

所有id是1开头的user都出现在过滤结果中！因此，`$filter('filter')($scope.users,{id:1}）；`
并不是精确的把id为1的simon这个user过滤出来！

解决办法：[Angular filter exactly on object key](http://stackoverflow.com/questions/20292638/angular-filter-exactly-on-object-key)

参考上述办法，精确过滤出来id为1的simon的做法是

	$scope.users =  $filter('filter')($scope.users,{id:1}，true）；

然后，如果要精确的排除某个user就没有这么简单了，先看

	$scope.users =  $filter('filter')($scope.users,{id:'!1'}）；

这段代码的结果就是把所以id是1开头的user都排除出去，因此得到的结果是

    $scope.users = [
	    {"id":8,"username":"betty",},
	    {"id":3,"username":"jumbo1"}
	]

而目标是只想排除掉id为1的simon，尝试：

	$scope.users =  $filter('filter')($scope.users,{id:'!1'},true）；

得到的结果是

    $scope.users = [
	    {"id":1,"username":"simon",},
	    {"id":8,"username":"betty",},
	    {"id":14,"username":"archie",},
	    {"id":3,"username":"jumbo1"}
	]

也就是说上面的过滤没有排除掉任何user！经过尝试，目前只能自定义一个过滤函数来得到目标结果，如下：

	$scope.users =  $filter('filter')($scope.users,function(user){
		return user.id != 1;
	}）；

如果大家发现了更好的方法，一定要回复！
