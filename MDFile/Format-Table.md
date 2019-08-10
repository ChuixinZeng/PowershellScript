我们在使用Format-Table去显示输出信息的时候，通常会发现如果某个属性字段比较长，则无法正常全部显示，如下。

~~~ powershell
PS> **Get-Process -Name powershell | Format-Table -Property Company,Name,Id,Path -AutoSize**

 

Company               Name         Id Path

------

Microsoft Corporation powershell 2836 C:\Program Files\Windows PowerShell\v1...
~~~

这里面涉及到一个很重要的细节是，**Format-Table 命令假定属性距离属性列表的开头越近，则该属性越重要。** 因此，它会尝试完整显示离列表开头最近的那些属性。 如果 Format-Table 命令无法显示所有属性，它将从显示中删除某些列，并发出警告。 如果你使名称变成列表中的最后一个属性，便可以看到这一行为：

~~~ powershell
PS> **Get-Process -Name powershell | Format-Table -Property Company,Path,Id,Name -AutoSize**

 

WARNING: column "Name" does not fit into the display and was removed.

 

Company               Path                                                    I

​                                                                              d

------

Microsoft Corporation **C:\Program Files\Windows PowerShell\v1.0\powershell.exe** 6
~~~

你还可以通过使用 Wrap 参数让较长的 Format-Table 数据在其显示列中自动换行。 仅使用 Wrap 参数不一定会实现所需的操作，因为如果你不同时指定 AutoSize，它会使用默认设置：

 ~~~ powershell
PS> **Get-Process -Name powershell | Format-Table -Wrap -Property Name,Id,Company,Path**

 

Name                                 Id               Company                                   Path

------

powershell                         2836       Microsoft Corporati C:\Program Files\Wi

​                                                                   on                  ndows PowerShell\v1.0\powershell.exe
 ~~~

使用 Wrap 参数的一个优点是基本不会减慢进程速度。 如果你对大型目录系统执行递归文件列表，那么如果你使用 AutoSize，可能得耗用大量时间和内存，才能显示第一批输出项。

如果你并不关心系统负载，那么结合使用 AutoSize 和 Wrap 参数则会获得良好的效果。

~~~ powershell
PS> **Get-Process -Name powershell | Format-Table -Wrap -AutoSize -Property Name,Id,Company,Path**

 

Name         Id Company               Path

------

powershell 2836 Microsoft Corporation C:\Program Files\Windows PowerShell\v1.0\

​                                      powershell.exe
~~~

如果你先指定最宽的列，则某些列可能无法显示，因此最安全的做法是先指定最小的数据元素。 在下面的示例中，我们首先指定特别宽的路径元素，甚至使用自动换行，但仍丢失了最后的名称列：

~~~ powershell
PS> **Get-Process -Name powershell | Format-Table -Wrap -AutoSize -Property Path,Id,Company,Name**

 

**WARNING: column "Name" does not fit into the display and was removed.**

 

Path                                                      Id Company

------

C:\Program Files\Windows PowerShell\v1.0\powershell.exe 2836 Microsoft Corporat

​                                                             ion
~~~