Windows PowerShell 驱动器可以使许多任务变得更简单。 例如，Windows 注册表中的某些最重要的项的路径长度非常长，难以访问且难以记住这些路径。 关键的配置信息位于 HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion。 若要查看和更改 CurrentVersion 注册表项中的项，你可以创建一个其根在该项中的 Windows PowerShell 驱动器，方法是键入：

New-PSDrive -Name cvkey -PSProvider Registry -Root HKLM\Software\Microsoft\Windows\CurrentVersion
## 输出结果如下

Name Used (GB) Free (GB) Provider Root CurrentLocation
cvkey Registry HKLM\Software\Microsoft\Windows\...

## 然后，你可以像对任何其他驱动器一样，将位置更改为 cvkey: 驱动器：
cd cvkey:
或者：
Set-Location cvkey: -PassThru
## 输出结果如下

Path
cvkey:\

New-PsDrive cmdlet 仅将新的驱动器添加到当前 Windows PowerShell 会话中。 如果关闭 Windows PowerShell 窗口，则会丢失新的驱动器。 若要保存 Windows PowerShell 驱动器，请使用 Export-Console cmdlet 导出当前 Windows PowerShell 会话，然后使用 PowerShell.exe PSConsoleFile 参数来将其导入。 或者，将新的驱动器添加到 Windows PowerShell 配置文件中。
