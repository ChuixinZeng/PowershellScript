# you would connect to Exchange 2010/2013/2016 like this:

$session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri 'http://ex01/PowerShell/?SerializationLevel=Full' -Authentication Kerberos
Import-PSSession -Session $session

# This would import all available cmdlets in the local PowerShell session. But, consider the next example:

$session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri 'http://ex01/PowerShell/?SerializationLevel=Full' -Authentication Kerberos
Import-PSSession -Session $session -CommandName Get-Mailbox,New-Mailbox,Enable-Mailbox,Set-Mailbox -FormatTypeName *

# 上面的代码在连接exchange会话的时候，只导入特定的命令，这样速度会更快
# This would import only those cmdlets that you use, and this speeds up the import itself. This same kind of trick works also for the Active Directory module:

Import-Module -Name ActiveDirectory -Cmdlet Get-ADUser,New-ADUser,Set-ADUser