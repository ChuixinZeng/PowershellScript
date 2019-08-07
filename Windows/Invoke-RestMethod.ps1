Invoke-RestMethod -Uri 'https://blogs.technet.microsoft.com/heyscriptingguy/rss.aspx'
# 如何使用Invoke-RestMethod从RSS源中读取条目列表
<#

title       : PowerTip: Identify the last time a User was Synchronized to AzureAD
link        : https://devblogs.microsoft.com/scripting/powertip-identify-the-last-time-a-user-was-synchronized-to-azuread/
comments    : {https://devblogs.microsoft.com/scripting/powertip-identify-the-last-time-a-user-was-synchronized-to-azuread/#respond, 0}
pubDate     : Wed, 31 Jul 2019 20:00:46 +0000
creator     : creator
category    : {category, category, category, category}
guid        : guid
description : description
encoded     : encoded
commentRss  : https://devblogs.microsoft.com/scripting/powertip-identify-the-last-time-a-user-was-synchronized-to-azuread/feed/

title       : Reporting on Microsoft 365 Licensing using PowerShell – Part 1
link        : https://devblogs.microsoft.com/scripting/reporting-on-microsoft-365-licensing-using-powershell-part-1/
comments    : {https://devblogs.microsoft.com/scripting/reporting-on-microsoft-365-licensing-using-powershell-part-1/#respond, 0}
pubDate     : Wed, 31 Jul 2019 17:00:38 +0000
creator     : creator
category    : {category, category, category, category...}
guid        : guid
description : description
encoded     : encoded
commentRss  : https://devblogs.microsoft.com/scripting/reporting-on-microsoft-365-licensing-using-powershell-part-1/feed/

title       : PowerTip: Show files with expired Digital Certificates
link        : https://devblogs.microsoft.com/scripting/powertip-show-files-with-expired-digital-certificates/
comments    : {https://devblogs.microsoft.com/scripting/powertip-show-files-with-expired-digital-certificates/#respond, 0}
pubDate     : Wed, 24 Jul 2019 23:00:20 +0000
creator     : creator
category    : {category, category, category, category}
guid        : guid
description : description
encoded     : encoded
commentRss  : https://devblogs.microsoft.com/scripting/powertip-show-files-with-expired-digital-certificates/feed/

title       : Reporting on Digitally Signed Files with PowerShell
link        : https://devblogs.microsoft.com/scripting/reporting-on-digitally-signed-files-with-powershell/
comments    : {https://devblogs.microsoft.com/scripting/reporting-on-digitally-signed-files-with-powershell/#comments, 1}
pubDate     : Wed, 24 Jul 2019 18:32:34 +0000
creator     : creator
category    : {category, category, category, category...}
guid        : guid
description : description
encoded     : encoded
commentRss  : https://devblogs.microsoft.com/scripting/reporting-on-digitally-signed-files-with-powershell/feed/

title       : Clean up Domain Controller DNS Records with Powershell
link        : https://devblogs.microsoft.com/scripting/86099-2/
comments    : {https://devblogs.microsoft.com/scripting/86099-2/#respond, 0}
pubDate     : Wed, 17 Jul 2019 20:00:18 +0000
creator     : creator
category    : {category, category, category, category...}
guid        : guid
description : description
encoded     : encoded
commentRss  : https://devblogs.microsoft.com/scripting/86099-2/feed/

title       : PowerTip: Use PowerShell to pick a random name from a list
link        : https://devblogs.microsoft.com/scripting/powertip-use-powershell-to-pick-a-random-name-from-a-list/
comments    : {https://devblogs.microsoft.com/scripting/powertip-use-powershell-to-pick-a-random-name-from-a-list/#comments, 1}
pubDate     : Sat, 15 Sep 2018 07:00:50 +0000
creator     : creator
category    : {category, category, category, category...}
guid        : guid
description : description
encoded     : encoded
commentRss  : https://devblogs.microsoft.com/scripting/powertip-use-powershell-to-pick-a-random-name-from-a-list/feed/

title       : Using PowerShell to create a folder of Demo data
link        : https://devblogs.microsoft.com/scripting/using-powershell-to-create-a-folder-of-demo-data/
comments    : {https://devblogs.microsoft.com/scripting/using-powershell-to-create-a-folder-of-demo-data/#comments, 2}
pubDate     : Sat, 15 Sep 2018 07:00:32 +0000
creator     : creator
category    : {category, category, category, category...}
guid        : guid
description : description
encoded     : encoded
commentRss  : https://devblogs.microsoft.com/scripting/using-powershell-to-create-a-folder-of-demo-data/feed/

title       : PowerTip: Turn off the power to your computer with PowerShell
link        : https://devblogs.microsoft.com/scripting/powertip-turn-off-the-power-to-your-computer-with-powershell/
comments    : {https://devblogs.microsoft.com/scripting/powertip-turn-off-the-power-to-your-computer-with-powershell/#comments, 1}
pubDate     : Mon, 16 Jul 2018 18:00:05 +0000
creator     : creator
category    : {category, category, category, category}
guid        : guid
description : description
encoded     : encoded
commentRss  : https://devblogs.microsoft.com/scripting/powertip-turn-off-the-power-to-your-computer-with-powershell/feed/

title       : Parse HTML and pass to Cognitive Services Text-to-Speech
link        : https://devblogs.microsoft.com/scripting/parse-html-and-pass-to-cognitive-services-text-to-speech/
comments    : {https://devblogs.microsoft.com/scripting/parse-html-and-pass-to-cognitive-services-text-to-speech/#respond, 0}
pubDate     : Mon, 16 Jul 2018 07:01:39 +0000
creator     : creator
category    : {category, category, category, category}
guid        : guid
description : description
encoded     : encoded
commentRss  : https://devblogs.microsoft.com/scripting/parse-html-and-pass-to-cognitive-services-text-to-speech/feed/

title       : PowerTip: Determine your version of PowerShell and host operating system
link        : https://devblogs.microsoft.com/scripting/powertip-determine-your-version-of-powershell-and-host-operating-system/
comments    : {https://devblogs.microsoft.com/scripting/powertip-determine-your-version-of-powershell-and-host-operating-system/#respond, 0}
pubDate     : Fri, 29 Jun 2018 18:00:54 +0000
creator     : creator
category    : {category, category, category, category}
guid        : guid
description : description
encoded     : encoded
commentRss  : https://devblogs.microsoft.com/scripting/powertip-determine-your-version-of-powershell-and-host-operating-system/feed/
#>

# 下面是另外一个示例脚本：https://devblogs.microsoft.com/scripting/script-wars-the-farce-awakens-part-iv/

$ShippingManifest='m.pdf'

$ShippingApplicationRESTAPI='https://shipping.contoso.com/api.svc'

$ShippingApplicationMethod='GET'

$ResultOfShippingQuery=Invoke-RestMethod -Uri $ShippingApplicationRESTAPI -Method $ShippingApplicationMethod -OutFile $ShippingManifest

$ShippingStatus=$ResultOfShippingQuery.result

If ($ShippingStatus -eq 'SUCCESS')

{

$From='shippingsystem@contoso.local'

$Bcc='ship@contoso.local'

$SMTPServer='smtp.contoso.com'

$To=$ResultOfShippingQuery.email

$ShipmentDate=$ResultofShippingQuery.date

$CustomerName=$ResultOfShippingQuery.Name

$Subject='Shipping Confirmation'

$Body="Confirmation of Shipment for Customer $CustomerName - Shipped $ShipmentDate"

Send-MailMessage -Attachments $ShippingManifest -Bcc $Bcc -From $From -Body $Subject -To $To `

-Subject $Subject -SmtpServer $SMTPServer

}

else

{

Write-Host "Tr Err $ShippingStatus"

}