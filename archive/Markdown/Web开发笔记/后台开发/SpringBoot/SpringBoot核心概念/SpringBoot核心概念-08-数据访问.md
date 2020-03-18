# 八、数据访问

## 1.jdbc

```xml
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-jdbc</artifactId>
        </dependency>
```

```properties
spring.datasource.username=root
spring.datasource.password=123456
spring.datasource.url=jdbc:mysql://34.201.77.48:3307/spring_boot
spring.driver-class-name=com.mysql.cj.jdbc.Driver
```
SpringBoot1.5版本使用的默认数据源是`org.apache.tomcat.jdbc.pool.DataSource`  
SpringBoot2.0版本使用的默认数据源是`com.zaxxer.hikari.HikariDataSource`  

自动配置原理：  
1. 参考`DataSourceConfiguration`，根据配置创建数据源，默认使用Tomcat连接池（2.0为Hikari)；可以使用`spring.datasource.type`自定义数据源类型；  
2. spring boot默认支持数据源：  

```java
org.apache.tomcat.jdbc.pool.DataSource
com.zaxxer.hikari.HikariDataSource
org.apache.commons.dbcp2.BasicDataSource
```

3. 自定义数据类型  
```java
	/**
	 * Generic DataSource configuration.
	 */
	@Configuration
	@ConditionalOnMissingBean(DataSource.class)
	@ConditionalOnProperty(name = "spring.datasource.type")
	static class Generic {

		@Bean
		public DataSource dataSource(DataSourceProperties properties) {
			//使用DataSourceBuilder创建数据源，利用反射创建相应type的数据源，并且绑定相应的属性
			return properties.initializeDataSourceBuilder().build();
		}

	}
```

4. DataSourceInitializerInvoker：（2.0版本）  
```java
/**
 * Bean to handle {@link DataSource} initialization by running {@literal schema-*.sql} on
 * {@link InitializingBean#afterPropertiesSet()} and {@literal data-*.sql} SQL scripts on
 * a {@link DataSourceSchemaCreatedEvent}.
 *
 * @author Stephane Nicoll
 * @see DataSourceAutoConfiguration
 */
class DataSourceInitializerInvoker implements ApplicationListener<DataSourceSchemaCreatedEvent>, InitializingBean {
```
通过执行`data-*.sql`和`schema-*.sql`为名的sql脚本，就可以完成对数据库的数据操作了。默认加载文件名为`data.sql`、`data-all.sql`和`schema.sql`、`schema-all.sql`。文件名可以用配置文件修改，属性类型为List。

```yml
spring:
	datasource:
		schema:
			- classpath: xxx-xxx.sql
			- classpath: xxx-xxx
```
5. 操作数据库

自动配置了jdbcTemplate操作数据库。


```java
@Controller
public class dataController {

    @Autowired
    JdbcTemplate jdbcTemplate;

    @ResponseBody
    @GetMapping("/query")
    public Map<String, Object> map(){
        List<Map<String, Object>> list = jdbcTemplate.queryForList("select * From schema");
        return list.get(0);
    }
}
```

## 2.整合Druid数据源

```java
@Configuration
public class DruidConfig {

    @ConfigurationProperties(prefix = "spring.datasource")
    @Bean
    public DataSource druid() {
        return new DruidDataSource();
    }


    //配置Druid的监控
    //1.配置一个管理后台的Servlet
    @Bean
    public ServletRegistrationBean statViewServlet(){
        ServletRegistrationBean bean = new ServletRegistrationBean(new StatViewServlet(), "/druid/*");
        Map<String,String> initParams = new HashMap<>();

        initParams.put("loginUsername", "admin");
        initParams.put("loginPassword", "123456");
        initParams.put("allow", "");

        bean.setInitParameters(initParams);
        return bean;
    }

    //2.配置一个Web监控的filter
    @Bean
    public FilterRegistrationBean webStatFilter() {
        FilterRegistrationBean bean = new FilterRegistrationBean();
        bean.setFilter(new WebStatFilter());

        Map<String,String> initParams = new HashMap<>();
        initParams.put("exclusions","*.js, *.css,/druid/*");

        bean.setInitParameters(initParams);

        bean.setUrlPatterns(Arrays.asList("/*"));

        return bean;
    }
}

```

```yml

spring:
  datasource:
    username: root
    password: 123456
    driver-class-name: com.mysql.cj.jdbc.Driver
    url: jdbc:mysql://***.***.***.***:****/jpa
    type: com.alibaba.druid.pool.DruidDataSource
    #数据源其他配置
    initialSize: 5
    minIdle: 5
    maxActive: 20
    maxWait: 60000
    timeBetweenEvictionRunsMillis: 60000
    minEvictableIdleTimeMillis: 300000
    validationQuery: SELECT 1 FROM DUAL
    testWhileIdle: true
    testOnBorrow: false
    testOnReturn: false
    poolPreparedStatements: true
    #配置监控统计拦截的filters，去掉后监控界面sql无法统计，'wall'用于防火墙  
    filters: stat,wall,log4j
    maxPoolPreparedStatementPerConnectionSize: 20
    useGlobalDataSourceStat: true
    connectionProperties: druid.stat.mergeSql=true;druid.stat.slowSqlMillis=500
#jpa
  jpa:
    hibernate:
      #开启自动更新表结构
      ddl-auto: update
    #开启sql语句显示
    show-sql: true

```

## 3.整合mybatis

1. 配置数据源相关属性（见上一节Druid）
2. 数据库建表
3. 创建JavaBean


## 4.注解版(Mybatis)

```java
@Mapper
public interface DepartmentMapper {

    @Select("select * from department where id=#{id}")
    public Department getDeptById(Integer id);

    @Delete("delete * from department where id=#{id}")
    public int deleteDeptById(Integer id);

    @Options(useGeneratedKeys = true, keyProperty = "id")
    @Insert("insert into department(departmentName) values(#{departmentName})")
    public int insertDept(Department department);

    @Update("update department set departmentName=#{departmentName} where id=#{id}")
    public int updateDept(Department department);
}
```

批量添加`@Mapper`
```java
@MapperScan(value = "com.myspringboot.springboot01data.mapper")
@SpringBootApplication
public class SpringBoot07DataApplication {

```

## 5.配置文件版(Mybatis)

```yml
mybatis:
  config-location: classpath:mybatis/mybatis-config.xml
  mapper-locations: classpath:mybatis/mapper/*.xml
```


## 6.整合JPA

JPA:ORM(Object Relational Mapping):
1. 编写一个实体类(bean)和数据表进行映射，并且配置好映射关系；
```java
//配置映射关系，使用JPA注解
@Data //使用lombok插件可以省略构造方法和相关的Getter、Setter方法
@Entity //告诉JPA这是一个实体类
@Table(name = "tbl_user") //@Table来指定和那个数据表对应；如果省略默认表名就是user；
public class User {
    @Id //这是一个主键
    @GeneratedValue(strategy = GenerationType.IDENTITY) //自增主键
    private Integer id;

    @Column(name = "last_name", length = 50) //这是和数据表对应的一个列
    private String lastname;

    @Column //省略默认列名就是属性名
    private String email;
```
2. 编写一个DAO接口来操作实体类对应的数据表(Repository)；

```java
public interface UserRepository extends JpaRepository<User, Integer> {
	//这里可以编写自定义的SQL语句
}
```
```yml
Spring:
  jpa:
    hibernate:
      ddl-auto: update
    show-sql: true
```

### 另注

对于团队开发项目，我们可以将应用分层，并每一层编写相应的BaseAPI然后再进行拓展，编写更详细的API。


