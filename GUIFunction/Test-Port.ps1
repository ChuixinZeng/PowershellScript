#这是一个powershell中文站上面的示例脚本，我做了修改，适合在GUI中调用

function Test-Port
{
	Param ([string]$ComputerName, $port, $timeout)
	try
	{
		$tcpclient = New-Object -TypeName system.Net.Sockets.TcpClient
		$iar = $tcpclient.BeginConnect($ComputerName, $port, $null, $null)
		$wait = $iar.AsyncWaitHandle.WaitOne($timeout, $false)
		if (!$wait)
		{
			$tcpclient.Close()
			#return Write-Host "$ComputerName 端口失败！"
			$global:porterror = $ComputerName + "上的目标端口测试失败！" + "`n"
			return $global:porterror
			
		}
		else
		{
			# Close the connection and report the error if there is one
			#$outputmessage = Write-Host "$ComputerName 端口正常！"
			$global:portsuccess = $ComputerName + "上的目标端口测试正常！" + "`n"
			$null = $tcpclient.EndConnect($iar)
			$tcpclient.Close()
			return $global:portsuccess
		}
	}
	catch
	{
		"不存在目标端口"
	}
}