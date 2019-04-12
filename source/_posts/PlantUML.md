---
title: PlantUML
date: 2019-04-05 11:20:04
tags:
---
使用简单的文字描述画UML图
<!-- more -->
## PlantUML简介
优秀类图源码展示
```puml
@startuml
title 视频播放功能的业务关联图
package 全屏播放业务功能 <<Cloud>> #DeepSkyBlue{
    package 视频播放业务层 <<Frame>> #DodgerBlue{
        package 播放内核 <<Frame>> #Blue{
            interface ADVideoPlayerListener{
                  +{static}{abstract}void onBufferUpdate(int position);//回调，视频缓冲
                  +{static}{abstract}void onAdVideoLoadSucess();//回调，视频加载成功
                  +{static}{abstract}void onAdVideoPlayComplete();//回调，视频正常播放完成
                  +{static}{abstract}void onAdVideoLoadFailed();//回调，视频不能正常播放
                  +{static}{abstract}void onClickVideo();//回调，点击视频区域的
                  +{static}{abstract}void onClickFullScreenBtn();//回调，点击全屏按钮
                  +{static}{abstract}void onClickBackBtn();
                  +{static}{abstract}void onClickPlay();
            }
            class CustomVideoView {
                .. 视频播放器，只有暂停、播放和停止的基本功能 ..
                ..其他功能事件实现在业务层..
                interface ADVideoPlayerListener
                -MediaPlayer mediaPlayer
                -ADVideoPlayerListener listener
                -ScreenEventReceiver mScreenEventReceiver
                ...
            }

            CustomVideoView o-down- ADVideoPlayerListener

        }

        interface AdSDKShellListener {
           +{static}{abstract}ViewGroup getAdParent();
           +{static}{abstract}void onAdVideoLoadSuccess();
           +{static}{abstract}void onAdVideoLoadFailed();
           +{static}{abstract}void onAdVideoPlayComplete();
           +{static}{abstract}void onClickVideo(String url);
        }

        class VideoAdShell{
            ..视频播放器的业务封装层..
            interface ADVideoPlayerListener
            +VideoAdShell(AdValue, AdSDKShellListener, ADFrameImageLoadListener)
            -MediaPlayer mediaPlayer
            -ADVideoPlayerListener listener
            -ScreenEventReceiver mScreenEventReceiver
            ...
        }

        AdSDKShellListener -down-o VideoAdShell
        VideoAdShell -right-|> ADVideoPlayerListener
        VideoAdShell .right.> CustomVideoView

    }



    class VideoFullDialog{
        ..全屏视频播放..
        - AdSDKShellListener mShellListener
        -MediaPlayer mediaPlayer
        -ADVideoPlayerListener listener
        -ScreenEventReceiver mScreenEventReceiver
        +VideoFullDialog(Context, CustomVideoView, AdValue, int)
        +void setShellListener(AdSDKShellListener)//承接业务层回调
        +void setListener(FullToSmallListener)//切换小屏回调
        ...
    }

    VideoFullDialog -up-|> ADVideoPlayerListener
}
VideoAdShell<..>VideoFullDialog


package 客户端 <<Frame>> #LightGray{
package SDK入口 <<Frame>> #gray{
    interface AdSDKShellListener{
        +{static}{abstract}void onAdSuccess();//视频资源加载成功
        +{static}{abstract}void onAdFailed();//无法播放
        +{static}{abstract}void onClickVideo(String url);//点击播放窗口回调
    }

    class VideoAdFactory{
        ..使用构建者模式构建实例,方便用户使用..
        ..使用外观模式封装视频播放SDK,方便使用API..
        -final ViewGroup mParentView;
        -final AdValue mInstance;
        +void setAdResultListener(AdFactoryInterface)
        +void updateAdInScrollView//根据用户滑动页面来判断视频自动播放
        +{static} class Builder
    }

    VideoAdFactory -up-|> AdSDKShellListener
}
    class Client<<用户层>> {
            ..生成VideoAdFactory实例,
            调用视频的API..
    }

    Client -left-> VideoAdFactory
}

@enduml
```
先来一个开口菜，概览功能
```puml
@startuml
title  decoupling
'skinparam packageStyle rect/' 加入这行代码，样式纯矩形'/
skinparam backgroundColor #EEEBDC
skinparam roundcorner 20
skinparam sequenceArrowThickness 2
'skinparam handwritten true
class Rxbus {
+IEventSubscriber iEventSubscriber
+addSubscriber(IEventSubscriber)
+sendMessageTo(Event)
}

interface IEventSubscriber
Rxbus --> IEventSubscriber
namespace com.xueshuyuan.cn.view #purple{

interface ILoginView{
+void loginWithPw()
+void loginByToken()
+void register()
+void success()
}
class LoginActivity<<接收反馈并更新UI>> {
+void loginWithPw()
+void loginByToken()
+void register()
+void success()
}

ILoginView <|--[#red] LoginActivity
}

namespace com.xueshuyuan.cn.presenter #orange{
interface ILoginPresenter{
+void loginByToken()
+void register()
}
class LoginPresenterImpl<<承接事件及接收通知处理并转发反馈>> {
+ILoginView iLoginView
+ILoginManager iLoginManager
+LoginPresenterImpl(ILoginView, ILoginManager)
+void loginWithPw()
+void loginByToken()
+void register()
+void receiveMessage(Event)
}

ILoginPresenter <|--[#red] LoginPresenterImpl
com.xueshuyuan.cn.view.LoginActivity <..[#red] LoginPresenterImpl :  Dependency
com.xueshuyuan.cn.moudle.LoginManagerImpl <..[#red] LoginPresenterImpl :  Dependency
.IEventSubscriber <|..[#red] ILoginPresenter
}


namespace com.xueshuyuan.cn.moudle #green{
interface ILoginManager{
+void loginWithPw()
+void loginByToken()
+void register()
+boolean checkUserExit()
+boolean checkPw()
}
class LoginManagerImpl<<承接事件及Rxbus发送通知>> {
+void loginWithPw()
+void loginByToken()
+void register()
+boolean checkUserExit()
+boolean checkPw()
+void sendMessageToXX(Event)
}

ILoginManager <|--[#red] LoginManagerImpl
}
```
## 类定义
### 类之间关系定义
------
```puml
@startuml
ClassA <-- ClassB:关联
ClassA <.. ClassB : 依赖
ClassA o-- ClassB:聚集
ClassA <|-- ClassB:泛化
ClassA <|.. ClassB:实现
@enduml
```
### 最简单的类定义
----
```puml
@startuml
Class China {
    String area
    int rivers
    long person
    class Beijing{}
    interface aa{}

    String getArea()
    long getPerson()
}
@enduml
```
### 多样的类定义
----
```puml
@startuml
Class China {
    -String area /'-表示权限private'/
    #int rivers  /'#表示权限protected'/
    +long person /'+表示权限public'/
    class Beijing{}
    interface aa{}

    ~String getArea() /'~表示权限package private'/
    long getPerson()
}
@enduml
```
### 静态属性和抽象方法
----
```puml
@startuml
Class China {
    {static}+int id /' 表示 静态属性（下划线） '/
    -String area
    #int rivers
    +long person

    ~String getArea()
    {abstract}long getPerson() /' 表示 抽象方法（斜体） '/
}
@enduml
```
### 自定义类主题
----
```puml
@startuml
class China {
  {static} int id
  int rivers
  long person
  .. /' 省略号 '/
  String city
  double lat
  ==/' 双分割线 '/
  {abstract}long getCities()
  __/' 单分割线 '/
  long getPerson()
  double getLat()
}

class Beijing {
  .. 注解说明 ..
  + setRiver()
  + setName()
  __ 注解说明 __
  + setPerson()
  -- 注解说明 --
  String password
}
 China <-- Beijing
@enduml
```
### 类图注释
----
```puml
@startuml
class MainActivity
note left:左侧注明用途
note right of MainActivity:右侧注明用途
note top of MainActivity:上面注明用途
note bottom of MainActivity:下面注明用途

class List<<general>>
note top of List : 接口类型,xxList extends it

class ArrayList
note left : 基于长度可变的数组的列表

note "Collection 的衍生接口和类" as NOTE
List .. NOTE
NOTE .. ArrayList

List <|-- ArrayList
@enduml
```
## 关于类、抽象类和接口的定义及关系
### 动物园的饲养员能够给各种各样的动物喂食，绘制逻辑，效果
----
```puml
@startuml
class Feeder<<饲养员>>{
-void feed()
}

abstract Food
class Bone
class Fish
Food <|--Bone
Food <|--Fish

abstract Animal{
-void eat()
}
class Dog{
-void eat()
}
class Cat{
-void eat()
}
Animal <|-- Dog
Animal <|-- Cat


Feeder ..>Food
Feeder ..>Animal

@enduml
```
### 关于Set以及其衍生类之间的关系，绘制逻辑
----
```puml
@startuml
interface Set<<接口>>{
boolean add (Object o)
boolean remove(Object o)
}

class HashSet{
+boolean add (Object o)
+boolean remove(Object o)
}
interface IntSet{
boolean add (int i)
boolean remove(int i)
}
class IntHashSet{
+boolean add (int i)
+boolean remove(int i)
}

Set <|.. HashSet
HashSet <|-- IntHashSet
IntSet <|.. IntHashSet

class TreeSet{
+boolean add (Object o)
+boolean remove(Object o)
}
class IntTreeSet{
+boolean add (int i)
+boolean remove(int i)
}

IntSet <|.. IntTreeSet
TreeSet <|-- IntTreeSet
Set <|.. TreeSet

@enduml
```
### 使用泛型功能的类图，效果
----
```puml
@startuml
class HashSet<? extends String>{
+boolean add (Object o)
+boolean remove(Object o)
}
@enduml
```
### 同属一个包下的类、抽象类和接口，效果
----
```puml
@startuml
interface Set<<接口>>{
boolean add (Object o)
boolean remove(Object o)
}

package "com.ztman.cn" #green{
class HashSet<? extends String>{
+boolean add (Object o)
+boolean remove(Object o)
}
interface IntSet{
boolean add (int i)
boolean remove(int i)
}
class IntHashSet{
+boolean add (int i)
+boolean remove(int i)
}
}

Set <|.. HashSet
HashSet <|-- IntHashSet
IntSet <|.. IntHashSet

class TreeSet{
+boolean add (Object o)
+boolean remove(Object o)
}
class IntTreeSet{
+boolean add (int i)
+boolean remove(int i)
}

IntSet <|.. IntTreeSet
TreeSet <|-- IntTreeSet
Set <|.. TreeSet

@enduml
```
### 包与包之间建立关系，效果
----
```puml
@startuml
skinparam packageStyle rect/' 加入这行代码，样式纯矩形'/
interface Set<<接口>>{
boolean add (Object o)
boolean remove(Object o)
}

package "com.ztman.org"  as Pa #green{
class HashSet<? extends String>{
+boolean add (Object o)
+boolean remove(Object o)
}
interface IntSet{
boolean add (int i)
boolean remove(int i)
}
class IntHashSet{
+boolean add (int i)
+boolean remove(int i)
}
}

Set <|.. HashSet
HashSet <|-- IntHashSet
IntSet <|.. IntHashSet

package "com.ztman.org.cn"  as Pb #orange{
class TreeSet {
+boolean add (Object o)
+boolean remove(Object o)
}
class IntTreeSet{
+boolean add (int i)
+boolean remove(int i)
}
}
IntSet <|.. IntTreeSet
TreeSet <|-- IntTreeSet
Set <|.. TreeSet

Pb +-- Pa

@enduml
```
### 以命名空间分割，并在不同空间内类之间建立关系，效果
----
```puml
@startuml
skinparam packageStyle rect/' 加入这行代码，样式纯矩形'/
interface Set<<接口>>{
boolean add (Object o)
boolean remove(Object o)
}

namespace com.ztman.org #green{
class HashSet<? extends String>{
+boolean add (Object o)
+boolean remove(Object o)
}
interface IntSet{
boolean add (int i)
boolean remove(int i)
}
class IntHashSet{
+boolean add (int i)
+boolean remove(int i)
}

.Set <|.. HashSet
HashSet <|-- IntHashSet
IntSet <|.. IntHashSet
}


namespace com.ztman.org.cn #orange{
class TreeSet {
+boolean add (Object o)
+boolean remove(Object o)
}
class IntTreeSet{
+boolean add (int i)
+boolean remove(int i)
}

com.ztman.org.IntSet <|.. IntTreeSet
TreeSet <|-- IntTreeSet
.Set <|.. TreeSet
}
```
### 对于一些单个存在且不想展示出来的类图的类、属性和方法，我们可以将其隐藏。只需要在其类 class 前加hide即可，显示使用show