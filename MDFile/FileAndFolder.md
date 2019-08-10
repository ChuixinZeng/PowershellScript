**（一）查询** 

使用 Get-ChildItem 直接获取某个文件夹中的所有项目。 添加可选的 Force 参数以显示隐藏项或系统项。为了显示包含的项，你还需要指定 -Recurse 参数。 （这可能需要相当长的时间才能完成。）

~~~ powershell
Get-ChildItem -Path C:\ -Force

Get-ChildItem -Path C:\ -Force -Recurse
~~~

Get-ChildItem 可以使用其 Path、Filter、Include 和 Exclude 参数筛选项，但那些通常只基于名称。 还可以通过使用 Where-Object 基于项的其他属性执行复杂的筛选。

~~~ powershell
Get-ChildItem -Path $env:ProgramFiles -Recurse -Include *.exe | Where-Object -FilterScript {($_.LastWriteTime -gt '2005-10-01') -and ($_.Length -ge 1mb) -and ($_.Length -le 10mb)}
~~~

还可以使用通配符匹配进行枚举，Windows PowerShell 通配符表示法包括：

星号 (*) 匹配零个或多个出现的任何字符。

问号 (?) 完全匹配一个字符。

左括号 ([) 字符和右括号 (]) 字符括起一组要匹配的字符。

若要在 Windows 目录中查找带有后缀 .log 并且基名称中正好有五个字符的所有文件，请输入以下命令：

~~~ powershell
Get-ChildItem -Path C:\Windows\?????.log
~~~

若要在 Windows 目录中查找以字母 x 开头的所有文件，请键入：

~~~ powershell
Get-ChildItem -Path C:\Windows\x*
~~~

若要查找名称以 x 或 z 开头的所有文件，请键入：

~~~ powershell
Get-ChildItem -Path C:\Windows\[xz]*
~~~

也可以使用排除参数，例如排除名称包含9516的文件：

~~~ powershell
Get-ChildItem -Path C:\WINDOWS\System32\w*32*.dll -Exclude *[9516]*
Get-ChildItem -Path C:\Windows\*.dll -Recurse -Exclude [a-y]*.dll
~~~

包含参数和排除参数可结合使用：

~~~ powershell
Get-ChildItem -Path C:\Windows -Include *.dll -Recurse -Exclude [a-y]*.dll
~~~

**（二）复制**

如果目标文件或文件夹已存在，则复制尝试失败。 若要覆盖预先存在的目标，请使用 Force 参数。即使当目标为只读时，该命令也有效。

~~~ powershell
Copy-Item -Path C:\boot.ini -Destination C:\boot.bak -Force
~~~

你仍然可以使用其他工具执行文件系统复制。 XCOPY、ROBOCOPY 和 COM 对象（如 Scripting.FileSystemObject）都适用于 Windows PowerShell。 例如，可以使用 Windows Script Host Scripting.FileSystem COM 类将 C:\boot.ini 备份到 C:\boot.bak：

~~~ powershell
(New-Object -ComObject Scripting.FileSystemObject).CopyFile('C:\boot.ini', 'C:\boot.bak')
~~~

****

（三）**创建**

如果某个 Windows PowerShell 提供程序具有多个类型的项（例如，用于区分目录和文件的 FileSystem Windows PowerShell 提供程序），则需要指定项类型。

~~~ powershell
New-Item -Path 'C:\temp\New Folder' -ItemType Directory
New-Item -Path 'C:\temp\New Folder\file.txt' -ItemType File
~~~

**（四）删除**

删除的 时候，如果不希望系统针对每个包含的项都提示你，则指定 Recurse 参数：

~~~ powershell
Remove-Item -Path C:\temp\DeleteMe -Recurse
~~~