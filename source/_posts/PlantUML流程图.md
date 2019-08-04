---
title: PlantUML流程图
date: 2019-04-05 12:12:22
tags:
- PlantUML
---
摘要
<!-- more -->
## 用例图
```puml
@startuml
skinparam handwritten true
skinparam backgroundColor #EEEBDC
actor 使用者
participant "頭等艙" as A
participant "第二類" as B
participant "最後一堂課" as 別的東西
使用者-> A: 完成這項工作
activate A
A -> B: 創建請求
activate B
B -> 別的東西: 創建請求
activate 別的東西
別的東西--> B: 這項工作完成
destroy 別的東西
B --> A: 請求創建
deactivate B
A --> 使用者: 做完
deactivate A
@enduml
```
```puml
@startuml
robust "Web 浏览器" as WB
concise "Web 用户" as WU
@0
WU is 空闲
WB is 空闲
@100
WU is 等待中
WB is 处理中
@300
WB is 等待中
@enduml
```
## 流程
```puml
@startuml
    start
    :"步骤1处理";
    :"步骤2处理";
    if ("条件1判断") then (true)
        :条件1成立时执行的动作;
        if ("分支条件2判断") then (no)
            :"条件2不成立时执行的动作";
        else
            if ("条件3判断") then (yes)
                :"条件3成立时的动作";
            else (no)
                :"条件3不成立时的动作";
            endif
        endif
        :"顺序步骤3处理";
    endif

    if ("条件4判断") then (yes)
    :"条件4成立的动作";
    else
        if ("条件5判断") then (yes)
            :"条件5成立时的动作";
        else (no)
            :"条件5不成立时的动作";
        endif
    endif
    stop
@enduml
```
## 组件
--------
```puml
@startuml
package "组件1" {
    ["组件1.1"] - ["组件1.2"]
    ["组件1.2"] -> ["组件2.1"]
}

node "组件2" {
    ["组件2.1"] - ["组件2.2"]
    ["组件2.2"] --> [负载均衡服务器]
}

cloud {
    [负载均衡服务器] -> [逻辑服务器1]
    [负载均衡服务器] -> [逻辑服务器2]
    [负载均衡服务器] -> [逻辑服务器3]
}

database "MySql" {
    folder "This is my folder" {
        [Folder 3]
    }

    frame "Foo" {
        [Frame 4]
    }
}

[逻辑服务器1] --> [Folder 3]
[逻辑服务器2] --> [Frame 4]
[逻辑服务器3] --> [Frame 4]

@enduml
```
## 状态图
```puml
@startuml
scale 350 width
[*] --> NotShooting

state NotShooting {
  [*] --> Idle
  Idle --> Configuring : EvConfig
  Configuring --> Idle : EvConfig
}

state Configuring {
  [*] --> NewValueSelection
  NewValueSelection --> NewValuePreview : EvNewValue
  NewValuePreview --> NewValueSelection : EvNewValueRejected
  NewValuePreview --> NewValueSelection : EvNewValueSaved

  state NewValuePreview {
     State1 -> State2
  }

}
@enduml

```
## 用例图：
```puml
@startuml
:Main Admin: as Admin
(Use the application) as (Use)

User -> (Start)
User --> (Use)

Admin ---> (Use)

note right of Admin : This is an example.

note right of (Use)
A note can also
be on several lines
end note

note "This note is connected\nto several objects." as N2
(Start) .. N2
N2 .. (Use)
@enduml
```
## 流程案例
```puml
@startuml
title Android Broadcast procedure
participant Activity #Lime
participant ContextWrapper #Cyan
participant ContextImpl #Cyan
participant ActivityManagerService #Cyan
participant ActivityStackSupervisor #Cyan
participant ActivityStack #Cyan
participant ApplicationThreadProxy #Silver
participant InnerReceiver #Magenta
participant ReceiverDispatcher #Magenta
participant BroadcastReceiver #Magenta

autonumber
Activity -> ContextWrapper : registerReceiver()
ContextWrapper -> ContextImpl : registerReceiver()
ContextImpl -> LoadedApk : getReceiverDispatcher()
LoadedApk -> ActivityManagerProxy : registerReceiver()
ActivityManagerProxy -> ActivityManagerService : registerReceiver()

Activity -> ContextWrapper : sendBroadcast()
ContextWrapper -> ContextImpl : sendBroadcast()
ContextImpl -> ActivityManagerService: broadcastIntent()
ActivityManagerService -> ActivityManagerService : broadcastIntentLocked()
ActivityManagerService -> ActivityManagerService : collectReceiverComponents()
ActivityManagerService -> ActivityManagerService : scheduleBroadcastsLocked()
ActivityManagerService -> ActivityManagerService : processNextBroadcast()
ActivityManagerService -> ActivityManagerService : deliverToRegisteredReceiverLocked()
ActivityManagerService -> ActivityManagerService : performReceiveLocked()
ActivityManagerService -> ApplicationThreadProxy : scheduleRegisteredReceiver()
ApplicationThreadProxy -> InnerReceiver : performReceive()
InnerReceiver -> ReceiverDispatcher : performReceive()
ReceiverDispatcher -> BroadcastReceiver : onReceive()

Activity -> ContextWrapper : sendOrderedBroadcast()
ContextWrapper -> ContextImpl : sendOrderedBroadcast()
ContextImpl -> ActivityManagerService: broadcastIntent()
@enduml
```
流程图
```puml
@startuml

title 流程图

(*) --> "步骤1处理"
--> "步骤2处理"
if "条件1判断" then
    ->[true] "条件1成立时执行的动作"
    if "分支条件2判断" then
        ->[no] "条件2不成立时执行的动作"
        -> === 中间流程汇总点1 ===
    else
        -->[yes] === 中间流程汇总点1 ===
    endif
    if "分支条件3判断" then
        -->[yes] "分支条件3成立时执行的动作"
        --> "Page.onRender ()" as render
        --> === REDIRECT_CHECK ===
    else
        -->[no] "分支条件3不成立时的动作"
        --> render
    endif
else
    -->[false] === REDIRECT_CHECK ===
endif
 
if "条件4判断" then
    ->[yes] "条件4成立时执行的动作"
    --> "流程最后结点"
else
endif
--> "流程最后结点"
-->(*)
 
@enduml
```
### 参考网址
https://blog.csdn.net/zh_weir/article/details/72675013
https://blog.csdn.net/geduo_83/article/details/86422485
https://blog.csdn.net/zh_weir/article/details/72675013
https://blog.csdn.net/junhuahouse/article/details/80767632
https://blog.csdn.net/YangDongChuan1995/article/details/81842652
https://blog.csdn.net/wxb141001yxx/article/details/53365514 
https://blog.csdn.net/shiqijiamengjie/article/details/25191321
https://blog.csdn.net/degwei/article/details/51489444

[snap.svg](https://www.zhangxinxu.com/GitHub/demo-Snap.svg/demo/basic/)
http://www.php.cn/
http://phpstudy.php.cn/css3/
http://phpstudy.php.cn/