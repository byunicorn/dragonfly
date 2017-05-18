---
title: exif-jpeg
date: 2017-05-18 20:45:53
tags: [zmzhang, exif, h5]
---

## JPEG文件的EXIF信息

手机H5网页可以调用手机原生的拍照功能来获取图片，但是不同的机型获得的
照片的格式会有差异，比如iphone6拍照入库之后是竖屏的，但是iphone5s
拍的照片在手机和电脑上看都是竖屏的，但是入库之后会变成横屏的图片（向左旋转了90度），后来发现iphone的图片
浏览器和电脑的图片浏览器会对图片进行自动的旋转，让图片看起来是竖屏的，
但是图片本身的数据是横屏。手机拍摄的照片都会有EXIF信息，我们可以根据
EXIF 的meta信息对图片进行处理，从而获得想要的结果（exif只支持jpeg格式）。

Exif是一种图像文件格式，它的数据存储与JPEG格式是完全相同的。
实际上Exif格式就是在JPEG格式头部插入了数码照片的信息，
包括拍摄时的光圈、快门、白平衡、ISO、焦距、日期时间等各种和拍摄条件
以及相机品牌、型号、色彩编码、拍摄时录制的声音以及GPS全球定位系统数据、
缩略图等。你可以利用任何可以查看JPEG文件的看图软件浏览Exif格式的照片，
但并不是所有的图形程序都能处理Exif信息。

 ![](https://github.com/wflkaaa/dragonfly/blob/master/code/images/exif.png?raw=true)

[wiki exif link](https://en.wikipedia.org/wiki/Exif)

其中的Orientation就是图片的旋转方向, orientation的值与旋转方向的对应关系如下图：
![](https://github.com/wflkaaa/dragonfly/blob/master/code/images/orientation.png?raw=true)


前端获取EXIF信息的方法：
可以使用[exif-js](https://github.com/exif-js/exif-js) 库来获取图片的exif信息；
该js库获取exif数据的方法例如：
1、image对象

```


function loadImage(file, callback){
    if(FileReader && file){
        //检查浏览器支持filereader 有些手机浏览器不支持filereader或者不支持filereader的某些方法
        var fr = new FileReader();
        fr.onload = function(){
            var image = new Image()
            image.onload = function(){
                callback(image);
            }
            image.src = fr.result;
        }
        fr.readAsDataURL(file)
    }
}
loadImage(file, function(img){
    EXIF.getData(img, function(){
        var exifMeta = EXIF.getAllTags(this)
        // 获取所有的exifdata，如上图中给出的字段
    }
})

```

2、binary file

```
function getExifMeta(file, callback){
    if(FileReader && file){
        var reader = new FileReader();
        reader.onload = function(){
            // 获取exifData
            var exifData = EXIF.readFromBinaryFile(reader.result)
            callback(exifData)
        }
        reader.readAsArrayBuffer(file)
    }
}
```

附送图片旋转示例：
```
    rotateImg(base64Str, rotate, callback){
        const image = new Image();
        image.onload = () => {
            const canvas = document.createElement('canvas');
            const ctx = canvas.getContext('2d');
            if (rotate === 90 || rotate === 270){
                canvas.width = image.height;
                canvas.height = image.width;
            }else {
                canvas.width = image.width;
                canvas.height = image.height;
            }
            ctx.clearRect(0,0,canvas.width,canvas.height);
            // save the unrotated context of the canvas so we can restore it later
            // the alternative is to untranslate & unrotate after drawing
            ctx.save();
            // move to the center of the canvas
            ctx.translate(canvas.width/2,canvas.height/2);
            // rotate the canvas to the specified degrees
            ctx.rotate(rotate * Math.PI/180);
            // draw the image
            // since the ctx is rotated, the image will be rotated also
            if(rotate === 90 || rotate === 270){
                ctx.drawImage(image, -canvas.height/2, -canvas.width/2);
            }else {
                ctx.drawImage(image, -canvas.width/2, -canvas.height/2);
            }
            // we’re done with the rotating so restore the unrotated ctx
            ctx.restore();
            callback(canvas.toDataURL());
        };
        image.src = base64Str;
    }
```

### 备注： canvas对手机浏览器的版本要求比较高！
