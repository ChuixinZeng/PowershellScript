<#
.Synopsis
The server should have internet enabled for MAK Activation to be successful.
.Description
This function will activate the server using MAK activation procedure.
.Parameter Key
The right MAK key has to be entered for the OS Activation.
Data from this parameter is Mandatory
.Example
Activating server.
MAK-Activate -key XXXXX-XXXXX-XXXXX-XXXXX-XXXXX
#>

Function MAK-Activate {


   [CmdletBinding()]
    Param(
        
        [Parameter(Mandatory=$True,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
        [String[]]$key
                
    )


    Begin
    {
      

    }
    Process
    {

        try{
        
            #Inserting the KEY
            $insertKey = cscript c:\windows\system32\slmgr.vbs /ipk $key
        
            $retryCount = 3
        
            while ($retryCount -gt 0)
            {
            
                Write-Output "Activating License Key..."

                #trying to activate....
            
                cscript c:\windows\system32\slmgr.vbs /ato

                Write-Output "Verifying Activation Status..."

                #checking the activation status.....

                $slmgrResult = cscript c:\windows\system32\slmgr.vbs /dli
            
                [string]$licenseStatus = ($slmgrResult | select-string -pattern "^License Status:")
            
                $licenseStatus = $LicenseStatus.Remove(0,16)

                if ( $licenseStatus -match "Licensed") 
                {
                    Write-Host "Activation Sucessful" -ForegroundColor Green
                    
                    $retryCount = 0
                }
                
                else
                {
                    Write-Host "Activation failed." -ForegroundColor Red
                
                    $retryCount = $retryCount - 1
            }

            if ( $retryCount -gt 0 ) 
            {
                    Write-Host "Retrying Activation. Will try $retryCount more time(s)" -ForegroundColor Yellow
            }
        }
    }

    catch
    {
        Write-Warning "Error during activation!" 
    }

  }
   
   
    End
    {
    
    }
}