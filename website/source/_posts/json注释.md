---
title: json注释
date: 2017-05-19 12:52:20
tags:
---

以前不知道json不能加注释，加了编辑器也不会报错。

但是做翻译的时候，不管是` // `还是 `/**/ `都会导致字典加载出错。

结论是，json标准本来就不支持注释，但是json并不是一定不能加注释，有的库会解析报错，有的不会，总之不推荐。
如果一定要加注释，请另开一个解释性字段，如comment：
```json
"asm":{
  "comment":"short for advanced settings modal",
  "checkbox":{
    "quick_search":"Quick Search"
  },
  "description":{
    "quick_search":"(Turn off for more results(time consuming))"
  }
},
```
