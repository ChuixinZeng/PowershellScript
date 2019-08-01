# 默认情况下，Get-credential在使用过程中会弹窗让用户输入用户名和密码(Powershell and Powershell ISE)，命令如下

$cred = Get-Credential
Get-WmiObject Win32_DiskDrive -ComputerName . -Credential $cred

# 如果是在VSCode下面，则不会弹窗，而是直接在终端让用户输入用户名和密码，如下
<#
位于命令管道位置 1 的 cmdlet Get-Credential
请为以下参数提供值:
User: zengchuixin
Password for user zengchuixin: ******************
#>

# 另外，如果不希望在powershell命令行界面弹窗，达到上面VSCODE的效果，则可以通过修改注册表键值的方式来实现(此方法对PowerShell ISE无效)

Set-ItemProperty 'HKLM:\SOFTWARE\Microsoft\PowerShell\1\ShellIds' ConsolePrompting $true

<#
PS C:\Users\administrator> $cred = Get-Credential

位于命令管道位置 1 的 cmdlet Get-Credential
请为以下参数提供值:
Credential
用户: administrator
用户 administrator 的密码: *******
#>

