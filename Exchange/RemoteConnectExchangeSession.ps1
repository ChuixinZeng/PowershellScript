$session = New-PSSession -ConfigurationName Microsoft.Exchange `
-ConnectionUri http://cas1.contoso.com/PowerShell/
Import-PSSession $session