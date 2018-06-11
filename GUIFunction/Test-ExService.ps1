function Test_ExService
{
	
	#单独为Exchange的服务设置一个function，因为后面筛选服务状态的条件不太一样，不想做太复杂的判断逻辑
	
	$ServerListmailservice = (Get-ExchangeServer | Where-Object { $_.AdminDisplayVersion -match "15.0" }).name
	$exserviceDownCount = 0
	foreach ($exmachineName in $ServerListmailservice)
	{
		$ErrorActionPreference = "stop"
		Trap { "这里检测到了 $exmachineName 的异常: $($_.Exception.Message) 请确保服务器能够正常连接！！"; Continue }
		$exserviceStatus = get-WmiObject win32_service -ComputerName $exmachineName | where {
			($_.displayName -match "exch*") -and ($_.StartMode -match "Auto") `
			-and ($_.StartMode -match "Manual") -and ($_.state -match "Stopped") }
		
		#注意这个地方的判断是反思维的，就是先判断有没有处于停止状态的服务，如果有，就输出，如果没有则执行后面的else
		
		if ($exserviceStatus -ne $null)
		{
			foreach ($exservice in $exserviceStatus)
			{
				$exservicename = $exservice.name
				$exservicestate = $exservice.state
				
				$global:exservicefail = "$exmachineName"+"上的" + "$exservicename" +"处于"+ "$exservicestate"+"状态"+"`n"
				$global:exservicefail
			
				$exserviceDownCount += 1
			}
		}
		else
		{
			$global:exservicesuccess = "$exmachineName" + "所需的邮件相关服务都在正常运行."+"`n"
			$global:exservicesuccess
		}
	}
}