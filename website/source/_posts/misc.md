---
title: misc
date: 2017-01-11 21:07:11
tags: [rbzhou]
---

#福建网站反应迟缓复盘
福建的版本一直都非常危险,各种adhoc，并且问题频出。这里面有历史的形成，也有网站设计上的问题。现在准备复盘并整理一下。

##背景

版本是1.6.4, 从1.5.x的版本升级上来。1.6.4也不是正式发布的版本，并且中途加了一些升级的adhoc修改。后台的服务器规模不在我们的scope内，但需要考虑网站会与一些其他的应用共用一个后台。

##现象

- 访问网站时，显示不出内容。
- 偶尔可以出现页面，加载时间都在20s以上，且经常不能正常跳转。
- 白天非常卡顿，不能使用，晚上很流畅。

## 原因定位

整个网站的流程访问流程如下:
```
chrome -> nginx -> java后台(即tomcat) -> 大平台
```
排查过程从浏览器端开始。

方法上，本地模拟现场环境,加上现场实际测试，打log看请求时间的方式。nginx，java端请求返回的时间全部打出来。相关的配置有：
```
nginx：
    log_format timed_combined '$remote_addr - $remote_user [$time_local] '
    '"$request" $status $body_bytes_sent '
    '"$http_referer" "$http_user_agent" '
    '$request_time $upstream_response_time $pipe';
tomcat: 
     更改module/website/origin/conf/server.xml的log pattern，添加一个时间的log字段
      <Host name="localhost"  appBase="webapps"
            unpackWARs="true" autoDeploy="true">
        <Valve className="org.apache.catalina.valves.AccessLogValve" directory="logs"
               prefix="localhost_access_log." suffix=".txt"
               pattern="%h %l %u %t &quot;%r&quot; %s %b %D" />
      </Host>
    更改之后重启tomcat，
        在 face_platform目录下执行：
            ./action/module.sh website stop; ./action/module.sh website start;

    localhost_access_log* 文件里的log应该长下面这样：
    127.0.0.1 - - [06/Jan/2017:19:19:34 +0800] "GET /face/v1/framework/upload?user=clientAdmin&repository_id=1 HTTP/1.0" 200 68 382
    返回的状态码（200）后面有两段，其中382就是process time
    捞log文件的path: module/website/origin/logs/localhost_access_log_bulabula.txt
```

模拟的方法为:
使用[gatling](http://gatling.io/)，
`gatling`自带一个[recorder](http://gatling.io/docs/2.0.0-RC2/http/recorder.html)来录制网站请求的脚本。同时起线程作为访问的压力。虽然不是第一次进行压测，但是现场环境不清楚，实际访问量不明确，所以这样模拟的环境只有压力，并不准确。有可能这种压力下找到的问题在现场并不一定一样。**发布前缺少压测，排查问题时模拟环境又非常粗糙，这是错误一**。


具体排查过程如下:

F12看`Network`标签页，发现大量请求处于pending状态，静态资源(js文件/png文件)也是pending状态。但一开始并没有检查pending的具体原因，而是惯性思维的认为是后台的global接口返回时间长，在等待其返回。后台通过接口调用，2s返回，**说明瓶颈不在后台**。

于是进一步确定pending的时间在到底在等什么。点开左侧一个长时间等待的请求，看其`Timing`标签。

chrome网络panel的功能与使用可以参考以下链接:
- [Understanding Chrome network log “Stalled” state](http://stackoverflow.com/questions/29206067/understanding-chrome-network-log-stalled-state)
- [Measure Resource Loading Times](https://developers.google.com/web/tools/chrome-devtools/network-performance/resource-loading?utm_source=dcc&utm_medium=redirect&utm_campaign=2016q3)

观察到的现象为:
- 60s后的请求被cancel。
- 大部分请求显示为pending。
- 大部分请求都是`stalled`状态。

```
Stalled/Blocking

Time the request spent waiting before it could be sent. This time is inclusive of any time spent in proxy negotiation. Additionally, this time will include when the browser is waiting for an already established connection to become available for re-use, obeying Chrome's maximum six TCP connection per origin rule.
```

简单来说，`stalled`指请求卡在了浏览器端。即，请求没有发到大平台。

浏览器有http连接数上限，[Max parallel http connections in a browser](http://stackoverflow.com/questions/985431/max-parallel-http-connections-in-a-browser), 所以`stalled`时间长意味着之前的请求没有返回，浏览器给不了更多的http连接。于是，将重点从浏览器转移到`nginx`，因为 __浏览器后的第一个环节是`nginx`__.

观察nginx的两个指标，`$request_time`, `$upstream_response_time`,[Nginx $request_time and $upstream_response_time in Windows](http://stackoverflow.com/questions/14592773/nginx-request-time-and-upstream-response-time-in-windows)
请求的`$request_time`基本都大于`$upstream_response_time`, 且`$upstream_response_time`经常出现`-`,并没能找到这以为着什么。

在没有明确是否是`nginx`有问题的时候，就开始排查`tomcat`的时间。**没有专注在某一个环节，这是错误二**。

观察`tomcat`日志，静态资源的时间都十分微小，并没有异样，所以基本可以排除`tomcat`的锅。之后的一段时间内都在研究一些`nginx`的配置，试图找到一些解决方法。**没有定位到问题就在找解决办法，这是错误三**。

尝试过以下方法:
-  修改`worker_processes`
-  增大`worker_connections`
-  增大linux最大文件打开数。


从最终的结果上看，这些操作是有用的。原因是修改后静态资源基本能正常响应返回。从network标签中可以看到，后台的请求时间长达20+s, 并且此时发送curl请求，请求依然很慢，所以基本可以甩锅给后台。但这并不是问题的全部。一方面，改后台压力吃不住，但仔细想想，即使并发小，如果请求都在1-2s内返回，也并不会出现卡顿。**一直想甩锅，没有意识到我们代码上有问题，这是错误四**。后来发现，网站端的瓶颈在于master.js里2s刷新hit请求，请求的返回时间较长，致使请求堆积。

最终的解决办法:
-  取消global的hit轮循，startPage的cross_retrieval轮循。
-  realtime页面的qury和hit请求等收到后再发下一次。



## 最后总结

复盘发现有四个方法上错误的地方。罗列如下：
- 发布前缺少压测，没有模拟环境。
- 排查问题环节不专注。
- 没有找到问题寻思解决方案。
- 总想甩锅。

其中，我认为第一条是最重要的，但因为时间与人力的不足，这很难排出时间进行专门的环境准备和测试。

相关知识点:
- 浏览器请求连接数
- nginx配置，打印时间
- 浏览器请求时间的含义
- nginx调优









































