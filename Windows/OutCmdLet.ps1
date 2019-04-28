# 错误的示范
Get-Process | Out-Host -Paging | Format-List
# 报错如下
'''
Handles  NPM(K)    PM(K)      WS(K)     CPU(s)     Id  SI ProcessName
-------  ------    -----      -----     ------     --  -- -----------
    276      15     2512      11724       0.17  12812   1 360bdoctor
    947     116   126700      12304     365.53   1944   1 360EntClient
   1812     160   102612      25652              3180   0 360EntClient
    480      29    78628      71696      17.14   4384   1 360se
   1581      90    90244     137328      71.61   8780   1 360se
    293      27    34608      34520       0.77  17812   1 360se
    340      47    67108      77092      36.25  18832   1 360se
<SPACE> 下一页；<CR> 下一行；Q 退出out-lineoutput : 未实现该方法或操作。
所在位置 D:\worklist\GitHub\PowershellScript\Windows\OutCmdLet.ps1:2 字符: 1
+ Get-Process | Out-Host -Paging | Format-List
+ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : NotSpecified: (:) [out-lineoutput], NotImplementedException
    + FullyQualifiedErrorId : System.NotImplementedException,Microsoft.PowerShell.Commands.OutLineOutputCommand
'''
# 原因：Out-Host cmdlet 直接将数据发送到控制台，因此 Format-List 命令绝不会收到任何要进行格式化的内容。

# 正确的范例

PS> Get-Process | Format-List | Out-Host -Paging
'''
Id      : 2888
Handles : 101
CPU     : 0.046875
Name    : alg
...

Id      : 740
Handles : 612
CPU     : 211.703125
Name    : explorer

Id      : 2560
Handles : 257
CPU     : 3.015625
Name    : explorer
...
<SPACE> next page; <CR> next line; Q quit
'''
# 默认情况下，Windows PowerShell 将数据发送到主机窗口，这正是 Out-Host cmdlet 的用途。
# Out-Host cmdlet 的主要用途是对数据进行分页，如前面所述。 例如，下面的命令使用 Out-Host 对 Get-Command cmdlet 的输出进行分页：
Get-Command | Out-Host -Paging
Get-Command | more

# 放弃输出
Get-Command | Out-Null

# Out-Null cmdlet 不会放弃错误输出
<#
PS> Get-Command Is-NotACommand | Out-Null
Get-Command : 'Is-NotACommand' is not recognized as a cmdlet, function, operabl
e program, or script file.
At line:1 char:12
+ Get-Command  <<<< Is-NotACommand | Out-Null
#>

# 打印数据out-printer（可以是物理打印机，也可以不是物理打印机）

Get-Command Get-Command | Out-Printer -Name 'Microsoft Office Document Image Writer'

# 保存数据（Out-File）

Get-Process | Out-File -FilePath C:\temp\processlist.txt
Get-Process | Out-File -FilePath C:\temp\processlist.txt -Encoding ASCII
Get-Command | Out-File -FilePath c:\temp\output.txt -Width 2147483647




