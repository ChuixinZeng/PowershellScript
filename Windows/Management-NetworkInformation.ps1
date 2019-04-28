
# (一）查看IP地址信息

Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=$true -ComputerName . | Format-Table -Property IPAddress

# 输出结果如下
'''
IPAddress
---------
{10.1.1.1, fe80::79f3:f2e6:52f2:72xx}
'''

# （二）为什么IP地址的结果是大括号包括的？因为结果是一个数组，可以查看IPAddrss的属性如下

Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=$true -ComputerName . | Get-Member -Name IPAddress

# 结果如下
'''
TypeName:System.Management.ManagementObject#root\cimv2\Win32_NetworkAdapterConfiguration

Name      MemberType Definition
----      ---------- ----------
IPAddress Property   string[] IPAddress {get;set;}
'''

# （三）列出IP配置信息

Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=$true -ComputerName .

# 如果你对 IPX 或 WINS 属性不感兴趣（可能是在使用现代 TCP/IP 网络的情况下），则可以使用 Select-Object 的 ExcludeProperty 参数来隐藏其名称以“WINS”或“IPX:”开头的属性
Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=$true -ComputerName . | Select-Object -Property [a-z]* -ExcludeProperty IPX*,WINS*

# （四）ping计算机连通性(state为0，代表成功)

Get-WmiObject -Class Win32_PingStatus -Filter "Address='127.0.0.1'" -ComputerName .
'''
Source        Destination     IPV4Address      IPV6Address                              Bytes    Time(ms)
------        -----------     -----------      -----------                              -----    --------
ZENGCHUIXI... 127.0.0.1       10.1.1.1      fe80::79f3:f2e6:52f2:72be%10             32       0
'''

# 批量ping

'127.0.0.1','localhost','research.microsoft.com' | ForEach-Object `
-Process {Get-WmiObject -Class Win32_PingStatus -Filter ("Address='" + $_ + "'") -ComputerName .} | `
Select-Object -Property Address,ResponseTime,StatusCode

'''
Address                ResponseTime StatusCode
-------                ------------ ----------
127.0.0.1                         0          0
localhost                         0          0
research.microsoft.com                   11010
'''

# 对一个子网执行ping操作

1..254| ForEach-Object `
-Process {Get-WmiObject -Class Win32_PingStatus -Filter ("Address='192.168.1." + $_ + "'") -ComputerName .} | `
Select-Object -Property Address,ResponseTime,StatusCode

$ips = 1..254 | ForEach-Object -Process {'192.168.1.' + $_}
$ips

# (五) 配置网络适配器（属性，例如DNS、DHCP等）

Get-WmiObject -Class Win32_NetworkAdapter -ComputerName .

'''
ServiceName      : kdnic
MACAddress       :
AdapterType      :
DeviceID         : 0
Name             : Microsoft Kernel Debug Network Adapter
NetworkAddresses :
Speed            :
'''

# 为活跃网络适配器分配DNS区域（一般除了域后缀，还需要指定其他后缀的时候，可以设定）
# 下面两条命令的效果一样，不同之处在于筛选的方式不一样
# 筛选语句“IPEnabled=$true”是必需的，因为即使是在仅使用 TCP/IP 的网络上，计算机上的多个网络适配器配置也不是真正的 TCP/IP 适配器
Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=$true -ComputerName . | ForEach-Object -Process { $_. SetDNSDomain('fabrikam.com') }
Get-WmiObject -Class Win32_NetworkAdapterConfiguration -ComputerName . | Where-Object -FilterScript {$_.IPEnabled} | ForEach-Object -Process {$_.SetDNSDomain('fabrikam.com')}

# 查找计算机上已经启用了DHCP的网络适配器信息
Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter "DHCPEnabled=$true" -ComputerName .
Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter "IPEnabled=$true and DHCPEnabled=$true" -ComputerName .

#查看网络适配器DHCP相关的属性信息
Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter "DHCPEnabled=$true" -ComputerName . | Format-Table -Property DHCP*
'''
escription                                 DHCPEnabled DHCPLeaseExpires          DHCPLeaseObtained         DHCPServer  Index
-----------                                 ----------- ----------------          -----------------         ----------  -----
Microsoft Kernel Debug Network Adapter             True                                                                     0
Qualcomm QCA61x4A 802.11ac Wireless Adapter        True                                                                     1
Realtek PCIe GBE Family Controller                 True 19320816062542.000000+480 19320717062542.000000+480 10.16.0.216     2
Microsoft Wi-Fi Direct Virtual Adapter             True                                                                     3
Bluetooth Device (Personal Area Network)           True                                                                     4
Microsoft Wi-Fi Direct Virtual Adapter             True                                                                     6
'''

# 在所有适配器上启用DHCP
# 可以使用 Filter 语句“IPEnabled=$true and DHCPEnabled=$false”，以免在已启用 DHCP 的适配器上再次启用它，但忽略这一步也不会导致错误出现
Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=$true -ComputerName . | ForEach-Object -Process {$_.EnableDHCP()}

# 释放或续订DHCP租约信息（第一条命令是查询命令，先看看命令支持的类信息

Get-WmiObject -List | Where-Object -FilterScript {$_.Name -eq 'Win32_NetworkAdapterConfiguration'}
( Get-WmiObject -List | Where-Object -FilterScript {$_.Name -eq 'Win32_NetworkAdapterConfiguration'} ).ReleaseDHCPLeaseAll()
( Get-WmiObject -List | Where-Object -FilterScript {$_.Name -eq 'Win32_NetworkAdapterConfiguration'} ).RenewDHCPLeaseAll()

#（六）管理网络共享(创建、删除、映射)

(Get-WmiObject -List -ComputerName . | Where-Object -FilterScript {$_.Name -eq 'Win32_Share'}).Create('C:\temp','TempShare',0,25,'test share of the temp folder')
# 也可以使用
net share tempshare=c:\temp /users:25 /remark:"test share of the temp folder"
# 删除
(Get-WmiObject -Class Win32_Share -ComputerName . -Filter "Name='TempShare'").Delete()
net share tempshare /delete

# 映射网络驱动器
(New-Object -ComObject WScript.Network).MapNetworkDrive('B:', '\\FPS01\users')

net use B: \\FPS01\users
