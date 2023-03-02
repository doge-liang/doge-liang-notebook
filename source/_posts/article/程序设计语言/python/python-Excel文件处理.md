---
title: Python学习-xlwt/xlrd
tags: []
categories:
  - article
  - 程序设计语言
  - python
date: 2019-10-10 00:00:00
---

## Python 学习-xlwt/xlrd

- [Python 学习-xlwt/xlrd](#python学习-xlwtxlrd)
  - [1.存 Excel 文件(对于数值型数据)](#1存excel文件对于数值型数据)
  - [2.读 Excel 文件(对于数值型数据)](#2读excel文件对于数值型数据)
  - [3.openpyxl](#3openpyxl)
  - [4.xlsxwriter](#4xlsxwriter)
    - [存 Excel 文件](#存excel文件)
  - [format 参数表](#format参数表)

### 1.存 Excel 文件(对于数值型数据)

```python
import xlwt

workbook = xlwt.Workbook(encoding='utf-8')
booksheet = workbook.add_sheet('Sheet 1', cell_overwrite_ok=True)
#存第一行cell(1,1)和cell(1,2)
booksheet.write(0,0,'存入内容')
booksheet.write(0,1,'存入内容')
#存第二行cell(2,1)和cell(2,2)
booksheet.write(1,0,'存入内容')
booksheet.write(1,1,'存入内容')
#存一行数据
rowdata = [43,56]
for i in range(len(rowdata)):
	booksheet.wirte(2,i,rowdata[i])
#保存workbook到文件系统内
workbook.save('test_xlwt.xls')

```

### 2.读 Excel 文件(对于数值型数据)

```python
import xlrd

workbook = xlrd.open_workbook(rddir)
print(workbook.sheet_names())
booksheet = workbook.sheet_by_index(0)
booksheet = workbook.sheet_by_name('Sheet 1')
#读单元格数据
cell_11 = booksheet.row_values(0,0)
cell_21 = booksheet.cell_value(1,0)
#读一行数据
row_3 = booksheet.row_values(2)
print(cell_11, cell_21,row_3)
```

### 3.openpyxl

1. 存 Excel 文件

   ```python
   from openpyxl import Workbook

   workbook = Workbook()
   booksheet = workbook.active #获取当前活跃的sheet,默认是第一个sheet
   #存第一行单元格cell(1,1)
   booksheet.cell(1,1).value = 6 #这个方法索引从1开始
   booksheet.cell("B1").value = 7
   #存一行数据
   BookSheet.append([11,87])
   #保存workbook到文件系统内
   workbook.save("test_openpyxl.xlsx")
   ```

2. 读 Excel 文件

   ```python
   from openpyxl import load_workbook

   workbook = load_workbook(rddir)

   #获取当前活跃的sheet，默认是第一个sheet
   booksheet = workbook.active sheets = workbook.get_sheet_names()

   #从名称获取sheet
   booksheet = workbook.get_sheet_by_name(sheets[0])

   rows = booksheet.rows
   columns = booksheet.columns

   #迭代所有行
   for row in rows:
       line = [col.value for col in row]

   #通过坐标读取值
   cell_11 = booksheet.cell('A1').value
   cell_11 = booksheet.cell(row=1, column=1).value
   ```

### 4.xlsxwriter

#### 存 Excel 文件

```python
import xlsxwriter

#Create a workbook and add a worksheet.
workbook = xlsxwriter.Workbook('hello.xlsx')
worksheet = workbook.add_worksheet()

#Add a bold format to use to hightlight cells.
bold = workbook.add_format({'bold': True})

#Add a number format for cells with money.
money = workbook.add_format({'num_format': '$#,##0'})

#Write some data headers.
worksheet.write('A1', 'Item', bold)
worksheet.write('B1', 'Cost', bold)

# Some data we want to write to the worksheet.
expenses = (
    ['Rent', 1000],
    ['Gas',   100],
    ['Food',  300],
    ['Gym',    50],
)

# Start from the first cell below the headers.
row = 1
col = 0

# Iterate over the data and write it out row by row.
for item, cost in (expenses):
    worksheet.write(row, col,     item)
    worksheet.write(row, col + 1, cost, money)
    row += 1

# Write a total using a formula.
worksheet.write(row, 0, 'Total',       bold)
worksheet.write(row, 1, '=SUM(B2:B5)', money)

workbook.close()
```

### format 参数表

| Category   | Description      | Property         | Method Name          |
| ---------- | ---------------- | ---------------- | -------------------- | ------------------- |
| Font       | Font type        | font_name'       | set_font_name()      |
|            | Font size        | 'font_size'      | set_font_size()      |
|            | Font color       | 'font_color'     | set_font_color()     |
|            | Bold             | 'bold'           | set_bold()           |
|            | Italic           | 'italic'         | set_italic()         |
|            | Underline        | 'underline'      | set_underline()      |
|            | Strikeout        | 'font_strikeout' | set_font_strikeout() |
|            | Super/Subscript  | 'font_script'    | set_font_script()    |
| Number     | Numeric          | format           | 'num_format'         | set_num_format()    |
| Protection | Lock cells       | 'locked'         | set_locked()         |
|            | Hide formulas    | 'hidden'         | set_hidden()         |
| Alignment  | Horizontal align | 'align'          | set_align()          |
|            | Vertical align   | 'valign'         | set_align()          |
|            | Rotation         | 'rotation'       | set_rotation()       |
|            | Text wrap        | 'text_wrap'      | set_text_wrap()      |
|            |                  | Reading order    | 'reading_order'      | set_reading_order() |
|            | Justify last     | 'text_justlast'  | set_text_justlast()  |
|            | Center across    | 'center_across'  | set_center_across()  |
|            | Indentation      | 'indent'         | set_indent()         |
|            | Shrink to fit    | 'shrink'         | set_shrink()         |
| Pattern    | Cell pattern     | 'pattern'        | set_pattern()        |
|            | Background color | 'bg_color'       | set_bg_color()       |
|            | Foreground color | 'fg_color'       | set_fg_color()       |
| Border     | Cell border      | 'border'         | set_border()         |
|            | Bottom border    | 'bottom'         | set_bottom()         |
|            | Top border       | 'top'            | set_top()            |
|            | Left border      | 'left'           | set_left()           |
|            | Right border     | 'right'          | set_right()          |
|            | Border color     | 'border_color'   | set_border_color()   |
|            | Bottom color     | 'bottom_color'   | set_bottom_color()   |
|            | Top color        | 'top_color'      | set_top_color()      |
|            | Left color       | 'left_color'     | set_left_color()     |
|            | Right color      | 'right_color'    | set_right_color()    |
