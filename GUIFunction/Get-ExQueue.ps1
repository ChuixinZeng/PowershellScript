#获取当前环境中邮件系统的队列情况，需要提前导入exchange的管理模块，使用命令add-pssnapin *exchange*

function Get-ExQueue
{
	
	$exservicename = Get-TransportService | sort -Property name
	foreach ($exservice in $exservicename)
	{
		$queuecount = ($exservice | Get-Queue | ?{ $_.DeliveryType -ne "ShadowRedundancy" } | measure messagecount -sum | select sum).sum
		$exqueueoutput = $exservice.name + "邮件队列共" + $queuecount
		if ($queuecount -gt 0)
		{
			
			$Global:exqueuecount = $exqueueoutput + "封堆积邮件."+"`n"
			$Global:exqueuecount
			
		}
		else
		{
			
			$global:exqueuesuccess = "$exservice" + "队列没有堆积."+"`n"
			$global:exqueuesuccess
			
		}
	}
	
}