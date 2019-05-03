---
title: springBoot功能
date: 2019-04-19 23:29:45
tags:
---
这部分深入介绍spring boot的细节，将学习到主要特性。
<!-- more -->
## spring应用
### CommandLineRunner的使用
Spring boot的CommandLineRunner接口主要用于实现在应用初始化后，去执行一段代码块逻辑，这段初始化代码在整个应用生命周期内只会执行一次。
我们可以使用以下三种方式使用CommandLineRunner接口：
**1. 和@Component注解一起使用**
```java
@Component
public class ApplicationStartupRunner implements CommandLineRunner {
    protected final Log logger = LogFactory.getLog(getClass());
 
    @Override
    public void run(String... args) throws Exception {
        logger.info("ApplicationStartupRunner run method Started !!");
    }
}
```
**2. 和@SpringBootApplication注解一起使用**
```java
@SpringBootApplication
public class SpringBootWebApplication extends SpringBootServletInitializer implements CommandLineRunner {
 
    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
        return application.sources(SpringBootWebApplication.class);
    }
 
    public static void main(String[] args) throws Exception {
        SpringApplication.run(SpringBootWebApplication.class, args);
    }
 
 
    @Override
    public void run(String... args) throws Exception {
        logger.info("Application Started !!");
    }
}
```
**用@Order注解去设置多个CommandLineRunner实现类的执行顺序**
```java
@Order(value=3)
@Component
class ApplicationStartupRunnerOne implements CommandLineRunner {
    protected final Log logger = LogFactory.getLog(getClass());
 
    @Override
    public void run(String... args) throws Exception {
        logger.info("ApplicationStartupRunnerOne run method Started !!");
    }
}
 
@Order(value=2)
@Component
class ApplicationStartupRunnerTwo implements CommandLineRunner {
    protected final Log logger = LogFactory.getLog(getClass());
 
    @Override
    public void run(String... args) throws Exception {
        logger.info("ApplicationStartupRunnerTwo run method Started !!");
    }
}
```
## 外部化配置
## profiles
## 日志
## 国际化
## Json
## 开发web应用
## 安全
## 关系数据库访问
## NoSql访问
## 缓存
## 消息
## 使用RestTemppalte访问REST服务
## 使用WebClient访问REST服务
## 验证
## 发邮件
## JTA分布式事务
## Hazelcast
## 日历
## spring集成
## spring会话
## 使用JMX监控
## 测试
## Websockets
## web服务
## 创建自己的自动化配置
## 支持Kotlin