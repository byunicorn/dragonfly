---
title: tomcat跨域请求和跨域重定向
date: 2016-11-05 23:34:54
tags:[跨域, zmzhang, tomcat]
---

网站开发过程中偶尔会遇到需要跨域访问的问题，这里简单总结一下tomcat处理跨域请求以及ajax处理重定向的问题；
###1. tomcat跨域配置
服务端配置有两种方式，原理都是一样的，一种是设置response的header由于会出现很多重复代码这里就不介绍了，另一种是在网站的web.xml文件中添加filter来允许处理所有的跨域请求，完整的配置如下：

<!--more-->


```
<filter>
  <filter-name>CorsFilter</filter-name>
  <filter-class>org.apache.catalina.filters.CorsFilter</filter-class>
  <init-param>
    <param-name>cors.allowed.origins</param-name>
    <param-value>*</param-value>
  </init-param>
  <init-param>
    <param-name>cors.allowed.methods</param-name>
    <param-value>GET,POST,HEAD,OPTIONS,PUT</param-value>
  </init-param>
  <init-param>
    <param-name>cors.allowed.headers</param-name>
    <param-value>Content-Type,X-Requested-With,accept,Origin,Access-Control-Request-Method,Access-Control-Request-Headers</param-value>
  </init-param>
  <init-param>
    <param-name>cors.exposed.headers</param-name>
    <param-value>Access-Control-Allow-Origin,Access-Control-Allow-Credentials</param-value>
  </init-param>
  <init-param>
    <param-name>cors.support.credentials</param-name>
    <param-value>true</param-value>
  </init-param>
  <init-param>
    <param-name>cors.preflight.maxage</param-name>
    <param-value>10</param-value>
  </init-param>
</filter>
<filter-mapping>
  <filter-name>CorsFilter</filter-name>
  <url-pattern>/*</url-pattern>
</filter-mapping>	
		
```

其中的param-value是要允许的跨域请求的域名，url-pattern是允许跨域的url，具体的配置解释可以参照官方文档：
http://tomcat.apache.org/tomcat-7.0-doc/config/filter.html#CORS_Filter

网页前端的配置，如果使用的form提交数据完全就已经可以work了，但是如果使用的是ajax提交数据，还需要增加配置如下：


```
$.ajax({
            url: url,
            type: 'POST',
            data: JSON.stringify(data),
            dataType: "JSON",
            headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    },
           	 success : function(){
			 },
	    	 error: function(){
	    	 }
       
        });


```

其中主要是要修改Content-Type 为 application/x-www-form-urlencode

###2. java重定向
在java端使用response.sendRedirect(url), 来重定向一个url，如果是使用form提交的请求页面就会调转到相应的url，但是如果是用ajax 提交的请求就会返回302错误；
这是因为ajax处理不了重定向的返回，会认为302错误，需要手动判断返回的状态是否是重定向，会在error的返回结果里接收到数据，或者可以使用complete状态来接收返回数据，然后手动判断返回状态码然后进行跳转。
