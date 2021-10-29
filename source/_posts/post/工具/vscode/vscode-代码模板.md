---
title: vscode-代码模板
date: 2020-05-31
tags: [vscode]
categories:
  - 工具
  - vscode
---

## vscode-代码模板

### 打开配置窗口

路径：File > Preferences > User Snippets

![picture 28](../../../../assets/%E5%B7%A5%E5%85%B7/vscode/vscode-%E4%BB%A3%E7%A0%81%E6%A8%A1%E6%9D%BF/eaa49c4b6792cb5091227b561aea6f77d0a2c20fa4333aa89b1552db49e0ddf6.png)

### 编写配置文件

实例：

```json
{
  "blog header": {
    "prefix": "blogheader",
    "body": [
      "---",
      "title: ${1:${TM_FILENAME_BASE}}",
      "date: ${CURRENT_YEAR}-${CURRENT_MONTH}-${CURRENT_DATE}",
      "tags: [$2]",
      "categories: ",
      "    - [$3]",
      "---",
      "# $0"
    ],
    "description": "insert blog header"
  }
}
```

下面说明各项作用：

#### prefix

触发前缀，代码模板的前置引导；

#### body

实际插入的代码片段，一行一个字符串，组成一个数组

##### 指针跳转顺序

`$1` , `$2` , 数字代表指针跳转顺序， `$0` ，代表最后指针所处的位置；

##### 默认值 placeholder

`${1: placeholder}` ，数字代表指针跳转顺序，后面的文字代表默认值；

##### 可选项 choice

`${1|one, two, three|}` ，数字代表指针跳转顺序，后面的各项代表可选的输入项；

##### 常用变量汇总

- 常用变量

  - `TM_SELECTED_TEXT` 当前选中内容或空字符串
  - `TM_CURRENT_LINE` 当前行内容
  - `TM_CURRENT_WORD` 光标处字符或空字符串
  - `TM_LINE_INDEX` 从 0 开始的行号
  - `TM_LINE_NUMBER` 从 1 开始的行号
  - `TM_FILENAME` 当前被编辑文档名
  - `TM_FILENAME_BASE` 当前被编辑文档名，没有后缀
  - `TM_DIRECTORY` 当前被编辑文档目录
  - `TM_FILEPATH` 当前被编辑文档全路径
  - `CLIPBOARD` 当前剪切板内容

- 日期和时间相关变量

  - `CURRENT_YEAR` 当前年
  - `CURRENT_YEAR_SHORT` 当前年后两位
  - `CURRENT_MONTH` 月份，两位数字表示，例如 02
  - `CURRENT_MONTH` \_NAME 月份全称，例如 'July'
  - `CURRENT_MONTH_NAME_SHORT` 月份简写 ，例如'Jul
  - `CURRENT_DATE` 某天
  - `CURRENT_DAY_NAME` 星期几， 例如'Monday')
  - `CURRENT_DAY_NAME_SHORT` 星期几的简写， 'Mon'
  - `CURRENT_HOUR` 小时，24 小时制
  - `CURRENT_MINUTE` 分钟
  - `CURRENT_SECOND` 秒数

还可以用正则表达式格式化输出

#### 补充说明

如果配置好后，代码模板没有生效，有可能时 vscode 的对应文件的 quickSuggestions 没开。
打开方式： `ctrl` + `shift` + `P` 在弹出的命令检索框上搜索 `settings json` 得到 vscode 的 settings.json 文档
在文档内插入：

```json
"[markdown]": {
    "editor.quickSuggestions": true
},
```

需要什么语言的支持，就在中括号内输入什么语言，还可以添加自定义的文件支持，比如对 `xxx.todo` ：

```json
"[todo]":{
    "editor.quickSuggestions": true
}
```
