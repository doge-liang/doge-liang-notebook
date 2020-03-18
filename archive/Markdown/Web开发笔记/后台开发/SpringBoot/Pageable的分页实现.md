```java
public Page<?> list?(conditionDTO condition) {
	Pageable pageable = PageRequest.of(pageIndex, pageSize);
	page<?> page = repository.findAll(new Specification<?>() {
		@Override
		public Predicate toPredicate(Root<?> root, CriteriaQuery<?> query, CriteriaBuilder criteriaBuilder) {
			// list用于添加查询条件
			List<Predicate> list = new ArrayList<Predicate>();
	
			// AND条件
			JSONObject condition = queryCondition.getCondition();
	
			// 名称关键字
			if (Objects.nonNull(condition) && Strings.isNotBlank(condition.getString("keyword"))) {
				list.add(criteriaBuilder.like(root.get("name").as(String.class), "%" + condition.getString("keyword").trim() + "%"));
			}
	
			Predicate[] p = new Predicate[list.size()];
			return criteriaBuilder.and(list.toArray(p));
		}
	}, pageable);
return page;
}
```
可以使用lambda表达式实现，但这样更有可读性。

