---
title: python-matplotlib绘图
tags:
  - matplotlib
categories:
  - article
  - 程序设计语言
  - python
date: 2020-07-17 00:00:00
---

## python-matplotlib 绘图

- [python-matplotlib 绘图](#python-matplotlib-绘图)
  - [直方图](#直方图)

```Python
import matplotlib.pyplot as plt

fig = plt.figure()

ax = fig.add_subplot(1,1,1)
ax.set(xlim=[0.5, 4.5], ylim=[-2, 8], title='An Example Axes', ylabel='Y-Axis', xlabel='X-Axis')
plt.show()
```

效果如下：

![picture 20](../../../../assets/%E7%A8%8B%E5%BA%8F%E8%AE%BE%E8%AE%A1%E8%AF%AD%E8%A8%80/python/python-matplotlib%E7%BB%98%E5%9B%BE/3e4d360ece4700a8ddfb9ebcd608058ca250166636995b9c13650462980aff6f.png)

若要正常显示中文，则添加如下代码：

```Python
plt.rcParams['font.sans-serif']=['SimHei'] #用来正常显示中文标签
plt.rcParams['axes.unicode_minus']=False #用来正常显示负号
```

```Python
fig = plt.figure()

ax = fig.add_subplot(1,1,1)
ax.set(xlim=[0.5, 4.5], ylim=[-2, 8], title='这是标题', ylabel='这是Y轴', xlabel='这是X轴')
plt.show()
```

效果如下：

![picture 21](../../../../assets/%E7%A8%8B%E5%BA%8F%E8%AE%BE%E8%AE%A1%E8%AF%AD%E8%A8%80/python/python-matplotlib%E7%BB%98%E5%9B%BE/0cee40a047a1274c79ef175291888b2f489add944880aa852d7e7e1a1421cf05.png)

### 直方图

```Python
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

![picture 22](../../../../assets/%E7%A8%8B%E5%BA%8F%E8%AE%BE%E8%AE%A1%E8%AF%AD%E8%A8%80/python/python-matplotlib%E7%BB%98%E5%9B%BE/fbc8a69603c66302ff8275d07b048e6d61c2ecd88d95ec1d47b1d56b3a39258a.png)

加上图例和坐标轴：

```Python
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

![picture 23](../../../../assets/%E7%A8%8B%E5%BA%8F%E8%AE%BE%E8%AE%A1%E8%AF%AD%E8%A8%80/python/python-matplotlib%E7%BB%98%E5%9B%BE/5c396afe104712e3846bfa939c1d318e4766b3a1791f47487f8674423209906a.png)
