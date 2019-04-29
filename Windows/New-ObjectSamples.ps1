# 将构造函数与 New-Object 一起使用
# New-Object 具有 ArgumentList 参数。 作为值传递到此形参的实参将由对象的特殊的启动方法使用。 此方法叫做构造函数，因为它将用于构造对象。 例如，若要对获取应用程序日志的引用，请指定字符串“Application”作为实参：

New-Object -TypeName System.Diagnostics.EventLog -ArgumentList Application

# 由于大多数 .NET Framework 核心类都包含在 System 命名空间中，所以如果 Windows PowerShell 找不到你指定的类型名称的匹配项，它将自动尝试查找你在 System 命名空间中指定的类。 这意味着你可以指定 Diagnostics.EventLog 而不指定 System.Diagnostics.EventLog。

# 将对象放入到变量中

$AppLog = New-Object -TypeName System.Diagnostics.EventLog -ArgumentList Application
$AppLog
<#
  Max(K) Retain OverflowAction        Entries Name
  ------ ------ --------------        ------- ----
  16,384      7 OverwriteOlder          2,160 Application
#>

# 使用 New-Object 访问远程事件日志

$RemoteAppLog = New-Object -TypeName System.Diagnostics.EventLog Application,192.168.1.81
$RemoteAppLog
<#
  Max(K) Retain OverflowAction        Entries Name
  ------ ------ --------------        ------- ----
     512      7 OverwriteOlder            262 Application

#>

# 查看对象支持的方法列表

$RemoteAppLog | Get-Member -MemberType Method
<#
   TypeName: System.Diagnostics.EventLog

Name                      MemberType Definition
----                      ---------- ----------
...
Clear                     Method     System.Void Clear()
Close                     Method     System.Void Close()
...
GetType                   Method     System.Type GetType()
...
ModifyOverflowPolicy      Method     System.Void ModifyOverflowPolicy(Overfl...
RegisterDisplayName       Method     System.Void RegisterDisplayName(String ...
...
ToString                  Method     System.String ToString()
WriteEntry                Method     System.Void WriteEntry(String message),...
WriteEvent                Method     System.Void WriteEvent(EventInstance in...
#>

# Clear() 方法可以用于清除事件日志（本地或者远程的）。 调用方法时，即使该方法不需要参数，也必须始终在方法名称后紧跟括号。 这使得 Windows PowerShell 方法能够区分该方法和具有相同名称的潜在属性。 键入以下命令以调用 Clear 方法：

$RemoteAppLog.Clear()
# 再次查看，可以看到事件日志已经清除
$RemoteAppLog
$AppLog.Clear()
$AppLog