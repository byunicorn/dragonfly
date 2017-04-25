---
title: Archive Tips
date: 2017-04-25 11:01:28
tags: [rbzhou,gulp,linux]
---

# zip指令
```
zip -q -r ${file_name}.zip dir
```
注意点: 打包进去的时候会保留dir的接口。比如`zip -q -r example.zip dir1/file1`, 那么`example.zip`里会有一个文件夹叫`dir1`，而不仅仅是`file1`。
所以，在把`dist`文件夹下的内容打到war里的时候，需要先`cd dist`再使用`zip`指令。

# gulp src排除文件
生成`dist`文件夹的时候，`data`文件夹本来是不需要的，但是其中有一个文件`cameraMeta.json`是需要的。这个时候想在`gulp.src`的时候写配置，语法是有点麻烦的。如下:
```
    var src = [path.join(conf.paths.src, '/**/*')].concat(conf.buildExclude.map(function (item) {
       return '!' + item;
    }));
    return gulp.src(src, {dot: true}).pipe(gulp.dest(conf.paths.dist));
    
exports.buildExclude = [
    'frontend/data',
    'frontend/data/**/!(cameraMeta.json)',
    'frontend/old',
    'frontend/old/**',
    'frontend/sass',
    'frontend/sass/**',
    'frontend/index.html',
    'frontend/karma.conf.js',
    'frontend/valid_nginx.conf'
];
```
[references](http://stackoverflow.com/questions/26485612/glob-minimatch-how-to-gulp-src-everything-then-exclude-folder-but-keep-one)