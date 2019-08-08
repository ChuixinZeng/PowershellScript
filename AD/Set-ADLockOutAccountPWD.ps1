$Password=’T00muchCh33r’
$SecurePassword=ConvertTo-SecureString -asplaintext -force $Password
$Locked=Search-ADAccount-LockedOut
Foreach ( $User in $Locked )
{
Set-ADAccountPassword -Identity:$User.DistinguishedName -NewPassword:$SecurePassword -Reset:$true -Server:"ContosoDC01.Contoso.Com"
Set-ADUser -ChangePasswordAtLogon:$true -Identity:$User.DistinguishedName -Server:" ContosoDC01.Contoso.Com "
}

# https://devblogs.microsoft.com/scripting/curly-blue-and-the-meaning-of-scripting-part-5/