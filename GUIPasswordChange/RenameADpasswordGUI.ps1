<#
备注信息

作者：zengchuixin编写给XXIT使用
名称：一键重置密码工具
版本：V0.4

变更信息

2017/4/28：完成第一版，可以重置并生成随机密码，可以打开忘记密码和自助修改密码的链接
2017/5/04：增加用户名输入框，并增加判断，当输入的用户名为空，不存在或者输入正确，则输出不同的信息
2017/5/05：增加自动发送邮件功能，重置成功后自动发邮件，并定义HTML邮件正文的格式
2017/5/08：增加生成日志功能，将日志保存到共享服务器上，只能由后台管理员查看，此行为对helpdesk是透明的

#>


$FormEvent_Load={
	#TODO: Initialize Form Controls here
	
}


$exitToolStripMenuItem_Click={
	#TODO: Place custom script here
	$form一键重置AD用户密码工具IT系统组.Close()
}

$aboutToolStripMenuItem_Click={
	#TODO: Place custom script here
	[System.Windows.Forms.MessageBox]::Show("Menu Application v1.0","Menu Application");
}

#定义一个函数，用来修改powershell的执行策略，导入AD和exchange的模块

function set-adex {
	Set-ExecutionPolicy -ExecutionPolicy 'RemoteSigned'
	$ErrorActionPreference = 'SilentlyContinue'
	Import-Module ActiveDirectory
	Add-PSSnapin *exchange*
}

set-adex

#定义重置密码按钮的行为

$button重置密码左侧输入用户名_Click = {
	#TODO: Place custom script here
	
	#定义一个函数，用来随机生成密码，这是微软官方的一个生成随机密码的函数
	
	function New-SWRandomPassword
	{
		[CmdletBinding(DefaultParameterSetName = 'FixedLength', ConfirmImpact = 'None')]
		[OutputType([String])]
		Param
		(
			# Specifies minimum password length
			[Parameter(Mandatory = $false,
					   ParameterSetName = 'RandomLength')]
			[ValidateScript({ $_ -gt 0 })]
			[Alias('Min')]
			[int]$MinPasswordLength = 8,
			
			# Specifies maximum password length
			[Parameter(Mandatory = $false,
					   ParameterSetName = 'RandomLength')]
			[ValidateScript({
				if ($_ -ge $MinPasswordLength) { $true }
				else { Throw 'Max value cannot be lesser than min value.' }
			})]
			[Alias('Max')]
			[int]$MaxPasswordLength = 12,
			
			# Specifies a fixed password length
			[Parameter(Mandatory = $false,
					   ParameterSetName = 'FixedLength')]
			[ValidateRange(1, 2147483647)]
			[int]$PasswordLength = 8,
			
			# Specifies an array of strings containing charactergroups from which the password will be generated.
			# At least one char from each group (string) will be used.
			[String[]]$InputStrings = @('abcdefghijkmnpqrstuvwxyz', 'ABCEFGHJKLMNPQRSTUVWXYZ', '23456789', '!"#%&'),
			
			# Specifies a string containing a character group from which the first character in the password will be generated.
			# Useful for systems which requires first char in password to be alphabetic.
			[String] $FirstChar,
			
			# Specifies number of passwords to generate.
			[ValidateRange(1, 2147483647)]
			[int]$Count = 1
		)
		Begin
		{
			Function Get-Seed
			{
				# Generate a seed for randomization
				$RandomBytes = New-Object -TypeName 'System.Byte[]' 4
				$Random = New-Object -TypeName 'System.Security.Cryptography.RNGCryptoServiceProvider'
				$Random.GetBytes($RandomBytes)
				[BitConverter]::ToUInt32($RandomBytes, 0)
			}
		}
		Process
		{
			For ($iteration = 1; $iteration -le $Count; $iteration++)
			{
				$Password = @{ }
				# Create char arrays containing groups of possible chars
				[char[][]]$CharGroups = $InputStrings
				
				# Create char array containing all chars
				$AllChars = $CharGroups | ForEach-Object { [Char[]]$_ }
				
				# Set password length
				if ($PSCmdlet.ParameterSetName -eq 'RandomLength')
				{
					if ($MinPasswordLength -eq $MaxPasswordLength)
					{
						# If password length is set, use set length
						$PasswordLength = $MinPasswordLength
					}
					else
					{
						# Otherwise randomize password length
						$PasswordLength = ((Get-Seed) % ($MaxPasswordLength + 1 - $MinPasswordLength)) + $MinPasswordLength
					}
				}
				
				# If FirstChar is defined, randomize first char in password from that string.
				if ($PSBoundParameters.ContainsKey('FirstChar'))
				{
					$Password.Add(0, $FirstChar[((Get-Seed) % $FirstChar.Length)])
				}
				# Randomize one char from each group
				Foreach ($Group in $CharGroups)
				{
					if ($Password.Count -lt $PasswordLength)
					{
						$Index = Get-Seed
						While ($Password.ContainsKey($Index))
						{
							$Index = Get-Seed
						}
						$Password.Add($Index, $Group[((Get-Seed) % $Group.Count)])
					}
				}
				
				# Fill out with chars from $AllChars
				for ($i = $Password.Count; $i -lt $PasswordLength; $i++)
				{
					$Index = Get-Seed
					While ($Password.ContainsKey($Index))
					{
						$Index = Get-Seed
					}
					$Password.Add($Index, $AllChars[((Get-Seed) % $AllChars.Count)])
				}
				Write-Output -InputObject $(-join ($Password.GetEnumerator() | Sort-Object -Property Name | Select-Object -ExpandProperty Value))
			}
		}
	}
	
	#定义文本框中要输入信息的行为
	
	$textbox1_TextChanged = {
		#TODO: Place custom script here
		$textbox1.Text = Read-Host ""
	}
	
	#生成复杂密码的函数
	
	$passwordtext = New-SWRandomPassword -MinPasswordLength 8 -MaxPasswordLength 10 -Count 1
	
	#重置密码代码段
	
	$setpassword = Set-ADAccountPassword -Identity $textbox1.Text -NewPassword `
	(ConvertTo-SecureString -String $passwordtext -AsPlainText -Force) -Reset
	
	#定义IF判断的条件
	
	
	[string]$usname1 = $textbox1.Text
	[string]$usname2 = (get-aduser -identity $textbox1.Text).samaccountname
	
	if ($textbox1.Text -eq "")
	{
		$richtextbox1.Text = Write-Output "请先在上方的文本框中输入要重置密码的用户名"
	}
	
	elseif ($usname1 -ne $usname2)
	
	{
		$richtextbox1.Text = Write-Output "未在AD中查询到您输入的账户，请输入正确的AD用户名"
	}
	
	elseif ($usname1 -eq $usname2)
	{
		
		$richtextbox1.Text = Write-Output "密码已重置为 $passwordtext`
"
		# 电子邮件正文代码段，定义正文的颜色，字体格式等信息
		
		$Output = "<html>
		<body>

		<font size=""5"" face=""微软雅黑,sans-serif"">
		<tr align=""left"">您好</th> 
		</font>
		<font size=""5"" color=""#FF0000"" face=""微软雅黑,sans-serif"">
		<tr align=""left"">$usname1 ,</th><br><br>
		</font>
		<font size=""4"" face=""微软雅黑,sans-serif"">
		<tr align=""left""><th>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp================================================</th><br> <br> 
		</font>
		<font size=""4"" face=""微软雅黑,sans-serif"">
		<tr align=""left""><th>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp当前密码被重置为</th>
		</font>
		<font size=""4"" color=""#FF0000"" face=""微软雅黑,sans-serif"">
		<tr align=""left""><th>$passwordtext</th><br> <br> 
		</font>
		<font size=""4"" face=""微软雅黑,sans-serif"">
		<tr align=""left""><th>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp请在90天有效期内及时修改个人密码，修改地址： https://password.contoso.com</th><br> <br> 
		</font>
		<font size=""4"" color=""#FF0000"" face=""微软雅黑,sans-serif"">
		<tr align=""left""><th>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp修改时务必注意以下几点： </th><br> 
		</font>
		<font size=""4"" face=""微软雅黑,sans-serif"">
		<tr align=""left""><th>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp1、密码中</th>
		</font>
		<font size=""4"" color=""#FF0000"" face=""微软雅黑,sans-serif"">
		<tr align=""left""><th>不能包含</th>
		</font>
		<font size=""4"" face=""微软雅黑,sans-serif"">
		<tr align=""left""><th>邮箱地址前缀（含连续2个及以上）</th><br>
		</font>
		<font size=""4"" face=""微软雅黑,sans-serif"">
		<tr align=""left""><th>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp2、3次以内的密码不能相同</th>
		</font>
		<font size=""4"" color=""#FF0000"" face=""微软雅黑,sans-serif"">
		<tr align=""left""><th>（新旧密码不能出现连续2个及以上相同的情况）</th><br>
		</font>
		<font size=""4"" face=""微软雅黑,sans-serif"">
		<tr align=""left""><th>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp3、密码最少8位（必须同时包含数字、字母、符号）</th><br> <br> 
		</font>
		<font size=""4"" face=""微软雅黑,sans-serif"">
		<tr align=""left""><th>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp如有问题请及时联系 xxxxxxxx 或发送邮件到 itsupport@contoso.com</th><br> <br>
		<tr align=""left""><th>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp================================================</th><br>  
		<h3 align=""left""><th>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp集团办公IT运维部</th></h3> 
		</font>
		"
		$Output += "</body></html>"
		
		#定义发送电子邮件的变量
		
		$sslpassword = ConvertTo-SecureString -String "xxxxxxxx" -AsPlainText -force
		$cre = New-Object System.Management.Automation.PSCredential("admin@contoso.com", $sslpassword)
		$smtpserver = "smtp.contoso.com"
		$emailfrom = "itsupport@contoso.com"
		$emailto = "$usname1" + "@contoso.com"
		$subject = "您的邮箱密码已被重置，请及时进行密码修改!!"
		$emailbody = $Output
		
		#发送电子邮件
		
		Send-MailMessage -SmtpServer $smtpserver -Port 25 -Body $emailbody `
		-Subject $subject -From $emailfrom -To $emailto -Credential $cre -Encoding default -BodyAsHtml
		
		#将密码重置成功的结果写入到log文件，日志文件保存在共享服务器上
		
		$logdate1 = (Get-Date).ToLongDateString()
		$logdate2 = (Get-Date).ToLongTimeString()
		$log = "在" + $logdate1 + $logdate2 + "为用户" + $usname1 + "重置了密码"
		$log >> "\\fs.contoso.com\部门共享\日志文件\resetpasswordlog.txt"
		
	}
}


$button打开自助修改密码链接_Click={
	#TODO: Place custom script here
	$url1 = "https://xxx.xxxx"
	Start-Process -FilePath $url1
}

$button打开找回密码链接_Click={
	#TODO: Place custom script here
	$url2 = "https://xxx.xxxx"
	Start-Process -FilePath $url2
}


