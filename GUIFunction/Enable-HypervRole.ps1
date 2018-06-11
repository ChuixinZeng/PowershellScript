function Enable-HypervRole
{

		#目前此function仅支持Windows10和Windows 2012R2操作系统
		$computername = $env:COMPUTERNAME
		#这个地方之所以加foreach，是为了方便地将当前的脚步改造为能够操作多台机器，因为前面的computername变量不仅仅可以指定当前机器
		foreach ($cn in $computername)
		{
			
			$cnwmi = Get-WmiObject win32_operatingsystem -ComputerName $cn
			
			if (Get-WmiObject win32_operatingsystem -ComputerName $cn | where { $_.Version -like "10.0*" })
			{
				$outputsystemclientversion = "当前$env:COMPUTERNAME 的版本是Windows10，正在尝试开启Hyper-v角色...." + "`n"
				$outputsystemclientversion
				
				if ((Get-WindowsOptionalFeature -Online | where featurename -Like "Microsoft-Hyper-V-All").state -eq "Disabled")
				{
					Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All -All
					$enableclienthypervmessage = "Hyper-v开启成功，请重启您的计算机以便配置生效"
					$enableclienthypervmessage
		
				}
				elseif ((Get-WindowsOptionalFeature -Online | where featurename -Like "Microsoft-Hyper-V-All").state -eq "Enabled")
				{
					$enableclienthypervmessage1 = "您当前的机器已经开启hyper-v，无需重复操作！"
					$enableclienthypervmessage1
				}
				else
				{
					$errorclientenablehypermessage = "Hyper-v状态未知，请检查服务器配置！"
					$errorclientenablehypermessage
				}
				
			} #end if
			
			elseif ($cnwmi.version -eq "6.3.9600")
			{
				
				
				if ((Get-WindowsFeature -Name 'Hyper-V').InstallState -eq "Installed")
				{
					$enableserverhypervmessage1 = "您当前的机器已经开启hyper-v，无需重复操作！"
					$enableserverhypervmessage1
			}
			else
			{
				try
				{
					#这个地方添加的warningaction很重要，不然错误无法输出到后面的richtextbox中，直接写trap是不行的
					Install-WindowsFeature -Name Hyper-V -WarningAction Stop -IncludeAllSubFeature -IncludeManagementTools
					
					$enableserverhypervmessage = "Hyper-v开启成功，请重启您的计算机以便配置生效"
					$enableserverhypervmessage
					$outputserversystemversion = "当前$env:COMPUTERNAME 的版本是Windows 2012R2 SP1，正在尝试开启Hyper-v角色...."
					$outputserversystemversion
				}
				catch
				{
					$richtextbox3.Text += "发生错误，原因有可能是您在虚拟机里面开启Hyper-v，或者您当前的操作系统不满足开启Hyper-v要求。
请在windows10和windows server2012R2物理机系统上运行工具"+"`n"
				}
			}
			
		}#end else
			
			else
			{
				$erroenablehypermesssage = "目前仅支持开启Windows10 RTM以上CU版本和Windows 2012 R2 SP1版本，请知晓"
				$erroenablehypermesssage
			}
			
		}#foreach end
	
}#function end