# 问题
# 字段显示
# Microsoft.ActiveDirectory.Management.ADPropertyValueCollection"


# 解决
# 加sring转换一下字符串类型
# https://social.technet.microsoft.com/Forums/sharepoint/en-US/eb58b98b-cd3f-4ad9-b75f-cf50abb80d31/cant-query-some-attributes?forum=winserverpowershell

$FormatEnumerationLimit = -1
$user = Import-Csv C:\zyc\64.txt
foreach ($u in $user)
{
Get-ADUser -Identity $u.name -Properties * | 
Select-Object @{n="proxyAddresses";e={[string]$_.proxyAddresses}} | Export-Csv C:\1.csv -NoTypeInformation -Append
}