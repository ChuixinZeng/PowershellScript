function Disable-UserAccessControl
{
	
	
	Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Value 00000000
	$useraccesscontrolturnoff = "用户访问控制UAC已关闭，请重启当前的计算机确保生效！"
	$useraccesscontrolturnoff
	
}