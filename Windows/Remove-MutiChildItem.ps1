Get-ChildItem C:\LogDir\*.LOG | Where-Object { $_.LastWriteTime.adddays(7) -lt $Today } | Remove-Item -whatif

# 设置计划任务程序
PowerShell.exe -executionpolicy Bypass -file .\Cleanup.ps1