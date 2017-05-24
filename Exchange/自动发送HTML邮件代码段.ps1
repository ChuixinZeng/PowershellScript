$UserName = "zengchuixin" #用户名可以从变量中提取

# Header
$Output="
<html>
<body>

<font size=""5"" face=""微软雅黑,sans-serif"">
<tr align=""left"">您好</th> 
</font>
<font size=""5"" color=""#FF0000"" face=""微软雅黑,sans-serif"">
<tr align=""left"">$UserName ,</th><br><br>
</font>
<font size=""4"" face=""微软雅黑,sans-serif"">
<tr align=""left""><th>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp================================================</th><br> <br> 
</font>
<font size=""4"" face=""微软雅黑,sans-serif"">
<tr align=""left""><th>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp当前密码被重置为</th>
</font>
<font size=""4"" color=""#FF0000"" face=""微软雅黑,sans-serif"">
<tr align=""left""><th>XXX</th><br> <br> 
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
<h3 align=""left""><th>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbspIT运维部</th></h3> 
</font>
"
$Output+="</body></html>";

$sslpassword=ConvertTo-SecureString -String "sljlsjflsjfls" -AsPlainText -force
$ss|Write-Host
$cre= New-Object System.Management.Automation.PSCredential("exadmin@contoso.com",$sslpassword)
$smtpserver = "smtp.contoso.com"
$emailfrom = "itsupport@contoso.com"
$emailto = "zengchuixin@contoso.com"
$subject = "您的邮箱密码已被重置，请及时进行密码修改!!"
$emailbody = $Output

Send-MailMessage -SmtpServer $smtpserver -Port 25 -Body $emailbody -Subject $subject -To $emailto -From $emailfrom -Credential $cre -Encoding default -BodyAsHtml