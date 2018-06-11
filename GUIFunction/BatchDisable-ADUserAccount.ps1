function batchdisable-aduseraccount
{
	
	#定义用户名的来源，来自于textbox3
	
	$bjdisableusers = Import-Csv $textbox3.Text -Encoding default
	$ErrorActionPreference = 'SilentlyContinue'
	$disableDate = Get-Date -UFormat "%Y-%m-%d"
	
	foreach ($bjdisableuser in $bjdisableusers)
	{
		
		$batchbjdisableuser = $bjdisableuser.UserName
		
		#将用户移动到已禁用账户OU，并停止3秒
		Get-ADUser $bjdisableuser.UserName | Move-ADObject -TargetPath "OU=禁用帐户,DC=contoso,DC=com"
		#Start-Sleep -Seconds 3
		$global:batchmovedisableaduser = "用户" + "$batchbjdisableuser" + "已被移动到OU=禁用帐户,DC=contoso,DC=com" + "`n"
		$global:batchmovedisableaduser
		
		#将用户描述名称修改一下，并停止3秒
		Set-ADUser -Identity $bjdisableuser.UserName  -Description "已离职 $disableDate"
		#Start-Sleep -Seconds 3
		
		$global:batchmodifydisableaduser = "用户" + "$batchbjdisableuser" + "的描述名称已被修改为:" + "已离职 " + "$disableDate" + "`n"
		$global:batchmodifydisableaduser
		
		#禁用账户，并停止5秒
		Disable-ADAccount -Identity $bjdisableuser.UserName
		#Start-Sleep -Seconds 5
		$global:batchdisableadaccount = "用户" + "$batchbjdisableuser" + "已禁用完毕" + "`n"
		$global:batchdisableadaccount
		
		#设置用户邮箱从地址列表中隐藏
		Set-Mailbox -HiddenFromAddressListsEnabled $true -Identity $bjdisableuser.UserName
		#Start-Sleep -Seconds 3
		$global:batchdisableaduseraddressdisplay = "用户" + "$batchbjdisableuser" + "已从地址列表中隐藏完毕" + "`n"
		$global:batchdisableaduseraddressdisplay
		
		#获取用户的DN名称和账户名称，提供给后面的LDAPFilter使用
		$bjdisableaduser = Get-ADUser -Identity $bjdisableuser.UserName
		$bjdisableuserdn = $bjdisableaduser.DistinguishedName
		$bjdisableusername = $bjdisableuser.name
		
		#查询如果用户加入到了特定组织则从组中删除并输出日志
		if (Get-ADGroup -LDAPFilter "(member=$bjdisableuserdn)")
		{
			
			$ErrorActionPreference = "stop"
			
			Trap { "这里检测到了异常: $($_.Exception.Message)"; Continue }
			
			$ADgroupname = (Get-ADGroup -LDAPFilter "(member=$bjdisableuserdn)").name
			$log = "$ADgroupname" + "$batchbjdisableuser" + "`n"
			$log >> "\\fs.contoso.cn\部门共享\日志文件\BJDisableUser-GroupLog.txt"
			
			Get-ADGroup -LDAPFilter "(member=$bjdisableuserdn)" | ForEach-Object { Remove-ADGroupMember -Identity $_.Name -Members $bjdisableuserdn -Confirm:$false }
			
			$global:batchremoveadgroupmember = "用户" + "$batchbjdisableuser" + "的隶属于组已经被清除（除domain users）" + "`n"
			$global:batchremoveadgroupmember
			
		}
		#查询用户如果不属于任何组，则返回信息
		else
		{
			$global:batchnoremoveadgroup = "用户" + "$batchbjdisableuser" + "没有需要删除的隶属于信息" + "`n"
			$global:batchnoremoveadgroup
		}
		
		
	}
	
	#操作全部完成后，返回日志信息
	$global:batchenddisableadaccount = "操作已经全部执行完成，日志信息保存在\\fs.contoso.cn\部门共享\日志文件\BJDisableUser-GroupLog.txt" + "`n"
	$global:batchenddisableadaccount
}