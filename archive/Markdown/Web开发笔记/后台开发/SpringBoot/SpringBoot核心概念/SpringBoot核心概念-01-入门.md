# 一、Spring Boot 入门
[官方各个版本文档](https://docs.spring.io/spring-boot/docs/)
## 1.Spring Boot 简介
> Spring Boot 是一个简化Spring应用开发的一个框架；  
> Spring应用技术栈的整合；  
> J2EE开发的一站式解决方案；

## 2.微服务
一种架构风格  
一个应用应该是一组小型服务的组合；  
每一个小型服务可以通过HTTP的方式进行沟通；  
区别于单体应用；  
单体应用：All in one；单一程序的所有功能放到单一进程中，通过在多台服务器上复制这个单体，进行负载均衡；  
  
微服务的每一个功能单元都是可以独立升级替换的独立软件单元。  

详细参照[martinfowler微服务文档](https://martinfowler.com/articles/microservices.html)

## 3.环境准备
> Maven 3.3.9
> Eclipse 2018
> jdk 1.8
> SpringBoot 1.5.9

### Maven安装
- 去官网下载Maven相应版本的[安装包](https://archive.apache.org/dist/maven/maven-3/)  
- 解压后配置环境变量MAVEN_HOME为解压后文件的地址。  
- 在Eclipse里面配置用户自定义的Maven，Window->Preferences->Maven->Installations->Add，选择自己解压的Maven jar包。  
- 修改Eclipse的User Setting，将User Settings修改为Maven/conf/settings.xml；  
- 修改settings.xml文件，添加localRepository节点，将值设置为自定义的repository。

## 4.SpringBoot Hello world编程
完成功能：浏览器发送一个hello请求，服务器接受请求，响应helloworld。  

### 第一步 创建Maven project
### 第二步 导入spring boot依赖
``` xml
<parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>2.1.6.RELEASE</version>
</parent>

    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId	>
        </dependency>
    </dependencies>
```
### 第三步 编写主程序
```java
package com.learningspringboot;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;


@SpringBootApplication
public class HelloWorldMainApplication {
	
	public static void main(String[] args) {
		
		SpringApplication.run(HelloWorldMainApplication.class);
	}

}

```
### 第四步 编写Controller、Service
```java
package com.learningspringboot.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class HelloController {

	@ResponseBody
	@RequestMapping("/hello")
	public String Hello() {
		return "Hello World!";
	}
}

```
### 第五步 部署应用
导入插件：
```xml
<build>
    <!-- 这个插件可以将应用打包成一个可执行的jar包 -->
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>
```
可以直接将程序打成jar包，直接用java -jar 文件名，来运行。

## 5、Hello World实验分析

### 1.POM文件分析

#### 1.Parent
```xml
<parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>1.5.9.RELEASE</version>
</parent>

他的父项目是spring-boot-dependencies：
<parent>
	<groupId>org.springframework.boot</groupId>
	<artifactId>spring-boot-dependencies</artifactId>
	<version>1.5.9.RELEASE</version>
	<relativePath>../../spring-boot-dependencies</relativePath>
</parent>
这个父项目真正管理Spring Boot应用里面所有依赖版本；
```
之后我们导入依赖默认是不需要写版本的；

#### 2.导入的依赖

```xml
    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
    </dependencies>
```
**spring-boot-starter**-web:  
spring-boot-starter:场景的启动器；帮我们导入了web模块需要正常运行所需要的全部组件。

Spring Boot将所有的功能场景都抽取出来，做成一个个的starter，只需要在需要时导入相应的starter启动器即可。

### 2.主程序类

```java
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class HelloWorldMainApplication {
	
	public static void main(String[] args) {
		
		SpringApplication.run(HelloWorldMainApplication.class);
	}

}
```
**@SpringBootApplication**: Spring Boot应用标注在某个类上说明这个类是SpringBoot的主配置类，SpringBoot就应该运行在这个类的main方法案例启动SpringBoot应用。  
```java
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
@Documented
@Inherited
@SpringBootConfiguration
@EnableAutoConfiguration
@ComponentScan(excludeFilters = {
		@Filter(type = FilterType.CUSTOM, classes = TypeExcludeFilter.class),
		@Filter(type = FilterType.CUSTOM, classes = AutoConfigurationExcludeFilter.class) })
public @interface SpringBootApplication {
```
- @**SpringBootConfiguration**:注解某个类是Spring Boot的主配置类，是spring boot的入口；  
	- @**Configuration**:注解某个类是配置类；  
	配置类-----配置文件(xml)；配置类也是容器中的一个组件；@Component  

- @**EnableAutoConfiguration**:开启自动配置功能；  
过去我们需要配置的东西，Spring Boot帮我们自动配置；  
	
```java
@AurImport(AutoConfigurationPackages.Registrar.class)
public @interface AutoConfigurationPackage {toConfigurationPackage
@Import(EnableAutoConfigurationImportSelector.class)
public @interface EnableAutoConfiguration {
```
- @**AutoConfigurationPackage**:自动配置包：
```java
@Import(AutoConfigurationPackages.Registrar.class)
public @interface AutoConfigurationPackage {
```
- @**Import**(AutoConfigurationPackages.Registrar.class):Spring的底层注解,@Import，给容器中导入一个组件；这里导入的组件是AutoConfigurationPackages.Registrar.class;  
- AutoConfigurationPackages.Registrar.class:将主配置类(@SpringBootApplicaition标注的类)所在的包以及所有子包里面的所有组件扫描到Spring容器内。  

@Import(EnableAutoConfigurationImportSelector.class):导入组件选择器；  
将所有导入的组件以全类名的方式返回；这些组件会添加到容器中；  
	
## 6、使用Spring Initializer快速创建Spring Boot项目

IDE都支持Spring项目创建向导，利用向导可以快速创建Spring Boot项目；
选择所需模块，向导就会自动联网创建Spring Boot项目；
默认生成的SPringl Boot项目：
- 主程序生成完成，我们只需要写业务逻辑；
- resource目录结构：
	- static：保存所有的静态资源（图片、CSS、js）
	- templates：保存所有的模板页面（Spring Boot默认jar包使用嵌入式的Tomcat，默认不支持jsp页面）可以使用模板引擎（freemarker、thymeleaf）
	- application.properties：Spring Boot应用配置文件，可以修改默认配置（比如端口号）


