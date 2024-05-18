### Create function for report folder input
Function Add-InputBox
{
    ### If there is a previous value stored in the Form variable, clear it
    $appForm = $null

    ### Add .NET Framework types required to build form
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    ### Specify standard distances between form objects
    $labelDistance = 50
    $textBoxDistance = 35
    $titleLabelVerticalLocation = 40
    
    ### Calculate form object locations
    $labelAVerticalLocation = $titleLabelVerticalLocation + $labelDistance + 20
    $textboxAVerticalLocation = $labelAVerticalLocation + $textBoxDistance

    $okButtonVerticalLocation = $textboxAVerticalLocation + $textBoxDistance*2.5

    $formHeight = ($okButtonVerticalLocation + $TitleLabelVerticalLocation)*1.25
    $formWidth = 850
    $inputIndent = 40
    $inputWidth = $formWidth - $inputIndent*3

    ### Create PowerShell form
    $appForm = New-Object System.Windows.Forms.Form
    $appForm.Text = "Application Input Variables"
    $appForm.Size = New-Object System.Drawing.Size($formWidth,$formHeight)
    $appForm.StartPosition = "CenterScreen"
    $appForm.Font = New-Object System.Drawing.Font("Calibri",12,[System.Drawing.FontStyle]::Regular)

    ### Create title label
    $titleLabel = New-Object System.Windows.Forms.Label
    $titleLabel.Location = New-Object System.Drawing.Point($inputIndent,$titleLabelVerticalLocation)
    $titleLabel.Size = New-Object System.Drawing.Size($inputWidth,50)
    $titleLabel.Font = New-Object System.Drawing.Font("Calibri",16,[System.Drawing.FontStyle]::Bold)
    $titleLabel.Text = "Application Details"
    $appForm.Controls.Add($titleLabel)

    ### Create label A
    $labelA = New-Object System.Windows.Forms.Label
    $labelA.Location = New-Object System.Drawing.Point($inputIndent,$labelAVerticalLocation)
    $labelA.Size = New-Object System.Drawing.Size($inputWidth,30)
    $labelA.Text = "Enter path to folder where report will be saved (Path\To\Folder\):"
    $appForm.Controls.Add($labelA)
    
    ### Create text box A
    $textBoxA = New-Object System.Windows.Forms.TextBox
    $textBoxA.Location = New-Object System.Drawing.Point($inputIndent,$textboxAVerticalLocation)
    $textBoxA.Size = New-Object System.Drawing.Size($inputWidth,10)
    $appForm.Controls.Add($textBoxA)
    
    ### Create OK button
    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Location = New-Object System.Drawing.Point(75,$okButtonVerticalLocation)
    $okButton.Size = New-Object System.Drawing.Size(94,29)
    $okButton.Text = "OK"
    $okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $appForm.AcceptButton = $okButton
    $appForm.Controls.Add($okButton)

    ### Create Cancel button
    $cancelButton = New-Object System.Windows.Forms.Button
    $cancelButton.Location = New-Object System.Drawing.Point(175,$okButtonVerticalLocation)
    $cancelButton.Size = New-Object System.Drawing.Size(94,29)
    $cancelButton.Text = "Cancel"
    $cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    $appForm.CancelButton = $cancelButton
    $appForm.Controls.Add($cancelButton)

    ### Specify whether form should always appear as top window on screen
    $appForm.Topmost = $true

    ### Activate the form and select text box A
    $appForm.Add_Shown({$textBoxA.Select()})
    $result = $appForm.ShowDialog()

    if ($result -eq [System.Windows.Forms.DialogResult]::OK)
    {
        $global:ReportFolder = $textBoxA.Text
    }
}

### Prompt for input values
Add-InputBox

### Validate report folder
$ReportFolderValidated = $ReportFolder -Replace "(?<!\\)(?=.{0}$)", "\"
$CurrentDate = Get-Date -Format "MM-dd-yyyy_HHmm%s"

### Calculate report file names
$FullAccessReportFile = $CurrentDate+"_FullAccessReport.csv"
$SendAsReportFile = $CurrentDate+"_SendAsReport.csv"
$SendOnBehalfReportFile = $CurrentDate+"_SendOnBehalfReport.csv"

### Calculate report paths
$FullAccessReportPath = $ReportFolderValidated+$FullAccessReportFile
$SendAsReportPath = $ReportFolderValidated+$SendAsReportFile
$SendOnBehalfReportPath = $ReportFolderValidated+$SendOnBehalfReportFile

### Retrieve a list of all mailboxes and store in a variable
Write-Host "Now retrieving data for all mailboxes and storing in a variable"
$InputList = Get-Mailbox -ResultSize Unlimited

### Loop through each mailbox to retrieve permissions
ForEach($Entry in $InputList)
{
    $PrimarySmtpAddress = $Entry.PrimarySmtpAddress.ToString()
    $UserPrincipalName = $Entry.UserPrincipalName.ToString()
    $MessageCopyForSentAsEnabled = $Entry.MessageCopyForSentAsEnabled.ToString()
    $IsShared = $Entry.IsShared.ToString()
    $IsResource = $Entry.IsResource.ToString()
    $IsLinked = $Entry.IsLinked.ToString()
    $IsRootPublicFolderMailbox = $Entry.IsRootPublicFolderMailbox.ToString()
    $IsMailboxEnabled = $Entry.IsMailboxEnabled.ToString()
    $Database = $Entry.Database.ToString()
    $ExchangeGuid = $Entry.ExchangeGuid.ToString()

### Retrieve the Full Access permissions on each mailbox and export to CSV
    Write-Host "Now retrieving Full Access permissions for mailbox $PrimarySmtpAddress"
    $FullAccessPermissions = $Entry |
    Get-MailboxPermission | 
    ? {($_.IsInherited -eq $False) -and -not ($_.User -match "NT AUTHORITY")} | 
    Select User,AccessRights

### Break out Full Access Permissions for each user
    ForEach($FullAccessPermission in $FullAccessPermissions)
    {
        $User = $FullAccessPermission.User
        $AccessRights = $FullAccessPermission | Select -ExpandProperty AccessRights
        $FormattedInfo = New-Object PSObject
        $FormattedInfo |
        Add-Member -MemberType NoteProperty -Name PrimarySmtpAddress -Value $PrimarySmtpAddress -PassThru -Force |
        Add-Member -MemberType NoteProperty -Name UserPrincipalName -Value $UserPrincipalName -PassThru -Force |
        Add-Member -MemberType NoteProperty -Name IsShared -Value $IsShared -PassThru -Force |
        Add-Member -MemberType NoteProperty -Name IsResource -Value $IsResource -PassThru -Force |
        Add-Member -MemberType NoteProperty -Name IsLinked -Value $IsLinked -PassThru -Force |
        Add-Member -MemberType NoteProperty -Name IsRootPublicFolderMailbox -Value $IsRootPublicFolderMailbox -PassThru -Force |
        Add-Member -MemberType NoteProperty -Name IsMailboxEnabled -Value $IsMailboxEnabled -PassThru -Force |
        Add-Member -MemberType NoteProperty -Name Database -Value $Database -PassThru -Force |
        Add-Member -MemberType NoteProperty -Name ExchangeGuid -Value $ExchangeGuid -PassThru -Force |
        Add-Member -MemberType NoteProperty -Name User -Value $User -PassThru -Force |
        Add-Member -MemberType NoteProperty -Name AccessRights -Value $AccessRights -PassThru -Force |

### Export to CSV with append using ConvertTo-Csv and Out-File because Append switch not available in PowerShell 2.0
        ConvertTo-Csv -NoTypeInformation | 
        Select-Object -Skip 1 | 
        Out-File -Append -FilePath $FullAccessReportPath
    }

### Retrieve the Send As permissions on each mailbox and export to CSV
    Write-Host "Now retrieving Send As permissions for mailbox $PrimarySmtpAddress"
    $SendAsPermissions = $Entry |
    Get-ADPermission | 
    ? {$_.ExtendedRights -like "*send*" -and -not ($_.User -match "NT AUTHORITY")} | 
    Select User,ExtendedRights
### Break out Send As Permissions for each user
    ForEach($SendAsPermission in $SendAsPermissions)
    {
        $User = $SendAsPermission.User
        $ExtendedRights = $SendAsPermission | Select -ExpandProperty ExtendedRights
        $FormattedInfo = New-Object PSObject
        $FormattedInfo |
        Add-Member -MemberType NoteProperty -Name PrimarySmtpAddress -Value $PrimarySmtpAddress -PassThru -Force |
        Add-Member -MemberType NoteProperty -Name UserPrincipalName -Value $UserPrincipalName -PassThru -Force |
        Add-Member -MemberType NoteProperty -Name IsShared -Value $IsShared -PassThru -Force |
        Add-Member -MemberType NoteProperty -Name IsResource -Value $IsResource -PassThru -Force |
        Add-Member -MemberType NoteProperty -Name IsLinked -Value $IsLinked -PassThru -Force |
        Add-Member -MemberType NoteProperty -Name IsRootPublicFolderMailbox -Value $IsRootPublicFolderMailbox -PassThru -Force |
        Add-Member -MemberType NoteProperty -Name IsMailboxEnabled -Value $IsMailboxEnabled -PassThru -Force |
        Add-Member -MemberType NoteProperty -Name Database -Value $Database -PassThru -Force |
        Add-Member -MemberType NoteProperty -Name ExchangeGuid -Value $ExchangeGuid -PassThru -Force |
        Add-Member -MemberType NoteProperty -Name User -Value $User -PassThru -Force |
        Add-Member -MemberType NoteProperty -Name ExtendedRights -Value $ExtendedRights -PassThru -Force |
        Add-Member -MemberType NoteProperty -Name MessageCopyForSentAsEnabled -Value $MessageCopyForSentAsEnabled -PassThru -Force |

### Export to CSV with append using ConvertTo-Csv and Out-File because Append switch not available in PowerShell 2.0
        ConvertTo-Csv -NoTypeInformation | 
        Select-Object -Skip 1 | 
        Out-File -Append -FilePath $SendAsReportPath
    }

### Retrieve the Send on Behalf permissions on each mailbox and export to CSV
    Write-Host "Now retrieving Send on Behalf permissions for mailbox $PrimarySmtpAddress"
    $Entry |
    Select PrimarySmtpAddress,UserPrincipalName,IsShared,IsResource,IsLinked,IsRootPublicFolderMailbox,IsMailboxEnabled,Database,ExchangeGuid,@{Name=”GrantSendOnBehalfTo";Expression={$_.GrantSendOnBehalfTo -Join “;”}},MessageCopyForSendOnBehalfEnabled |

### Export to CSV with append using ConvertTo-Csv and Out-File because Append switch not available in PowerShell 2.0
    ConvertTo-Csv -NoTypeInformation | 
    Select-Object -Skip 1 | 
    Out-File -Append -FilePath $SendOnBehalfReportPath
}