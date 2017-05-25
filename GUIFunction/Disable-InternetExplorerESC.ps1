function Disable-InternetExplorerESC
#关闭IE ESC设置
{
	$computerlist = $Env:COMPUTERNAME
	foreach ($cl in $computerlist)
	{
		$computerversion = Get-WmiObject Win32_OperatingSystem -ComputerName $cl
		
		if ($computerversion.version -eq "6.3.9600")#操作系统版本为windows 2012 R2
		{
			$AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
			$UserKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
			Set-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 0 -Force
			Set-ItemProperty -Path $UserKey -Name "IsInstalled" -Value 0 -Force
			Stop-Process -Name Explorer
			$disableieesc12R2 = "您的操作系统为Windows Server 2012 R2,IE ESC已经被禁用."
			$disableieesc12R2
		}
		elseif ($computerversion.version -eq "6.1.7601")#操作系统版本为windows 2008 R2 sp1
		{
			$AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
			$UserKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
			Set-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 0 -Force
			Set-ItemProperty -Path $UserKey -Name "IsInstalled" -Value 0 -Force
			Stop-Process -Name Explorer
			$disableieesc08R2 = "您的操作系统为Windows Server 2008 R2 sp1,IE ESC已经被禁用."
			$disableieesc08R2
		}
		elseif ($computerversion.version -eq "10.0.15063")
		{
			$disableieescwin101703 = "您的操作系统版本是windows10 1703版本，不支持关闭IE ESC"
			$disableieescwin101703
		}
		
		elseif ($computerversion.version -eq "10.0.10.0.14393")
		{
			$disableieescwin101603 = "您的操作系统版本是windows10 1603版本，不支持关闭IE ESC"
			$disableieescwin101603
		}
		else
		{
			$disableieescother = "暂时不受支持的操作系统类型"
			$disableieescother
		}
	}#foreach的结束地方
}#function的结束地方