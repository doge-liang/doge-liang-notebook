# 二、Spring Boot配置文件

## 1.配置文件

Spring Boot默认使用一个全局的配置文件
- application.properties
- application.yml

配置文件的作用：修改Spring Boot自动配置的默认值；

yml是YAML的缩写，以数据为中心，比xml、json跟适合做配置文件，[语法参考](http://www.yaml.org/)。
```yml
server:
  port:8081
```

```xml
<server>
	<port>
		8081
	</port>
<server>
```
## 2.YAML语法

### 1.基本语法
k：(空格)v：表示一对键值对（空格必须有）；  
以缩进控制层级关系，类似python  
```yml
server:
	port: 8081
	path: /hello
```
属性和值都是大小写敏感的；

### 2.值的写法

#### 字面量：普通得值（数字、字符串、布尔值）

k: v:字面量直接写；  
字符串默认不用加上引号；  
""：双引号不会转义特殊字符，特殊字符会输出本身意义；  
''：单引号会转义特殊字符，特殊字符最终变为一个字符串输出；  

#### 对象、Map（键值对）

k:v：在下一行写对象和属性和值的关系；注意缩进；
对象还是k:v的方式
```yml
friends:
	lastName: zhangsan
	age: 20
```
行内写法：
```yml
friends: {lastName: zhangsan,age: 18}
```
#### 数组

用-值表示数组中的一个元素
```yml
pets:
 - cat
 - dog
 - pig
```
行内写法：
```yml
pets: [cat,dog,pig]
```
## 3.获取配置文件值注入

配置文件：
```yml
server:
  port: 8081
  
person:
  name: zhangsan
  age: 18
  maps: {k1: v1,k2: v2}
  lists: [dog1,dog2,dog3]
  dog: 
    name: shit
    age: 233
```
javabean:
```java
/**
 *  将配置文件中配置的每一个属性的值映射到这个组件中，
 *  @ConfigurationProperties:告诉SpringBoot本类的所有属性和值将和配置文件中的相关配置进行一一映射；
 *  	prefix = "person":配置文件中的person标签和本类的属性和值一一映射；
 *  
 *  
 *  只有这个组件时容器中的组件，才能使用容器提供的ConfigurationProperties功能；
 *
 */
@Component
@ConfigurationProperties(prefix = "person")
public class Person {
	
	private String name;
	private Integer age;
	
	private Map<String, Object> maps;
	private List<Object> lists;
	private Dog dog;
```
我们可以导入配置文件处理器，以后编写配置就有提示了：
```xml
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-configuration-processor</artifactId>
            <optional>true</optional>
        </dependency>
```
使用properties文件导入时，如果出现乱码的情况，则修改File->settings->file encodings->Properties Files中Default encoding fo properties files修改为UTF-8 并勾选transparent native-to-ascii convertion  

#### @Value获取值和@ConfigurationProperties获取值比较

@ConfigurationProperties
- 批量注入配置文件中的属性
- 松散绑定，只要符合属性的模糊命名相符就能注入(例如last-name lastName)
- SpEL不支持
- JSR303数据校验支持，注入之前可以校验注入数据格式是否正确
- 复杂类型封装支持

@Value
- 单个注入
- 松散绑定不支持
- SpEL支持，可以注入表达式
- JSR303数据校验不支持
- 不支持复杂类型封装

配置文件yml和properties都能获取到值；  
如果说，我们只是在某个业务逻辑中需要获取一下配置文件中的某项值，使用@Value；  
如果说，我们专门编写了一个javaBean来和配置文件中的值映射，我们就直接使用@ConfigurationProperties  

#### 配置文件的数据校验

```java
@Component
@ConfigurationProperties(prefix = "person")
public class Person {

    @Email
    private String name;
    private Integer age;
    private Dog dog;
```

#### @PropertySource和@ImportResource

@PropertySource：加载指定的配置文件
```java
@PropertySource(value = {"classpath:person.properties"})
@Component
@ConfigurationProperties(prefix = "person")
public class Person {

//    @Email
    private String name;
    private Integer age;
    private Dog dog;
```
@ImportResource：导入Spring的配置文件，让配置文件生效；  
Spring Boot里面没有Spring的配置文件，我们自己编写的配置文件无法在Spring Boot中生效。  
```java
@ImportResource(value = {"classpath:beans.xml"})
@SpringBootApplication
public class springboot02configApplication {


    public static void main(String[] args) {

        SpringApplication.run(springboot02configApplication.class, args);

    }

}
```
Spring Boot不推荐像以前那样通过配置文件的方式添加组件，推荐通过全注解的方式添加组件；  
1. 配置类----配置文件  
2. 使用@Bean向容器中添加组件，组件id为方法名；  
```java
@Configuration
public class MyAppConfig {

    @Bean
    public HelloService helloService() {
        return new HelloService();
    }
}
```

## 4.配置文件占位符

### 1.随机数

```java
${random.value}、$random.int}、${random.long}、
${random.int(10)}、${random.int[1024,65536]}
```
### 2.属性获取占位符

```properties
person.name=张三丰
person.age=98
person.dog.name=${person.name}大狗${person.hello:hello}#:获取默认值
person.dog.age=100
```
### 5.Profile

#### 1.多profile文件：

我们在编写主配置文件的时候可以使用application-{profile}.properties/yml作为文件名:
例如:
- application-dev.properties、application-prod.properties
默认使用application.properties；

#### 2.多profile文档块模式(yml)：

```yml
server:
  port: 8081
Spring:
  profiles:
    active: dev
---
server:
  port: 8082
Spring:
  profiles: dev
---
server:
  prot: 8083
Spring:
  profiles: prod
```
#### 3.激活指定profile：

1. 在配置文件中指定spring.profiles.active=dev
2. 在命令行中指定 --spring.profiles.active=dev(优先级高)
3. 虚拟机参数 -Dspring.profiles.active=dev

### 6.配置文件加载位置

spring boot自动扫描文件路径:  
\-file:./config/  
\-file./  
\-classpath:/config/  
\-classpath:/  
以上顺序优先级**从高到低**，高优先级会**覆盖**低优先级内容；互补配置；  
项目打包后，可以在命令行通过spring.config.location修改默认加载路径，新的配置和原配置形成互补配置；  

### 7.外部配置的加载顺序

1. 命令行参数  
java -jar [jar包] --server.port=8088  
java -jar [jar包] --server.context-path=路径  
2. jar包外部的带profile的
3. jar包内部的带profile的
4. jar包外部的不带profile的
5. jar包内部的不带profile的
其他的配置来源参考[官方文档](https://docs.spring.io/spring-boot/docs/current/reference/html/boot-features-external-config.html)

### 8.自动配置原理

[配置文件能配置的属性参照](https://docs.spring.io/spring-boot/docs/current/reference/html/common-application-properties.html)

#### 自动配置原理：

> SpringBoot启动时加载主配置类，开启了自动配置功能@EnableAutoConfiguration  
> @EnableAutoConfiguration利用EnableAutoConfigurationImportSelector给容器中导入组件  
> - SpringFactoriesLoader.loadFactoryNames()
> - 扫描所有jar包类路径下，META-INF/spring.factories
> - 把扫描到的文件内容包装成properties对象
> - 从properties中获取到的EnableAutoConfiguration.class类(类名)对应的值，然后把他们添加进容器中

即，将类路径下META-INF/spring.factories里面配置的所有EnableAutoConfiguration的值加入到了容器中；  
```factories
# Auto Configure
org.springframework.boot.autoconfigure.EnableAutoConfiguration=\
org.springframework.boot.autoconfigure.admin.SpringApplicationAdminJmxAutoConfiguration,\
org.springframework.boot.autoconfigure.aop.AopAutoConfiguration,\
org.springframework.boot.autoconfigure.amqp.RabbitAutoConfiguration,\
org.springframework.boot.autoconfigure.batch.BatchAutoConfiguration,\
org.springframework.boot.autoconfigure.cache.CacheAutoConfiguration,\
org.springframework.boot.autoconfigure.cassandra.CassandraAutoConfiguration,\
org.springframework.boot.autoconfigure.cloud.CloudAutoConfiguration,\
org.springframework.boot.autoconfigure.context.ConfigurationPropertiesAutoConfiguration,\
org.springframework.boot.autoconfigure.context.MessageSourceAutoConfiguration,\
org.springframework.boot.autoconfigure.context.PropertyPlaceholderAutoConfiguration,\
org.springframework.boot.autoconfigure.couchbase.CouchbaseAutoConfiguration,\
org.springframework.boot.autoconfigure.dao.PersistenceExceptionTranslationAutoConfiguration,\
org.springframework.boot.autoconfigure.data.cassandra.CassandraDataAutoConfiguration,\
org.springframework.boot.autoconfigure.data.cassandra.CassandraRepositoriesAutoConfiguration,\
org.springframework.boot.autoconfigure.data.couchbase.CouchbaseDataAutoConfiguration,\
org.springframework.boot.autoconfigure.data.couchbase.CouchbaseRepositoriesAutoConfiguration,\
org.springframework.boot.autoconfigure.data.elasticsearch.ElasticsearchAutoConfiguration,\
org.springframework.boot.autoconfigure.data.elasticsearch.ElasticsearchDataAutoConfiguration,\
org.springframework.boot.autoconfigure.data.elasticsearch.ElasticsearchRepositoriesAutoConfiguration,\
org.springframework.boot.autoconfigure.data.jpa.JpaRepositoriesAutoConfiguration,\
org.springframework.boot.autoconfigure.data.ldap.LdapDataAutoConfiguration,\
org.springframework.boot.autoconfigure.data.ldap.LdapRepositoriesAutoConfiguration,\
org.springframework.boot.autoconfigure.data.mongo.MongoDataAutoConfiguration,\
org.springframework.boot.autoconfigure.data.mongo.MongoRepositoriesAutoConfiguration,\
org.springframework.boot.autoconfigure.data.neo4j.Neo4jDataAutoConfiguration,\
org.springframework.boot.autoconfigure.data.neo4j.Neo4jRepositoriesAutoConfiguration,\
org.springframework.boot.autoconfigure.data.solr.SolrRepositoriesAutoConfiguration,\
org.springframework.boot.autoconfigure.data.redis.RedisAutoConfiguration,\
org.springframework.boot.autoconfigure.data.redis.RedisRepositoriesAutoConfiguration,\
org.springframework.boot.autoconfigure.data.rest.RepositoryRestMvcAutoConfiguration,\
org.springframework.boot.autoconfigure.data.web.SpringDataWebAutoConfiguration,\
org.springframework.boot.autoconfigure.elasticsearch.jest.JestAutoConfiguration,\
org.springframework.boot.autoconfigure.freemarker.FreeMarkerAutoConfiguration,\
org.springframework.boot.autoconfigure.gson.GsonAutoConfiguration,\
org.springframework.boot.autoconfigure.h2.H2ConsoleAutoConfiguration,\
org.springframework.boot.autoconfigure.hateoas.HypermediaAutoConfiguration,\
org.springframework.boot.autoconfigure.hazelcast.HazelcastAutoConfiguration,\
org.springframework.boot.autoconfigure.hazelcast.HazelcastJpaDependencyAutoConfiguration,\
org.springframework.boot.autoconfigure.info.ProjectInfoAutoConfiguration,\
org.springframework.boot.autoconfigure.integration.IntegrationAutoConfiguration,\
org.springframework.boot.autoconfigure.jackson.JacksonAutoConfiguration,\
org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration,\
org.springframework.boot.autoconfigure.jdbc.JdbcTemplateAutoConfiguration,\
org.springframework.boot.autoconfigure.jdbc.JndiDataSourceAutoConfiguration,\
org.springframework.boot.autoconfigure.jdbc.XADataSourceAutoConfiguration,\
org.springframework.boot.autoconfigure.jdbc.DataSourceTransactionManagerAutoConfiguration,\
org.springframework.boot.autoconfigure.jms.JmsAutoConfiguration,\
org.springframework.boot.autoconfigure.jmx.JmxAutoConfiguration,\
org.springframework.boot.autoconfigure.jms.JndiConnectionFactoryAutoConfiguration,\
org.springframework.boot.autoconfigure.jms.activemq.ActiveMQAutoConfiguration,\
org.springframework.boot.autoconfigure.jms.artemis.ArtemisAutoConfiguration,\
org.springframework.boot.autoconfigure.flyway.FlywayAutoConfiguration,\
org.springframework.boot.autoconfigure.groovy.template.GroovyTemplateAutoConfiguration,\
org.springframework.boot.autoconfigure.jersey.JerseyAutoConfiguration,\
org.springframework.boot.autoconfigure.jooq.JooqAutoConfiguration,\
org.springframework.boot.autoconfigure.kafka.KafkaAutoConfiguration,\
org.springframework.boot.autoconfigure.ldap.embedded.EmbeddedLdapAutoConfiguration,\
org.springframework.boot.autoconfigure.ldap.LdapAutoConfiguration,\
org.springframework.boot.autoconfigure.liquibase.LiquibaseAutoConfiguration,\
org.springframework.boot.autoconfigure.mail.MailSenderAutoConfiguration,\
org.springframework.boot.autoconfigure.mail.MailSenderValidatorAutoConfiguration,\
org.springframework.boot.autoconfigure.mobile.DeviceResolverAutoConfiguration,\
org.springframework.boot.autoconfigure.mobile.DeviceDelegatingViewResolverAutoConfiguration,\
org.springframework.boot.autoconfigure.mobile.SitePreferenceAutoConfiguration,\
org.springframework.boot.autoconfigure.mongo.embedded.EmbeddedMongoAutoConfiguration,\
org.springframework.boot.autoconfigure.mongo.MongoAutoConfiguration,\
org.springframework.boot.autoconfigure.mustache.MustacheAutoConfiguration,\
org.springframework.boot.autoconfigure.orm.jpa.HibernateJpaAutoConfiguration,\
org.springframework.boot.autoconfigure.reactor.ReactorAutoConfiguration,\
org.springframework.boot.autoconfigure.security.SecurityAutoConfiguration,\
org.springframework.boot.autoconfigure.security.SecurityFilterAutoConfiguration,\
org.springframework.boot.autoconfigure.security.FallbackWebSecurityAutoConfiguration,\
org.springframework.boot.autoconfigure.security.oauth2.OAuth2AutoConfiguration,\
org.springframework.boot.autoconfigure.sendgrid.SendGridAutoConfiguration,\
org.springframework.boot.autoconfigure.session.SessionAutoConfiguration,\
org.springframework.boot.autoconfigure.social.SocialWebAutoConfiguration,\
org.springframework.boot.autoconfigure.social.FacebookAutoConfiguration,\
org.springframework.boot.autoconfigure.social.LinkedInAutoConfiguration,\
org.springframework.boot.autoconfigure.social.TwitterAutoConfiguration,\
org.springframework.boot.autoconfigure.solr.SolrAutoConfiguration,\
org.springframework.boot.autoconfigure.thymeleaf.ThymeleafAutoConfiguration,\
org.springframework.boot.autoconfigure.transaction.TransactionAutoConfiguration,\
org.springframework.boot.autoconfigure.transaction.jta.JtaAutoConfiguration,\
org.springframework.boot.autoconfigure.validation.ValidationAutoConfiguration,\
org.springframework.boot.autoconfigure.web.DispatcherServletAutoConfiguration,\
org.springframework.boot.autoconfigure.web.EmbeddedServletContainerAutoConfiguration,\
org.springframework.boot.autoconfigure.web.ErrorMvcAutoConfiguration,\
org.springframework.boot.autoconfigure.web.HttpEncodingAutoConfiguration,\
org.springframework.boot.autoconfigure.web.HttpMessageConvertersAutoConfiguration,\
org.springframework.boot.autoconfigure.web.MultipartAutoConfiguration,\
org.springframework.boot.autoconfigure.web.ServerPropertiesAutoConfiguration,\
org.springframework.boot.autoconfigure.web.WebClientAutoConfiguration,\
org.springframework.boot.autoconfigure.web.WebMvcAutoConfiguration,\
org.springframework.boot.autoconfigure.websocket.WebSocketAutoConfiguration,\
org.springframework.boot.autoconfigure.websocket.WebSocketMessagingAutoConfiguration,\
org.springframework.boot.autoconfigure.webservices.WebServicesAutoConfiguration
```
每一个这样的xxxAutoConfiguration类都是容器中的一个组件，都加入到容器中；用他们来做自动配置；  
每一个自动配置类进行自动配置功能；  
以**HttpEncodingAutoConfiguration**为例解释自动配置原理；
```java
@Configuration //表示这是一个配置类，与以前编写的配置文件一样，也可以给容器中添加组件
@EnableConfigurationProperties({HttpEncodingProperties.class}) //启动指定类的ConfigurationProperties功能；将配置文件对应的值和 httpEncodingProperties绑定起来；并把 HttpConfigurationProperties加入到ioc容器中；
@ConditionalOnWebApplication //Spring底层@Conditional注解，根据不同的条件，如果满足指定的条件，整个配置类里面的配置就会生效；判断当前应用是否是Web应用，如果是，当前配置生效；
@ConditionalOnClass({CharacterEncodingFilter.class}) //判断当前项目有没有这个类：CharacterEncodingFilter;SpringMVC中进行乱码解决的过滤器
@ConditionalOnProperty(
    prefix = "spring.http.encoding",
    value = {"enabled"},
    matchIfMissing = true
) //判断配置文件中是否存在某个配置，这里是spring.http.encoding.enabled;如果不存在，判断也是成立的(matchIfMissing=true)；
//即使配置文件中不配置spring.http.encoding.enabled=true，那么也是生效的。（默认生效）
public class HttpEncodingAutoConfiguration {

    //他已经和spring boot的配置文件映射了
    private final HttpEncodingProperties properties;

    //只有一个有参构造器的情况下，参数的值会从容器中获取
    public HttpEncodingAutoConfiguration(HttpEncodingProperties properties) {
        this.properties = properties;
    }

    @Bean //给容器中添加一个组件，这个组件的某些值需要从properties中获取；
    @ConditionalOnMissingBean({CharacterEncodingFilter.class}) //判断容器中没有组件CharacterEncodingFilter，如果没有就添加
    public CharacterEncodingFilter characterEncodingFilter() {
        CharacterEncodingFilter filter = new OrderedCharacterEncodingFilter();
        filter.setEncoding(this.properties.getCharset().name());
        filter.setForceRequestEncoding(this.properties.shouldForce(Type.REQUEST));
        filter.setForceResponseEncoding(this.properties.shouldForce(Type.RESPONSE));
        return filter;
    }
```
根据当前不同条件的判断，决定这个配置类是否生效；  
一但这个配置类生效；这个配置类就会给容器中添加各种组件；这些组件的的属性是从对应的properties类中获取的，这些类里面的每一个属性又是和配置文件绑定的；  
所有在配置文件中能配置的属性都是在xxxProperties类中封装着；配置文件能配置什么就可以参照某个功能对应的这个属性类
```java
@ConfigurationProperties(
    prefix = "spring.http.encoding"
) //从配置文件中获取指定的值和bean的属性进行绑定
public class HttpEncodingProperties {
```

**精髓**
1. SpringBoot启动会加载大量的配置类；
2. 我们看到我们需要的功能有没有SpringBoot默认写好的自动配置类；
3. 我们再来看这个自动配置类中到底配置了那些组件；（只要我们要用的组件有，就不需要再来配置了；
4. 给容器中自动配置类添加组件的时候，会从properties类中获取某些属性，我们可以在配置文件中指定这些属性的值；

xxxAutoConfiguration:自动配置类，给容器中添加组件  
xxxProperties:封装配置文件中的相关属性；

#### 细节

##### 1.@Conditional派生注解

作用：必须是@Conditional指定的条件成立，才给容器中添加组件，配置类里面的内容才会生效；
**自动配置类必须再一定的条件下才能生效；**


