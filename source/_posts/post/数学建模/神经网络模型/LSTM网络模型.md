---
title: LSTM网络模型
date: 2021-03-17
tags: []
categories: 
    - 数学建模
    - 神经网络模型
---

## LSTM网络模型

### 概述

传统神经网络在处理这一时刻的信息时，结果不会受到过去输入的信息的影响。举一个不恰当的例子，想象一下，我们在阅读文章的时候结合上下文才更能理解文章的含义，所以后来提出了递归神经网络（RNNs），来解决这一问题。

RNNs 的网络结构如下：

![picture 50](../../../../assets/%E6%95%B0%E5%AD%A6%E5%BB%BA%E6%A8%A1/%E7%A5%9E%E7%BB%8F%E7%BD%91%E7%BB%9C%E6%A8%A1%E5%9E%8B/LSTM%E7%BD%91%E7%BB%9C%E6%A8%A1%E5%9E%8B/4ed4ff5e45d8667ebf6299f7801d4b3f33ac819556f171d1e24cba01588e4d6d.png)  

将其展开等价于一个将历史信息不断地往后传递，每一时刻的信息都将影响下一次预测结果：

![picture 51](../../../../assets/%E6%95%B0%E5%AD%A6%E5%BB%BA%E6%A8%A1/%E7%A5%9E%E7%BB%8F%E7%BD%91%E7%BB%9C%E6%A8%A1%E5%9E%8B/LSTM%E7%BD%91%E7%BB%9C%E6%A8%A1%E5%9E%8B/f33e1667d4b4133afeddd9573fd9dba61933a2e5e2ac8af21235a1eec447fdd0.png)  

由于 RNNs 具有记忆的特性，对于前后相关联信息的学习任务有较重要的应用，比如：语音识别、语言模型、机器翻译等；

但是随着 RNNs 网络的深入应用，长时依赖问题（Long Term Dependencies problem）被发现了；

### 长时依赖问题

当我们在进行语句最后一个字的预测时：the clouds are in the sky。 RNNs 能够很好地解决这个问题，距离较短的数据对结果的影响还没被冲淡。

![picture 52](../../../../assets/%E6%95%B0%E5%AD%A6%E5%BB%BA%E6%A8%A1/%E7%A5%9E%E7%BB%8F%E7%BD%91%E7%BB%9C%E6%A8%A1%E5%9E%8B/LSTM%E7%BD%91%E7%BB%9C%E6%A8%A1%E5%9E%8B/b056de3de52d546896b6fe632f77f080f054f0ba29803b3069a29894a8f9c86b.png)  

但面对间隔比较长的预测问题时， RNNs 就开始变弱了，可以理解为在很久以前的事情到现在已经记不清了，所以无法对现在的状况进行有效的预判；

![picture 53](../../../../assets/%E6%95%B0%E5%AD%A6%E5%BB%BA%E6%A8%A1/%E7%A5%9E%E7%BB%8F%E7%BD%91%E7%BB%9C%E6%A8%A1%E5%9E%8B/LSTM%E7%BD%91%E7%BB%9C%E6%A8%A1%E5%9E%8B/41c9d8c4c787822152d8510454ce5b74f953a36b61a23c6d7c246102ad99337d.png)  

而长短期记忆网络模型（LSTMs）被设计出来，用于解决这个问题。

长短期记忆能够记住较长时刻的信息，而不损失短期信息的记忆，并会过滤过长时刻的记忆。

### LSTMs 网络结构

![picture 54](../../../../assets/%E6%95%B0%E5%AD%A6%E5%BB%BA%E6%A8%A1/%E7%A5%9E%E7%BB%8F%E7%BD%91%E7%BB%9C%E6%A8%A1%E5%9E%8B/LSTM%E7%BD%91%E7%BB%9C%E6%A8%A1%E5%9E%8B/7ce63cf49c80ed18138b8bb25f5af7349e9abd797167640f2dbe6976fc13b451.png)  

（作用原理还没弄清楚，等我学了更多的神经网络的知识在更新）
[参考资料](https://web.stanford.edu/class/cs379c/archive/2018/class_messages_listing/content/Artificial_Neural_Network_Technology_Tutorials/OlahLSTM-NEURAL-NETWORK-TUTORIAL-15.pdf)