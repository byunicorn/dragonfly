---
title: Java代码导出PDF
date: 2017-05-19 12:52:55
tags:
---

#### 添加依赖：
pom.xml
```xml
<dependency>
    <groupId>com.itextpdf</groupId>
    <artifactId>itextpdf</artifactId>
    <version>5.5.10</version>
</dependency>
<dependency>
    <groupId>com.itextpdf</groupId>
    <artifactId>itext-asian</artifactId>
    <version>5.2.0</version>
</dependency>
```
其中itextpdf是用来生成pdf的核心模块，itext-asian是为了支持中文字符。
<!-- more -->
#### 代码部分：
```java
public static void toPdf(File file, List<String[]> content) throws Exception {
    Document doc = new Document();
    FontSelector selector = new FontSelector();
    selector.addFont(FontFactory.getFont(FontFactory.TIMES_ROMAN, 12));
    selector.addFont(FontFactory.getFont(AsianFontMapper.ChineseSimplifiedFont, AsianFontMapper.ChineseSimplifiedEncoding_H, BaseFont.NOT_EMBEDDED));
    PdfWriter.getInstance(doc, new FileOutputStream(file));
    doc.open();
    int columnCount = content != null && content.size() > 0 ? content.get(0).length: 0;
    PdfPTable table = new PdfPTable(columnCount);
    PdfPCell cell = null;
    for (String[] line : content) {
        for (String column : line) {
            cell = new PdfPCell(selector.process(column));
            table.addCell(cell);
        }
    }

    doc.add(table);
    doc.close();
}
```

要注意的是FontSelector，当需要导出的数据是中英文混杂的，则必须设置Font，用默认的Font会导致中文内容全部消失。

p.s. 中文繁/简体字体也必须分开设置，昨天网上搜到一个打印中文的解决方案，结果是针对繁体字的，“通过”中的"通"字能显示得出来，但是"过"字就被默默地吞掉了。

更多详细可以参考：
[http://developers.itextpdf.com/tutorial/using-fonts-pdf-and-itext](http://developers.itextpdf.com/tutorial/using-fonts-pdf-and-itext)
