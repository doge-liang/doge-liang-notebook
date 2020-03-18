# Springboot+JPA问题合集

## 关联查询

### 解决关联表的被动级联查询问题

问题描述：我们有两个实体：项目、任务，每个项目对应多个任务，实体定义如下：
```java
@Data
@Entity
public class project {
    // ...other properties
    @OneToMany(mappedBy = "taskParent", cascade = {CascadeType.MERGE, CascadeType.REFRESH})
    private List<TaskDO> taskList;
    // ...other properties
}
```

```java
public class task {
	// ...other properties
    @ManyToOne(cascade = {CascadeType.MERGE, CascadeType.REFRESH}, optional = false)
    @JoinColumn(name = "project_id", nullable = false, updatable = false)
    private ProjectDO taskParent;
	// ...other properties
}
```
当我们执行查询时，查找project实体，会将taskList也一并查出来，任务也同理；而有时我们也不需要将两表并查；

解决方案：目前我使用的解决方法是在方法中添加`@JSONField(serialize=false)`来解决的；具体添加什么注解取决于项目的Springboot所使用的默认Json解析包：

alibaba的fastjson使用`@JSONField(serialize=false)`

默认的jackson使用`@JsonIgnore`或者`@JsonBackRerference`这里需要一些JPA的自动序列化和反序列化知识才能理解；
