---
title: svg
categories:
  - 开源
date: 2019-08-05 21:35:57
tags:
---
svg入门
<!-- more -->
svg是一种基于xml语法的图像格式。svg可直接插入网页，成为DOM的一部分，然后用JavaScript和css进行操作。
```html
<!DOCTYPE html>
<html>
<head></head>
<body>
<svg
  id="mysvg"
  xmlns="http://www.w3.org/2000/svg"
  viewBox="0 0 800 600"
  preserveAspectRatio="xMidYMid meet"
>
  <circle id="mycircle" cx="400" cy="300" r="50" />
<svg>
</body>
</html>
```
也可以直接写在一个文件中，然后用以下标签标签插入网页。
```html
<img src="circle.svg">
<object id="object" data="circle.svg" type="image/svg+xml"></object>
<embed id="embed" src="icon.svg" type="image/svg+xml">
<iframe id="iframe" src="icon.svg"></iframe>
```
也可用css
```css
.logo {
  background: url(icon.svg);
}
```
SVG 文件还可以转为 BASE64 编码，然后作为 Data URI 写入网页
```html
<img src="data:image/svg+xml;base64,[data]">
```
SVG 图像转为 Canvas 图像,首先，需要新建一个Image对象，将 SVG 图像指定到该Image对象的src属性。
```javascript
var img = new Image();
var svg = new Blob([svgString], {type: "image/svg+xml;charset=utf-8"});

var DOMURL = self.URL || self.webkitURL || self;
var url = DOMURL.createObjectURL(svg);

img.src = url;
```
然后，当图像加载完成后，再将它绘制到\<canvas\>元素。
```javascript
img.onload = function () {
  var canvas = document.getElementById('canvas');
  var ctx = canvas.getContext('2d');
  ctx.drawImage(img, 0, 0);
};
```