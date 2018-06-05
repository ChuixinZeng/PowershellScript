Get-SendConnector | select AddressSpaces,Name,MaxMessageSize,Enabled,IsSmtpConnector,Port,WhenCreated,WhenChang
ed | Export-Csv C:\connector.csv -Encoding default -NoTypeInformation