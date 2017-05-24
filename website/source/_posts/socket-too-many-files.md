---
title: socket too many files
date: 2017-05-20 11:53:28
tags: [rbzhou]
---

xiaoyao测试时跑了一晚上的网站，回来发现挂掉了。日志里报错大致为socket开的太多了，too many open files.
原因在于java端调用apache httpclient的时候，没有close掉这个连接。

这是apache httpclient的quick start里的示例代码，http://hc.apache.org/httpcomponents-client-ga/quickstart.html
```
HttpPost httpPost = new HttpPost("http://targethost/login");
List <NameValuePair> nvps = new ArrayList <NameValuePair>();
nvps.add(new BasicNameValuePair("username", "vip"));
nvps.add(new BasicNameValuePair("password", "secret"));
httpPost.setEntity(new UrlEncodedFormEntity(nvps));
CloseableHttpResponse response2 = httpclient.execute(httpPost);
try {    System.out.println(response2.getStatusLine());
HttpEntity entity2 = response2.getEntity();
// do something useful with the response body
// and ensure it is fully consumed
EntityUtils.consume(entity2);} finally {    response2.close();}
```
我们原先代码里没有
```
EntityUtils.consume(entity2)
response2.close()
httpClient.close()
```
   需要理解清楚CLOSE_WAIT的含义。
https://blogs.technet.microsoft.com/janelewis/2010/03/09/explaining-close_wait/
我的理解是，出现CLOSE_WAIT是client向server发了close请求，然后自己没有主动的执行close的动作。另，timeout对这个无效。


