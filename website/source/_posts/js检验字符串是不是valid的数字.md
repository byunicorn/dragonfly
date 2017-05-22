---
title: js检验字符串是不是valid的数字
date: 2017-05-19 12:52:07
tags:
---
js里面，需要验证input框中输入的string是不是一个valid的数字，可以使用这些方法：

isNaN，无论字符串是数字形式还是数字，会返回true，否则会返回false，可以判断用来判断“123”是不是一个数字。

+num，可以把数字形式的字符串变成数字，否则变成NaN，很奇怪的是， +"" 这个会转化为0。

[http://stackoverflow.com/questions/175739/is-there-a-built-in-way-in-javascript-to-check-if-a-string-is-a-valid-number](http://stackoverflow.com/questions/175739/is-there-a-built-in-way-in-javascript-to-check-if-a-string-is-a-valid-number)