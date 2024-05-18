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

    $labelBVerticalLocation = $textboxAVerticalLocation + $labelDistance + 20
    $textboxBVerticalLocation = $labelBVerticalLocation + $textBoxDistance

    $labelCVerticalLocation = $textboxBVerticalLocation + $labelDistance + 20
    $textboxCVerticalLocation = $labelCVerticalLocation + $textBoxDistance

    $okButtonVerticalLocation = $textboxCVerticalLocation + $textBoxDistance*2.5

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
    $labelA.Text = "Enter the FQDN of a domain controller (server.domain.com):"
    $appForm.Controls.Add($labelA)
    
    ### Create text box A
    $textBoxA = New-Object System.Windows.Forms.TextBox
    $textBoxA.Location = New-Object System.Drawing.Point($inputIndent,$textboxAVerticalLocation)
    $textBoxA.Size = New-Object System.Drawing.Size($inputWidth,10)
    $appForm.Controls.Add($textBoxA)

    ### Create label B
    $labelB = New-Object System.Windows.Forms.Label
    $labelB.Location = New-Object System.Drawing.Point($inputIndent,$labelBVerticalLocation)
    $labelB.Size = New-Object System.Drawing.Size($inputWidth,30)
    $labelB.Text = "Enter the AD Forest Root (domain.com):"
    $appForm.Controls.Add($labelB)
    
    ### Create text box B
    $textBoxB = New-Object System.Windows.Forms.TextBox
    $textBoxB.Location = New-Object System.Drawing.Point($inputIndent,$textboxBVerticalLocation)
    $textBoxB.Size = New-Object System.Drawing.Size($inputWidth,10)
    $appForm.Controls.Add($textBoxB)

    ### Create label C
    $labelC = New-Object System.Windows.Forms.Label
    $labelC.Location = New-Object System.Drawing.Point($inputIndent,$labelCVerticalLocation)
    $labelC.Size = New-Object System.Drawing.Size($inputWidth,30)
    $labelC.Text = "Enter path to folder where report will be saved (Path\To\Folder\):"
    $appForm.Controls.Add($labelC)
    
    ### Create text box C
    $textBoxC = New-Object System.Windows.Forms.TextBox
    $textBoxC.Location = New-Object System.Drawing.Point($inputIndent,$textboxCVerticalLocation)
    $textBoxC.Size = New-Object System.Drawing.Size($inputWidth,10)
    $appForm.Controls.Add($textBoxC)

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
        $global:DomainController = $textBoxA.Text
        $global:ForestRoot = $textBoxB.Text
        $global:ReportFolder = $textBoxC.Text
    }
}

### Prompt for input values
Add-InputBox

### Validate and calculate report path
$ReportFolderValidated = $ReportFolder -Replace "(?<!\\)(?=.{0}$)", "\"
$CurrentDate = Get-Date -Format "MM-dd-yyyy_HHmm%s"
$ReportFile = $CurrentDate+"_ActiveDirectoryDomainReport.csv"
$ReportPath = $ReportFolderValidated+$ReportFile

### Retrieve AD Forest-level details
Get-ADForest -Server $DomainController -Identity $ForestRoot |
Select Name,RootDomain,@{Name=”Domains";Expression={$_.Domains -Join “;”}},ForestMode,@{Name=”UPNSuffixes";Expression={$_.UPNSuffixes -Join “;”}} |
Export-Csv $ReportPath -NoTypeInformation