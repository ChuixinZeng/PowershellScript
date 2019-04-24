<#获取必需和从属服务
Get-Service cmdlet 具有两个在服务管理中非常有用的参数。 DependentServices 参数获取依赖于该服务的服务。 RequiredServices 参数获取此服务所依赖的服务。
这些参数只显示 Get-Service 返回的 System.ServiceProcess.ServiceController 对象的 DependentServices 和 ServicesDependedOn (alias=RequiredServices) 属性的值，但是它们可简化命令，使获取此信息更加简单。
#>

# 下面的命令获取 LanmanWorkstation 服务需要的服务。

Get-Service -Name LanmanWorkstation -RequiredServices

<# 输出结果如下
Status   Name               DisplayName
------   ----               -----------
Running  MRxSmb20           SMB 2.0 MiniRedirector
Running  bowser             Bowser
Running  MRxSmb10           SMB 1.x MiniRedirector
Running  NSI                Network Store Interface Service
#>

# 下面的命令获取需要 LanmanWorkstation 服务的服务。

Get-Service -Name LanmanWorkstation -DependentServices

<# 输出结果如下
Status   Name               DisplayName
------   ----               -----------
Running  SessionEnv         Terminal Services Configuration
Running  Netlogon           Netlogon
Stopped  Browser            Computer Browser
Running  BITS               Background Intelligent Transfer Ser...
#>

# 你甚至可以获取所有具有依赖关系的服务。 下面的命令所做的就是这些，然后使用 Format-Table cmdlet 来显示计算机上服务的 Status、Name、RequiredServices 和 DependentServices 属性。

Get-Service -Name * | Where-Object {$_.RequiredServices -or $_.DependentServices} | Format-Table -Property Status, Name, RequiredServices, DependentServices -auto