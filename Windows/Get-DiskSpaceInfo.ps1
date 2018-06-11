$diskinfo = @()
$Compputer = Get-Content C:\Users\zengchuixin\Downloads\serverlist.txt
foreach ($s in $Compputer)
{
$disk = Invoke-Command -ScriptBlock {Get-WmiObject -Class win32_logicaldisk -ComputerName $s} |
Sort-Object -Property deviceID | select DeviceID,
@{l='FreeSpace(GB)';e={$_.FreeSpace/1GB -as [int]}},
@{l='Size(GB)';expression={$_.Size/1GB -as [int]}},
@{l='%Free';expression={$_.FreeSpace/$_.Size*100 -as [int]}},
SystemName
$diskinfo += $disk
}
$diskinfo | Export-Csv -Path C:\test.csv -NoTypeInformation -Encoding Default