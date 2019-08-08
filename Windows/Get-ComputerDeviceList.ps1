Get-PnpDevice -PresentOnly

# 结果

<#
Status     Class           FriendlyName                                                                     InstanceId
------     -----           ------------                                                                     ----------
OK         HDC             标准 SATA AHCI 控制器                                                                 PCI\VEN_8086...
OK         Bluetooth       Qualcomm QCA61x4A Bluetooth                                                      USB\VID_0CF3...
OK         System          母板资源                                                                             ACPI\PNP0C02\1
OK         System          母板资源                                                                             ACPI\PNP0C02\2
OK         System          母板资源                                                                             ACPI\PNP0C02\5
OK         System          Microsoft ACPI 兼容的嵌入式控制器                                                         ACPI\PNP0C09\0
OK         Battery         Microsoft ACPI 兼容的控制方法电池                                                         ACPI\PNP0C0A\1
#>

# 查找连接到计算机的所有设备