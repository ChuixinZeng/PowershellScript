# Windows PowerShell 驱动器可以使许多任务变得更简单。 例如，Windows 注册表中的某些最重要的项的路径长度非常长，难以访问且难以记住这些路径。 关键的配置信息位于 HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion。 若要查看和更改 CurrentVersion 注册表项中的项，你可以创建一个其根在该项中的 Windows PowerShell 驱动器，方法是键入：

New-PSDrive -Name cvkey -PSProvider Registry -Root HKLM\Software\Microsoft\Windows\CurrentVersion

# 输出结果如下

'''
Name           Used (GB)     Free (GB) Provider      Root                                                                                                                                                   CurrentLocation
----           ---------     --------- --------      ----                                                                                                                                                   ---------------
cvkey                                  Registry      HKLM\Software\Microsoft\Windows\...
'''

# 然后，你可以像对任何其他驱动器一样，将位置更改为 cvkey: 驱动器：
cd cvkey:

或者：

Set-Location cvkey: -PassThru

# 输出结果如下

'''
Path
----
cvkey:\
'''
