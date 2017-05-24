
#这是一个ping脚本，我做了修改，适合在powershell GUI中调用
function Ping_Test
{
	PROCESS
	{
		#$ws = New-Object -ComObject WScript.Shell
		$ping = $false
		$results = Get-WmiObject -query "SELECT * FROM Win32_PingStatus WHERE Address = '$_'"
		$RT = $results.ResponseTime
		$TTL = $results.ResponseTimeToLive
		#start-sleep 5 #等待时间为5秒
		foreach ($result in $results)
		{
			if ($results.StatusCode -eq 0)
			{
				if ($RT -ge 250) #如果延迟高于250
				{
					$global:pingwaring =  "$_ " + "RTime=$RT ms," + " RTime is dangerous"+"`n" #以黄色字体输出延迟信息
					return $global:pingwaring
					#echo ((get-date).ToString("HH:mm:ss") + " DA " + "$_ Response Time=$RT ms, ")>> ((get-date).ToString("MMdd") + ".txt")
				} #将信息保留到当前日期的文件夹下，并标注时间，以DA为标识。
				else
				{
					$global:pingsuccess = "$_ " + "RTime=$RT ms," + "  RTime is OK"+"`n"  #如果延迟不高于250，以绿色字体输出。
					return $global:pingsuccess
					#echo ((get-date).ToString("HH:mm:ss") + " OK " + "$_ Response Time=$RT ms, ")>> ((get-date).ToString("MMdd") + ".txt")
				}#将信息保留到当前日期的文件夹下，并标注时间，以OK为标识。
			}
			else
			{
				$global:pingerror = "$_ " + "Ping failed!"+"`n" #如果又不是高于250，也不是低于250，就是网路中断了啊！
				return $global:pingerror
				#$ws.popup("`n$_ 网络中断了", 3, " 网络中断", 64) #网络中断弹窗报警
				#echo ((get-date).ToString("HH:mm:ss") + " FA " + "`n$_ Ping failed! ")>> ((get-date).ToString("MMdd") + ".txt") #记录信息，以FA为标识
			}
		}
	}
}