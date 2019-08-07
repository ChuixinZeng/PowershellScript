$array = @()
Get-ChildItem -Path Cert:\LocalMachine -Recurse |
Where-Object {$_.PSISContainer -eq $false} |
ForEach-Object ({
    $obj = New-Object -TypeName PSObject
    $obj | Add-Member -MemberType NoteProperty -Name "PSPath" -Value $_.PSPath
    $obj | Add-Member -MemberType NoteProperty -Name "FriendlyName" -Value $_.FriendlyName
    $obj | Add-Member -MemberType NoteProperty -Name "Issuer" -Value $_.Issuer
    $obj | Add-Member -MemberType NoteProperty -Name "NotAfter" -Value $_.NotAfter
    $obj | Add-Member -MemberType NoteProperty -Name "NotBefore" -Value $_.NotBefore
    $obj | Add-Member -MemberType NoteProperty -Name "SerialNumber" -Value $_.SerialNumber
    $obj | Add-Member -MemberType NoteProperty -Name "Thumbprint" -Value $_.Thumbprint
    $obj | Add-Member -MemberType NoteProperty -Name "DnsNameList" -Value $_.DnsNameList
    $obj | Add-Member -MemberType NoteProperty -Name "Subject" -Value $_.Subject
    $obj | Add-Member -MemberType NoteProperty -Name "Version" -Value $_.Version
    $obj | Add-Member -MemberType NoteProperty -Name "PSProvider" -value $_.PSProvider
    $array += $obj
    $obj = $null
})

$array | Export-Csv -Path "C:\temp.csv"