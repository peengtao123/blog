---
title: markdown语法
date: 2019-03-22 12:39:17
tags:
categories:
- 工具
---
这是摘要

<!-- more -->

# 标题
# 这是一级标题
## 这是二级标题
### 这是三级标题
#### 这是四级标题
##### 这是五级标题
###### 这是六级标题
# 二、字体
**这是加粗的文字**
*这是倾斜的文字*`
***这是斜体加粗的文字***
~~这是加删除线的文字~~
# 三、引用
>这是引用的内容
>>这是引用的内容
# 四、分割线
---
----
***
*****
# 五、图片
![blockchain](https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=702257389,1274025419&fm=27&gp=0.jpg "区块链")

# 六、超链接
[百度](http://baidu.com "百度")

# 七、列表

- 列表内容
   - 水电费
   - 水电费
   - 水电费
+ 列表内容
* 列表内容

# 八、表格
## 原生语法
姓名|技能|排行
:--:|:--|:--:|
刘备|哭|大哥
关羽|打|二哥
张飞|骂|三弟

## html语法

# 九、代码
`echo 34 #代码内容`

```javascript
    function fun(){
         echo "这是一句非常牛逼的代码";
    }
    fun();
```
# 流程图
```mermaid
graph TD;
    A-->B;
    A-->C;
    B-->D;
    C-->E;
    E-->F;
    D-->F;
    F-->G;
```
# 时序图
```mermaid
sequenceDiagram
    participant Alice
    participant Bob
    Alice->John: Hello John, how are you?
    loop Healthcheck
        John->John: Fight against hypochondria
    end
    Note right of John: Rational thoughts 
```
甘特图
```mermaid
gantt
        dateFormat  YYYY-MM-DD
        title Adding GANTT diagram functionality to mermaid
        section A section
        Completed task            :done,    des1, 2014-01-06,2014-01-08
        Active task               :active,  des2, 2014-01-09, 3d
        Future task               :         des3, after des2, 5d
        Future task2               :         des4, after des3, 5d
        section Critical tasks
        Completed task in the critical line :crit, done, 2014-01-06,24h
        Implement parser and jison          :crit, done, after des1, 2d
        Create tests for parser             :crit, active, 3d
        Future task in critical line        :crit, 5d
        Create tests for renderer           :2d
        Add to mermaid                      :1d
```