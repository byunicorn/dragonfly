---
title: 在promise中修改原始结果
date: 2016-12-03 13:26:06
tags: [kailiu,Promise]
---

有时需要在promise的then中处理数据，再返回这个promise，这样别人在调用这个promise的时候就不用处理数据。
```JavaScript
    var promise = DataService.queryRemote('GET', url, null, isCache);
    promise.then(function (data, status, headers, config) {
        if(data.rtn === 0){
            return _.filter(data.cameras,function(object){
                return object.type === 0;
            });
        }
    });
    return promise;
```
但这段code返回的promise，在controller里调用then并未返回的仍然时未经过滤的数据，说明then里的code没生效。

**原因：查api发现，`promise.then`会返回一个新的promise，这里return的是旧的**

所以写法应该是：
```JavaScript
var promise = DataService.queryRemote('GET', url, null, isCache);
return promise.then(function (data, status, headers, config) {
	if(data.rtn === 0){
		return _.filter(data.cameras,function(object){
			return object.type === 0;
		});
	}
}); 
```