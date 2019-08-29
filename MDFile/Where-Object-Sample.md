Filter Script 值是计算结果为 True 或 False 的脚本块，即由大括号 {} 括起来的一个或多个 Windows PowerShell 命令。 这些脚本块可能非常简单，但是创建它们需要了解有关 Windows PowerShell 的另一个概念，即比较运算符。 比较运算符比较其每一侧显示的项。 比较运算符以“-”字符开头，后跟名称。 基本比较运算符适用于几乎任何类型的对象。 更高级的比较运算符可能仅适用于文本或数组。

~~~ powershell
Get-WmiObject -Class Win32_SystemDriver | Where-Object -FilterScript {$_.State -eq 'Running'}
Get-WmiObject -Class Win32_SystemDriver | Where-Object -FilterScript {$_.State -eq "Running"} | Where-Object -FilterScript {$_.StartMode -eq "Auto"}
Get-WmiObject -Class Win32_SystemDriver | Where-Object -FilterScript {$_.State -eq "Running"} | Where-Object -FilterScript {$_.StartMode -eq "Manual"} | Format-Table -Property Name,DisplayName
Get-WmiObject -Class Win32_SystemDriver | Where-Object -FilterScript { ($_.State -eq 'Running') -and ($_.StartMode -eq 'Manual') } | Format-Table -Property Name,DisplayName
~~~

