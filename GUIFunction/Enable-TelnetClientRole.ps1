function Enable-TelnetClientRole
{
	#目前此function仅支持Windows10和Windows 2012R2操作系统
	$computername = $env:COMPUTERNAME
	#这个地方之所以加foreach，是为了方便地将当前的脚步改造为能够操作多台机器，因为前面的computername变量不仅仅可以指定当前机器
	foreach ($cn in $computername)
	{
		
		$cnwmi = Get-WmiObject win32_operatingsystem -ComputerName $cn
		
		if (Get-WmiObject win32_operatingsystem -ComputerName $cn | where { $_.Version -like "10.0*" })
		{
			$outputsystemclientversion = "当前$env:COMPUTERNAME 的版本是Windows10 1703，正在尝试开启Telnet客户端角色...."+"`n"
			$outputsystemclientversion
			
			if ((Get-WindowsOptionalFeature -Online | where featurename -Like "*Telnet*").state -eq "Disabled")
			{
				Enable-WindowsOptionalFeature -Online -FeatureName TelnetClient -All
				$enableclienthypervmessage = "Telnet客户端开启成功，请重启您的计算机以便配置生效"
				$enableclienthypervmessage
				$ErrorActionPreference = "stop"
				Trap { "开启Telnet Client失败: $($_.Exception.Message)"; }
			}
			elseif ((Get-WindowsOptionalFeature -Online | where featurename -Like "*Telnet*").state -eq "Enabled")
			{
				$enableclienthypervmessage1 = "您当前的机器已经开启Telnet客户端，无需重复操作！"+"`n"
				$enableclienthypervmessage1
			}
			else
			{
				$errorclientenablehypermessage = "Telnet客户端状态未知，请检查服务器配置！"+"`n"
				$errorclientenablehypermessage
			}
			
		} #end if
		
		elseif ($cnwmi.version -eq "6.3.9600")
		{
			$outputserversystemversion = "当前$env:COMPUTERNAME 的版本是Windows 2012R2 SP1，正在尝试开启Telnet客户端角色...."+"`n"
			$outputserversystemversion
			
			if ((Get-WindowsFeature "telnet-client").InstallState -eq "Available")
			{
				Install-WindowsFeature -Name Telnet-Client
				$enableserverhypervmessage = "Telnet客户端开启成功，请重启您的计算机以便配置生效"+"`n"
				$enableserverhypervmessage
				$ErrorActionPreference = "stop"
				Trap { "开启Telnet客户端失败: $($_.Exception.Message)"; }
			}
			elseif ((Get-WindowsFeature "telnet-client").InstallState -eq "Installed")
			{
				$enableserverhypervmessage1 = "您当前的机器已经开启Telnet客户端，无需重复操作！"+"`n"
				$enableserverhypervmessage1
			}
			
			else
			{
				$errorserverenablehypermessage = "Telnet客户端状态未知，请检查服务器配置！"+"`n"
				$errorserverenablehypermessage
			}
		}#end elseif
		
		else
		{
			$erroenablehypermesssage = "目前仅支持开启Windows10 RTM以上CU版本和Windows 2012 R2 SP1版本，请知晓"+"`n"
			$erroenablehypermesssage
		}
		
	}#foreach end
}#function end