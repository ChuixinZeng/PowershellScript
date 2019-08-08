# 获取WIFI的配置信息（名称、密码等）

$output = netsh.exe wlan show profiles name="test AP" key=clear

$ssidsearchredult = $output | Select-String -Pattern 'SSID Name'

$profilename = ($ssidsearchredult -split ":")[-1].Trim() -replace '"'

$pwsearchresult = $output | Select-String -Pattern 'Key Content'
$pw = {$pwsearchresult -split ":"}[-1].Trim() -replace '"'

[PSCustomObject]@{
    wifiprofilename = $profilename
    password = $pw
}

# https://devblogs.microsoft.com/scripting/get-wireless-network-ssid-and-password-with-powershell/
