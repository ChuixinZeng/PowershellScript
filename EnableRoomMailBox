<#在微软的Exchange 2013版本中，如果通过图形界面去配置会议室邮箱的话，会发现选项比较少。
而且如果是批量开启并且做相应的配置的话，用图形界面就比较麻烦了。
而使用powershell的方式进行开启并配置是一个不错的选择。
 
需求是：
1）创建会议室邮箱（需求方已经提供了会议室邮箱的列表和位置信息）
2）设置会议室的名称、别名并开启默认电子邮件地址策略
3）预订期限为30天
4）个别会议室需要审批后才可以接受会议预订请求#>
 
#对于1）-3）需求的实现方法是将需要创建的会议室信息保存到CSV文件中，包括以下几个字段
 
roomname,ln,mailname,alias,displayname
CMeeting,2F,CMeeting@contoso.com,CMeeting,魂斗罗
WMeeting,2F,WMeeting@contoso.com,WMeeting,魔兽争霸
 
#然后我们使用两个foreach循环，第一个是开启会议室，第二个是配置会议室邮箱。
 
$info=$null
$info1=$null
$info2=$null
Add-PSSnapin *exchange*
$info=Import-Csv -Path D:\scripts\room.csv -Encoding Default
foreach ($info1 in $info)
{
 
#创建会议室邮箱
 
New-Mailbox -Name $info1.alias -Database "DB01" -Room `
 -DisplayName $info1.displayname -Office $info1.ln -Alias $info1.alias `
 -PrimarySmtpAddress $info1.mailname -OrganizationalUnit "OU=会议室,OU=所有资源,OU=demo,DC=contoso,DC=com"
 }
  
 Start-Sleep -Seconds 180 -Verbose
 #这个地方加了一个休眠的时间，是为了创建完会议室之后留几分钟AD同步的时间
 #避免以为AD同步问题导致后面配置会议室邮箱不成功
  
 foreach ($info2 in $info)
 {
 
 #打开默认的电子邮件地址策略
 
Get-Mailbox -Identity $info2.mailname | Set-Mailbox -EmailAddressPolicyEnabled:$true 
 
#设置会议最长保留期限（30天）
 
Get-Mailbox -Identity $info2.mailname | Set-CalendarProcessing `
-MaximumDurationInMinutes 1800 -BookingWindowInDays 180 -AutomateProcessing AutoAccept
}
 
#如果想删除会议室邮箱，则在上面的foreach中使用
 
Remove-Mailbox -Identity "$info1.roomname
 
#如果想给个别的VIP会议室邮箱加审批权限的话，则使用命令
 
Get-Mailbox -Identity "VIPMeeting@contoso.com" | Set-CalendarProcessing `
-AllBookInPolicy $false -AllRequestInPolicy $true -ResourceDelegates "zengchuixin@contoso.com"
