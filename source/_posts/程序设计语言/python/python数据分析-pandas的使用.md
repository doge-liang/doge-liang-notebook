---
title: python数据分析-pandas的使用
date: 2020-05-28
tags: [程序设计语言, python, pandas]
categories: 
    - [程序设计语言]
    - [数据分析]
---
# python数据分析-pandas的使用
~~ 长期更新 ~~

## DataFrame操作

### 创建

### 选择

#### 相关函数
名(label)选择和位置(position)选择

1）loc，基于列label，可选取特定行（根据行index）； 
2）iloc，基于行/列的position； 
3）at，根据指定行index及列label，快速定位DataFrame的元素； 
4）iat，与at类似，不同的是根据position来定位的； 
5）ix，为loc与iloc的混合体，既支持label也支持position；

#### 注意事项
1）.loc,.iloc,.ix,只加第一个参数如.loc([1,2]),.iloc([2:3]),.ix[2]…则进行的是行选择 
2）.loc,.at，选列是只能是列名，不能是position 
3）.iloc,.iat，选列是只能是position，不能是列名 
4）df[]只能进行行选择，或列选择，不能同时进行列选择，列选择只能是列名。

```python
data['columnName1', 'columnName2'] # 列选择
data[0:10] # 行选择
data[data.index != 'Unknown'] # 条件选择，行选择
data[data.columns[5:]] # 条件选择，列选择
```

### 分片