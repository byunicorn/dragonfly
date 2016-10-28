---
title: Tabs/Windows之间的数据共享
date: 2016-10-28 17:31:24
tags: [JavaScript, lbao]
author: lbao
---

昨天被问了个问题，说有这样一个场景，要实现外部搜索功能：用户在自己的网站上上传了一些数据，然后点击外部搜索，跳到我们的页面，我们的页面要能够拿到用户数据进行搜索。其中用于搜索的信息很长，放在url里面不可行。

我今天调研了一下，找到了两个解决方案：
1. [cross-domain-local-storage](https://github.com/ofirdagan/cross-domain-local-storage/wiki)，使用第三方库，这个方案尚未实验过。
2. 用户点击搜索的时候，打开一个新的tab并转到我们的页面，而不是直接跳转，然后两个页面通过`postMessage`互通消息。Reference: [Window.postMessage() - Web APIs | MDN](https://developer.mozilla.org/en-US/docs/Web/API/Window/postMessage)

<!-- more -->
下面是代码片段：
```JavaScript
// user page
var ourWindow;
function openNewTab() {
	ourWindow = window.open("http://localhost:3002/index.html", "_blank");
}

window.addEventListener("message", function(event) {
	var origin = event.origin || event.originalEvent.origin;
	if (origin === "http://localhost:3002" && ourWindow) {
		ourWindow.postMessage("Fine. Thank U. And U?", "http://localhost:3002");
	}
});
```

```JavaScript
// our page
window.opener.postMessage("How Are You", "http://localhost:3001");
```

完整示例可以参考：[dragonfly/code/JavaScript/SendMessageBetweenTabsWindows](https://github.com/wflkaaa/dragonfly/tree/master/code/JavaScript/SendMessageBetweenTabsWindows)