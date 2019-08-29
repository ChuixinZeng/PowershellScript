## 列出打印机

~~~ powershell
Get-WmiObject -Class Win32_Printer -ComputerName
(New-Object -ComObject WScript.Network).EnumPrinterConnections()
~~~


## 添加打印机

~~~ powershell
(New-Object -ComObject WScript.Network).AddWindowsPrinterConnection("\\Printserver01\Xerox5")
~~~

## 设置默认打印机

~~~ powershell
(Get-WmiObject -ComputerName . -Class Win32_Printer -Filter "Name='HP LaserJet 5Si'").SetDefaultPrinter()
(New-Object -ComObject WScript.Network).SetDefaultPrinter('HP LaserJet 5Si')
~~~

## 删除打印机

~~~ powershell
(New-Object -ComObject WScript.Network).RemovePrinterConnection("\\Printserver01\Xerox5")
~~~
