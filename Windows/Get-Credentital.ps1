# 默认情况下，Get-credential在使用过程中会弹窗让用户输入密码，命令如下

$cred = Get-Credential
Get-WmiObject Win32_DiskDrive -ComputerName . -Credential $cred

