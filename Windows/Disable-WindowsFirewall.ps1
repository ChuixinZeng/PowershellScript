function Disable-WindowsFirewall

#此function适合于测试环境，生产环境下请谨慎关闭防火墙

{

#检测防火墙状态
$firewallstatus = (Get-NetFirewallProfile -Name Domain,Public,Private).Enabled
#如果防火墙处于开启状态，则修改所有防火墙设置为关闭
if ($firewallstatus -contains "True")

{

Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled false

}

#如果防火墙已经处于关闭状态，则返回message
else
{

$writefirewallmessage = "你的防火墙处于关闭状态，无需配置！"
$writefirewallmessage

}

}

Disable-WindowsFirewall