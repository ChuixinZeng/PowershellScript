Get-CimInstance -Class win32_quickfixengineering | Where-Object { $_.InstalledOn -gt (Get-Date).AddMonths(-3) }

<#
Source        Description      HotFixID      InstalledBy          InstalledOn
------        -----------      --------      -----------          -----------
              Update           KB4346084     NT AUTHORITY\SYSTEM  2019/5/16 0:00:00
              Security Update  KB4497398     NT AUTHORITY\SYSTEM  2019/5/15 0:00:00
              Security Update  KB4497932     NT AUTHORITY\SYSTEM  2019/5/15 0:00:00
              Security Update  KB4503308     NT AUTHORITY\SYSTEM  2019/6/14 0:00:00
              Security Update  KB4509094     NT AUTHORITY\SYSTEM  2019/7/13 0:00:00
              Security Update  KB4507435     NT AUTHORITY\SYSTEM  2019/7/13 0:00:00
#>