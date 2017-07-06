Add-PSSnapin *exchange*
$info=Import-Csv -Path D:\scripts\room.csv -Encoding Default
#$password=ConvertTo-SecureString -AsPlainText -String "@!m02222017" -Force
foreach ($info1 in $info)

{
#创建会议室邮箱

New-Mailbox -Name $info1.alias -Database "BJDB01114" -Room `
 -DisplayName $info1.displayname -Office $info1.ln -Alias $info1.alias `
 -PrimarySmtpAddress $info1.mailname -OrganizationalUnit "OU=会议室,OU=所有资源,DC=contoso,DC=com"
 }

 Start-Sleep -Seconds 180 -Verbose

 foreach ($info2 in $info)

 {

#打开默认的电子邮件地址策略

Get-Mailbox -Identity $info2.mailname | Set-Mailbox -EmailAddressPolicyEnabled:$true 

#设置会议最长保留期限（30天）

Get-Mailbox -Identity $info2.mailname | Set-CalendarProcessing `
-MaximumDurationInMinutes 1800 -BookingWindowInDays 180 -AutomateProcessing AutoAccept

#删除会议室邮箱
#Remove-Mailbox -Identity "$info1.roomname
}


#设置会议室权限审批人（其中的三个会议室）

Get-Mailbox -Identity "VIP-room-Meeting@contoso.com" | Set-CalendarProcessing `
-AllBookInPolicy $false -AllRequestInPolicy $true -ResourceDelegates "test@contoso.com"

Get-Mailbox -Identity "World-of-Warcraft-Meeting@contoso.com" | Set-CalendarProcessing `
-AllBookInPolicy $false -AllRequestInPolicy $true -ResourceDelegates "test@contoso.com"
Get-Mailbox -Identity "Call-of-Duty-Meeting@contoso.com" | Set-CalendarProcessing `
-AllBookInPolicy $false -AllRequestInPolicy $true -ResourceDelegates "test@contoso.com"

<#
创建和管理会议室邮箱: Exchange Online Help  
https://technet.microsoft.com/zh-cn/library/jj215781(v=exchg.150).aspx

#>