---
title: HTTP安全相关的Headers
date: 2017-04-04 15:57:48
tags: [lbao, security]
---

前两天颖聪share了一篇关于HTTPS优化的topic，其中涉及到了HTTP Strict Transport Security(HSTS)相关的内容，个人比较感兴趣，所以稍微花了点时间做了些扩展阅读。这篇文章会简单介绍一些HTTP安全相关的请求/响应头。

## HTTP Strict Transport Security (HSTS)
HTTP Strict Transport Security（HSTS）是由IETF发布的互联网安全策略机制。通过添加`Strict-Transport-Security` header来强制浏览器使用HTTPS与网站进行通信，从而减少中间人攻击(MitM)的风险。

```
Strict-Transport-Security:max-age=expireTime; includeSubDomains;
```

refs:
[HTTP Strict Transport Security - 安全 | MDN](https://developer.mozilla.org/zh-CN/docs/Security/HTTP_Strict_Transport_Security)

<!-- more -->

## X-XSS-Protection
正如其名，这个头是用来防止[Cross-site Scripting (XSS)攻击](https://www.owasp.org/index.php/Cross-site_Scripting_(XSS)的，它会强制浏览器对HTTP的请求/响应做检查，但检查的机制比较简单粗暴：寻找符合XSS攻击的code pattern，因此有一定的误判率。另外，firefox并不支持这个Header。

```
X-XSS-Protection: 1; mode=block
```
1 or 0：表示enable 或 disable；`mode=block`表示当检测到XSS攻击，则block页面渲染。

refs:
[X-XSS-Protection - HTTP | MDN](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-XSS-Protection)

## Content Security Policy (CSP)
CSP主要是用来防止XSS攻击以及数据注入攻击，它用白名单的形式对网站上加载及执行的资源做了限制。举个简单的例子：

```
Content-Security-Policy: script-src 'self' https://apis.google.com
```

上面这条规则就规定了：页面允许来自同源或`https://apis.google.com`的script执行。所以如果有人在你的页面上注入了一段代码去请求并执行`http://evil.com/evil.js`脚本，就会被浏览器阻止。

除了`script-src`之外，CSP还提供了很多其他的资源限制指令，具体可以到下面refs里提供的链接里查看。

refs:
[Content Security Policy (CSP) - HTTP | MDN](https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP)
[An Introduction to Content Security Policy - HTML5 Rocks](https://www.html5rocks.com/en/tutorials/security/content-security-policy/)
[GitHub’s CSP journey - GitHub Engineering](https://githubengineering.com/githubs-csp-journey/)

## X-Frame-Options
X-Frame-Options规定了当前页面能否被iframe到别的网页中。developer可以设置这个Header来限制或者阻止其他网站通过`iframe`/`frame`/`object`等标记来内嵌你的网页，从而避免了clickjacking的攻击。
这里简单解释一下：clickjacking是一种“障眼法”，视觉上欺骗用户点击A，其实点击的是B。举个例子：

```
<button class='same-clz'>送你钱</button>
<iframe class='same-clz' style='opacity: 0;z-index=999;position:absolute;’ src='http://huaniqian.com'>
	<a href="/buy?123">花你钱</a>
</iframe>
```

上面的code里iframe了一个页面，页面内有个link，点击了会花钱，然后我通过设置内嵌页面的style，让它opacity为0，z-index为最大，再在自己页面的相同位置放一个button来勾引用户点击，用户以为自己点击了送你钱button，其实点击的是花你钱link……

refs:
[X-Frame-Options 响应头 - HTTP | MDN](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/X-Frame-Options)
[Clickjacking - OWASP](https://www.owasp.org/index.php/Clickjacking)

## Cache-Control
根据IETF [RFC 7234](https://tools.ietf.org/html/rfc7234)，若非显式指定，浏览器和代理服务器总是会cache`GET`请求的响应结果。所以如果你的`GET`请求中带有私密信息，那么很可能会造成信息的泄露。因此我们需要设置cache-control头来阻止类似数据的缓存。设置如下：

```
Cache-Control: no-cache, no-store, must-revalidate
Progma: no-cache
Expires: -1
```

其中，Cache-Control是HTTP1.1引入的Header。

下面是几个选项的官方定义：
no-cache：no-cache 不意味着 "别缓存"，它强制所有缓存了该响应的用户，在使用已存储的缓存数据前，发送带验证器的请求到原始服务器；
no-store：不可缓存客户端请求或服务端响应；
must-revalidate: must-revalidate也不意味着 "必须做检查"，它意味着，如果本地的缓存没有过期（没超过max-age），则可以使用，否则必须重新验证。

Progma是HTTP1.0里的Header。
no-cache: 和Cache-Control里的no-cache一样。

Expires: 这里设置的是响应的过期时间，因为设置了-1，所以当浏览器接收完响应，就会立刻把这个响应作为过期来处理，从而避免了缓存。

refs:
[HTTP caching - HTTP | MDN](https://developer.mozilla.org/en-US/docs/Web/HTTP/Caching)

逃避咖啡惩罚外加篇幅限制先说这么多，将来有机会再补充其他的部分……

ref: [How To Secure Your Web App With HTTP Headers – Smashing Magazine](https://www.smashingmagazine.com/2017/04/secure-web-app-http-headers/)