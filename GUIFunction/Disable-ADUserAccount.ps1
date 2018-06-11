function disable-aduseraccount
{
	
	#定义用户名的来源，来自于textbox2
	$bjdisableusers = $textbox2.Text
	
	$ErrorActionPreference = 'SilentlyContinue'
	$bjdisableusers100 = (Get-ADUser $bjdisableusers).samaccountname
	$disableDate = Get-Date -UFormat "%Y-%m-%d"
	
	#比较用户输入的用户名称是否在AD中存在，如果不存在则返回错误
	if ($bjdisableusers100 -ne $bjdisableusers)
	{
		
		$global:bjdisableuserserror = "发生了错误，原因是用户名为空，或者输入了错误的用户名！"
		$global:bjdisableuserserror
		
	}
	
	#如果用户名存在则执行foreach中的代码
	elseif ($bjdisableusers100 -eq $bjdisableusers)
	{
		#从变量$bjdisableusers中遍历用户名称，这里实际上只有一个用户名，之所以加foreach，是为了方便后期改造为批量禁用的脚本
		foreach ($bjdisableuser in $bjdisableusers)
		{
			
			#将用户移动到已禁用账户OU，并停止3秒
			Get-ADUser $bjdisableuser | Move-ADObject -TargetPath "OU=禁用帐户,DC=contoso,DC=com"
			#Start-Sleep -Seconds 3
			$global:movedisableaduser = "用户" + "$bjdisableuser" + "已被移动到OU=禁用帐户,DC=contoso,DC=com" + "`n"
			$global:movedisableaduser
			
			#将用户描述名称修改一下，并停止3秒
			Set-ADUser -Identity $bjdisableuser -Description "已离职 $disableDate"
			#Start-Sleep -Seconds 3
			
			$global:modifydisableaduser = "用户" + "$bjdisableuser" + "的描述名称已被修改为:" + "已离职 " + "$disableDate" + "`n"
			$global:modifydisableaduser
			
			#禁用账户，并停止5秒
			Disable-ADAccount -Identity $bjdisableuser
			#Start-Sleep -Seconds 5
			$global:disableadaccount = "用户" + "$bjdisableuser" + "已禁用完毕" + "`n"
			$global:disableadaccount
			
			#设置用户邮箱从地址列表中隐藏
			$ErrorActionPreference = "stop"
			
		Trap { "这里检测到了异常: $($_.Exception.Message)"; Continue }
			Set-Mailbox -HiddenFromAddressListsEnabled $true -Identity $bjdisableuser
			#Start-Sleep -Seconds 3
			$global:disableaduseraddressdisplay = "用户" + "$bjdisableuser" + "已经从地址列表中隐藏完毕" + "`n"
			$global:disableaduseraddressdisplay
			
			#获取用户的DN名称和账户名称，提供给后面的LDAPFilter使用
			$bjdisableaduser = Get-ADUser -Identity $bjdisableuser
			$bjdisableuserdn = $bjdisableaduser.DistinguishedName
			$bjdisableusername = $bjdisableuser.name
			
			#查询如果用户加入到了特定组织则从组中删除并输出日志
			if (Get-ADGroup -LDAPFilter "(member=$bjdisableuserdn)")
			{
				
				
				
				$ADgroupname = (Get-ADGroup -LDAPFilter "(member=$bjdisableuserdn)").name
				$log = "$ADgroupname" +"," + "$bjdisableuser" + "`n"
				$log >> "\\fs.contoso.cn\部门共享\BJDisableUser-GroupLog.txt"
				
				Get-ADGroup -LDAPFilter "(member=$bjdisableuserdn)" | ForEach-Object { Remove-ADGroupMember -Identity $_.Name -Members $bjdisableuserdn -Confirm:$false }
				
				$global:removeadgroupmember = "用户" + "$bjdisableuser" + "的隶属于组已经被清除（除domain users）" + "`n"
				$global:removeadgroupmember
				
			}
			#查询用户如果不属于任何组，则返回信息
			else
			{
				$global:noremoveadgroup = "用户" + "$bjdisableuser" + "没有需要删除的隶属于信息" + "`n"
				$global:noremoveadgroup
			}
			
			
		}
		
		#操作全部完成后，返回日志信息
		$global:enddisableadaccount = "操作已经全部执行完成，日志信息保存在\\fs.contoso.cn\部门共享\BJDisableUser-GroupLog.txt" + "`n"
		$global:enddisableadaccount
	}
}
