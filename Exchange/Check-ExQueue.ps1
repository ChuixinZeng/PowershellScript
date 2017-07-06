Add-pssnapin Microsoft.Exchange.Management.PowerShell.E2010
function Queue {
$servername=get-transportserver |sort -Property name
foreach ($server in $servername)
{$queuecount =($server|Get-Queue |?{$_.DeliveryType -ne "ShadowRedundancy"}  | measure messagecount -sum |select sum).sum
$output1 =$server.name+"邮件队列共"+ $queuecount
if ($queuecount -gt -1)
{$output1 =$output1+"封堆积邮件"}
$output1
}}
$date1 = Get-Date -UFormat "%Y-%m-%d_%H点%M分%S秒"
$date2 = Get-Date -UFormat "%Y/%m/%d %H:%M:%S"
Queue > "D:\scripts\Exchange传输队列告警信息$date1.txt"


$filename = "D:\scripts\Exchange传输队列告警信息$date1.txt"
$smtpServer = “10.205.91.22”
$msg = new-object Net.Mail.MailMessage
$att = new-object Net.Mail.Attachment($filename)
$smtp = new-object Net.Mail.SmtpClient($smtpServer)
$msg.From = “scomadmin@contoso.com”
$msg.To.Add("zengchuixin@contoso.com")
$msg.To.Add("qideyu@contoso.com")
$msg.To.Add("linxiaorui@contoso.com")
$msg.To.Add("zhangwj@contoso.com")
$msg.To.Add("gaoxu@contoso.com")
$msg.Subject = “$date2 邮件队列报警情况”
$msg.Body = “请打开附件查看详细的Exchange传输服务器队列警报信息!队列邮件堆积大于100封的服务器，需要特别关注!”
$msg.Attachments.Add($att)
$smtp.Send($msg)