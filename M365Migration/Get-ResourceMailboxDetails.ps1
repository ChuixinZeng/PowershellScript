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

### Validate and calculate report path
$ReportFolderValidated = $ReportFolder -Replace "(?<!\\)(?=.{0}$)", "\"
$CurrentDate = Get-Date -Format "MM-dd-yyyy_HHmm%s"
$ReportFile = $CurrentDate+"_MailboxSizeReport.csv"
$ReportPath = $ReportFolderValidated+$ReportFile

### Connect to Exchange Online
Connect-ExchangeOnline

### Gather list of mailboxes and store in a variable
$InputList = Get-Mailbox

### Retrieve resource mailbox details
ForEach($Entry in $InputList)
{
    $PrimarySmtpAddress = $Entry.PrimarySmtpAddress
    $RecipientType = $Entry.RecipientType
    $Name = $Entry.Name
    $PrimarySmtpAddress = $Entry.PrimarySmtpAddress
    $UserPrincipalName = $Entry.UserPrincipalName
    $Alias = $Entry.Alias
    $Office = $Entry.Office
    $ResourceCapacity = $Entry.ResourceCapacity
    $RoomMailboxAccountEnabled = $Entry.RoomMailboxAccountEnabled
    $ResourceType = $Entry.ResourceType
    $HiddenFromAddressListsEnabled = $Entry.HiddenFromAddressListsEnabled
    If($RecipientType -eq "ResourceMailbox")
    {
        Get-Mailbox -Identity $PrimarySmtpAddress |
        Get-CalendarProcessing |
        Select ScheduleOnlyDuringWorkHours,MaximumDurationInMinutes,AutomateProcessing,BookingWindowInDays,AllowRecurringMeetings,EnforceSchedulingHorizon |
        Add-Member -MemberType NoteProperty -Name Name -Value $Name -PassThru -Force |
        Add-Member -MemberType NoteProperty -Name PrimarySmtpAddress -Value $PrimarySmtpAddress -PassThru -Force |
        Add-Member -MemberType NoteProperty -Name UserPrincipalName -Value $UserPrincipalName -PassThru -Force |
        Add-Member -MemberType NoteProperty -Name Alias -Value $Alias -PassThru -Force |
        Add-Member -MemberType NoteProperty -Name Office -Value $Office -PassThru -Force |
        Add-Member -MemberType NoteProperty -Name ResourceCapacity -Value $ResourceCapacity -PassThru -Force |
        Add-Member -MemberType NoteProperty -Name RoomMailboxAccountEnabled -Value $RoomMailboxAccountEnabled -PassThru -Force |
        Add-Member -MemberType NoteProperty -Name ResourceType -Value $ResourceType -PassThru -Force |
        Add-Member -MemberType NoteProperty -Name HiddenFromAddressListsEnabled -Value $HiddenFromAddressListsEnabled -PassThru -Force |
        Export-Csv -Path $ReportPath -NoTypeInformation -Append
    }
}