---
title: LaTex常用符号写法
mathjax: true
tags:
  - 论文写法
categories:
  - article
  - 论文规范
date: 2020-01-01 00:00:00
---

## LaTex 常用数学符号

> Inline:
> $$ \sqrt{3x-1}+(1+x)^2 $$
>
> Block:
>
> $$
> f{x} = \int_{-\infty}^\infty
> \hat f\xi\,e^{2 \pi i \xi x}
> \,d\xi
> $$

### 上下标

- ^{}表示上标，\_{}表示下标，{}用来放数字字母

- example:$\quad$ $a_{1}$ $\quad$ $e^{-t}$ $\quad$ $b_{ij}^{3}$

### 平方根(square root)

- \sqrt[n]:n 表示开根数

- example:$\quad$$\sqrt{x}$ $\quad$ $\sqrt[3]{x^{2}}$

### 分数(fraction)

- \frac{...}{...}
- example:$\quad$$\frac{x^2}{k+1}$ $\quad$ $x^{\frac{2}{k+1}}$

### 向量(vector)

- \vec \overrightarrow \overleftarrow
- exmaple:$\quad$$\vec{a}$ $\quad$ $\overrightarrow{AB}$ $\quad$ $\overleftarrow{AB}$

### 积分(integral operator)

- \int\_{}^{}
- example:$\quad \int_{-\infty}^{\infty}$

### 求和运算符(sum operater)

- \sum
- example:$\quad$$\sum_{i=1}^{n}$

### 乘积运算符(product opertater)

- \prod
- example:$\quad$$\prod_{\epsilon}$

### 希腊字母对照表

\alpha \beta \gamma \sigma \omega \delta \pi \rho \epsilon \eta \lambda \mu \xi \tau \kappa \zeta \phi \chi \theta \iota o \upsilon \zeta \psi

$$
\alpha \beta \gamma \sigma \omega \delta \pi \rho \epsilon \eta \lambda \mu \xi \tau \kappa \zeta \phi \chi \theta \iota o \upsilon \zeta \psi
$$

| 输入                 | 符号                   |
| -------------------- | ---------------------- |
| \alpha               | $\alpha$               |
| \beta                | $\beta$                |
| \gamma               | $\gamma$               |
| \sigma               | $\sigma$               |
| \omega               | $\omega$               |
| \delta               | $\delta$               |
| \pi                  | $\pi$                  |
| \rho                 | $\rho$                 |
| \epsilon \varepsilon | $\epsilon \varepsilon$ |
| \eta                 | $\eta$                 |
| \lambda              | $\lambda$              |
| \mu                  | $\mu$                  |
| \xi                  | $\xi$                  |
| \tau                 | $\tau$                 |
| \kappa               | $\kappa$               |
| \zeta                | $\zeta$                |
| \phi                 | $\phi$                 |
| \chi                 | $\chi$                 |
| \theta               | $\theta$               |
| \iota                | $\iota$                |
| o                    | $o$                    |
| \upsilon             | $\upsilon$             |
| \psi                 | $\psi$                 |

### 常用数学符号

- 二元关系运算符
  $$
  \le  \ge  \ne  \approx  \sim  \subseteq  \in \ni \notin \circ \cdot \times  \div  \pm  \Rightarrow  \rightarrow  \infty  \partial  \angle  \triangle \forall \exists
  $$

> \le \ge \ne \approx \sim \subseteq \in \ni \notin \circ \cdot \times \div \pm \Rightarrow \rightarrow \infty \partial \angle \triangle \forall \exists \overbrace

- 离散数学相关
  $$\oplus $$

> \oplus

- 线性代数相关
  $$\dots \cdots \vdots \ddots$$

> \dots \cdots \vdots \ddots

- 微积分相关
  $$\partial$$

> \partial

- 关系运算符
  $$\le \ge \ne \approx \sim \lt \gt \leqslant \geqslant \nless \ngtr$$

> \le \ge \ne \approx \sim \lt \gt \leqslant \geqslant \nless \ngtr

- 常规运算符
  $$\times \div \circ \cdot \bull \pm$$

> \times \div \circ \cdot \bull \pm

- 上下括号
  $$
  \overbrace{ (a+b+...+z) }^{26} \underbrace{ (a+b+...+z) }_{26}
  $$

> \overbrace{} \underbrace{}

- 同余  
  $$a \equiv b \mod c$$

> a \equiv b \mod c$$

### 语句块的用法

`\begin{}`和`\end{}`表示语句块的开头和结尾，括号里面填写的是语句块需要渲染的情况；
`\tag{}`渲染公式后的符号；

例子：

- 分段函数：

$$
f(x) =
\begin{cases}
    \dfrac{\cos{x}}{x+\sin{x}} & x \geq 0 \\
    ax^2+bx+c & x \leq 0
\end{cases}\tag{4-4}
$$

- 矩阵、行列式：

$$
A=\left(
    \begin{matrix}
        a_1 & a_2 & a_3 \\
        a_4 & a_5 & a_6 \\
        a_7 & a_8 & a_9
    \end{matrix}
    \right)
    \times {B} = \text{Endless}
    \tag{4-1}
$$

#### 综合使用例子

$$
f(x)=a_0+\sum _{n=1}^{\infty } \left(a_n\cos \frac{ n \pi  x }{l}+ b_n \sin \frac{ n \pi  x }{l}\right)
$$

#### 其他细节

- 如何将式子强制放在符号下方
  - 若符号是事先定义的数学符号`\limits`
    $\lim \limits_{n \rightarrow \infty}(1 + \frac{1}{x})$
  - 若符号不是实现定义的数学符号`\mathop{}` `\limits`
    $\mathop{E} \limits^{\circ}$
