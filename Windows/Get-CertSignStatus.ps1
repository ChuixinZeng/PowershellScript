Function Expand-AuthenticodeSignature($AuthenticodeSignature)
{
$AuthenticodeSignature | Select-object -Property Path,
Status,StatusMessage,SignatureType,
@{Name=’SubjectName’;Expression={($_.SignerCertificate.Subject)}},
@{Name='SubjectIssuer';Expression={($_.SignerCertificate.Issuer)}},
@{Name=’SubjectSerialNumber’;Expression={($_.SignerCertificate.SerialNumber)}},
@{Name='SubjectNotBefore';Expression={($_.SignerCertificate.NotBefore)}},
@{Name=’SubjectNotAfter’;Expression={($_.SignerCertificate.NotAfter)}},
@{Name='SubjectThumbprint';Expression={($_.SignerCertificate.ThumbPrint)}},
@{Name=’TimeStamperName’;Expression={($_.SignerCertificate.Subject)}},
@{Name='TimeStamperIssuer';Expression={($_.SignerCertificate.Issuer)}},
@{Name=’TimeStamperSerialNumber’;Expression={($_.SignerCertificate.SerialNumber)}},
@{Name='TimeStamperNotBefore';Expression={($_.SignerCertificate.NotBefore)}},
@{Name=’TimeStamperNotAfter’;Expression={($_.SignerCertificate.NotAfter)}}, `
@{Name=’TimeStamperThumbprint’;Expression={($_.SignerCertificate.ThumbPrint)}}}

$List=Get-ChildItem C:\Windows\*.exe | Get-AuthenticodeSignature

Expand-AuthenticodeSignature -AuthenticodeSignature $List | Export-Csv C:\report\working.csv

# https://devblogs.microsoft.com/scripting/reporting-on-digitally-signed-files-with-powershell/