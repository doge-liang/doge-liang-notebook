---
title: python-matplotlib绘图
date: 2020-07-17
tags: [python, 绘图]
categories: 

    - [matplotlib]

---

## python-matplotlib绘图

``` Python
import matplotlib.pyplot as plt

fig = plt.figure()

ax = fig.add_subplot(1,1,1)
ax.set(xlim=[0.5, 4.5], ylim=[-2, 8], title='An Example Axes', ylabel='Y-Axis', xlabel='X-Axis')
plt.show()
```

效果如下：

![picture 3](assets/a4aeadf6be5e779f6ea33e19a544fd033234ea4f5587b87c1e0915e29f44fc16.png)  

若要正常显示中文，则添加如下代码：

``` Python
plt.rcParams['font.sans-serif']=['SimHei'] #用来正常显示中文标签
plt.rcParams['axes.unicode_minus']=False #用来正常显示负号
```

``` Python
fig = plt.figure()

ax = fig.add_subplot(1,1,1)
ax.set(xlim=[0.5, 4.5], ylim=[-2, 8], title='这是标题', ylabel='这是Y轴', xlabel='这是X轴')
plt.show()
```

效果如下：

![picture 4](assets/b9a67b141c67dbf8ec0621412b1b72701628eeb76e037d5c1e14202a1450a019.png)  

### 直方图

``` Python
np.random.seed(int(time.time()))
x = np.arange(5)
y = np.random.randn(5)
y
fig, axes = plt.subplots(ncols=2, figsize=plt.figaspect(1./2))

# rgb 方式上色，(105, 35, 131)/255
vert_bars = axes[0].bar(x, y, color=(0.411765, 0.137255, 0.513725), align='center')
horiz_bars = axes[1].barh(x, y, color='lightblue', align='center')
#在水平或者垂直方向上画线
axes[0].axhline(0, color='gray', linewidth=2)
axes[1].axvline(0, color='gray', linewidth=2)
plt.show()
```

效果如下：

![picture 5](assets/4e452927c609b689d69894a6cd06aa71ffb219304ef4dfb321beac24cf43b41e.png)  

加上图例和坐标轴：

``` Python
np.random.seed(int(time.time()))
x = np.arange(5)
y = np.random.randn(5)
y
fig, axes = plt.subplots(ncols=2, figsize=plt.figaspect(1./2))

# 添加坐标轴信息
axes[0].set(xlim=[0.5, 4.5], ylim=[-2, 8], title='测试图', ylabel='随机量', xlabel='时间')
axes[1].set(xlim=[0.5, 4.5], ylim=[-2, 8], title='测试图', ylabel='随机量', xlabel='时间')

# rgb 方式上色，(105, 35, 131)/255
vert_bars = axes[0].bar(x, y, color=(0.411765, 0.137255, 0.513725), align='center', label='随机量')
horiz_bars = axes[1].barh(x, y, color='lightblue', align='center', label='随机量')

# 应用图例
axes[0].legend()
axes[1].legend()

#在水平或者垂直方向上画线
axes[0].axhline(0, color='gray', linewidth=2)
axes[1].axvline(0, color='gray', linewidth=2)
plt.show()
```

效果如下：

![picture 6](assets/486e56b4f1822a2b74b724b72cb1bcaf7610b7acfa7d9b8689b29a1d34602264.png)  
