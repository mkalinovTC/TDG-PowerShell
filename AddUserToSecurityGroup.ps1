#generic function to log
function Write-Log {
  Param(
    [Parameter(Mandatory=$true, Position=0)]
    [ValidateNotNullOrEmpty()]
    [string]$Message,
    [Parameter(Mandatory=$false, Position=1)]
    [ValidateSet('Error', 'Warning', 'Information', 'Verbose', 'Debug')]
    [string]$LogLevel = 'Information'
  )

  $completeMessage = "${LogLevel}: $Message"

  switch ($LogLevel) {
    'Error'       { Write-Host -ForegroundColor Red $completeMessage }
    'Warning'     { Write-Host -ForegroundColor Yellow $completeMessage }
    'Information' { Write-Host -ForegroundColor Green $completeMessage }
    'Verbose'     { Write-Host -ForegroundColor Gray $completeMessage }
    'Debug'       { Write-Host -ForegroundColor Black $completeMessage }
    default       { throw "Invalid log level: $_" }
  }
}



##check for and install AzureRM module - this module required to associate certificate to the app registration
#try {
#    $AzureRM = 'AzureRM'
#
#    if (!(Get-Module -ListAvailable -Name $AzureRM)) {
#        Write-Log "$AzureRM not installed. $AzureRM module will be installed as it is required to add the certificate to the app registration." "Warning"
#        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
#        Install-Module -Name AzureRM
#        Write-Log "Installed Successfully $AzureRM." "Information"
#    }
#    else {
#        Write-Log "$AzureRM already installed" "Information"
#    }
#
#    #import the AzureRM module functions required later
#    Import-Module -Name AzureRM
#}
#catch {
#    Write-host $_.Exception.Message
#}


#admin account that will create the certificate
$accountid = "TDG.Core@034gc.onmicrosoft.com"

#azure environment
$azureEnvironmentName = [Microsoft.Open.Azure.AD.CommonLibrary.AzureEnvironment+EnvironmentName]::AzureCloud

#azure tenant
$tenantid = "2008ffa9-c9b2-4d97-9ad9-4ace25386be7"

#azure group to add users to
$groupId = "9ff73295-ab47-46f6-81df-6e382a6548c5"

#application registration object id related to the service principle. Created certificates have to be added to the application registration in Azure.
$appId = "a6adc57f-f130-4e0e-8cab-c0d6a26f8273"
$subscriptionid = "NPRD" #"PROD"

#certificate information
$certificatePath = 'Cert:\LocalMachine\My'
$certificateFolderName = 'c:\romcertificates'
$certificateFileName = 'tdgcoreuser.cer'
$certificateFilePath = "${certificateFolderName}\${certificateFileName}"


#Login to Azure AD PowerShell With Admin Account
#===========================================================
#no one specific
#Connect-AzureAD 

#TDG CORE USER
$credential = Connect-AzureAD -TenantId $tenantid -AzureEnvironmentName $azureEnvironmentName -AccountId $accountid
Write-Log "Connected to ${azureEnvironmentName} on tenant ${tenantid} with accountid ${accountid}" "Information"
#===========================================================


#CREATE THE CERTIFICATE FOLDER IF IT DOES NOT EXIST
If(!(test-path $certificateFolderName))
{
      New-Item -ItemType Directory -Force -Path $certificateFolderName
      Write-Log "Folder $certificateFolderName did not exist and has been created." "Warning"
}
else
{
      Write-Log "Folder $certificateFolderName already exists and will be reused." "Information"
}


$certificate = Get-ChildItem -Path $certificatePath -DnsName *${accountid}* | Select-Object -first 1 #| Remove-Item
if ($certificate -eq $null) 
{
    Write-Log "Certificate for ${accountid} does not exist. Creating new certificate at $certificatePath" "Warning"
        # Create the self signed cert
    $currentDate = Get-Date
    $endDate = $currentDate.AddYears(1)
    $notAfter = $endDate.AddYears(1)
    $certificate = (New-SelfSignedCertificate -CertStoreLocation $certificatePath -DnsName ${accountid} -KeyExportPolicy Exportable -Provider "Microsoft Enhanced RSA and AES Cryptographic Provider" -NotAfter $notAfter)
    $thumb = $certificate.Thumbprint
    
    Write-Log "Certificate for ${accountid} created. Thumbprint: ${thumb}" "Information"

    $pwd = "Oversight3!"
    $pwd = ConvertTo-SecureString -String $pwd -Force -AsPlainText

    Export-Certificate -Type CERT -Cert $certificate -FilePath $certificateFilePath

    Write-Log "Certificate for ${accountid} exported to $certificateFilePath. Thumbprint: ${thumb}" "Information"
}
else
{
    $thumb = $certificate.Thumbprint
    Write-Log "Certificate for ${accountid} already exist and will be reused. Thumbprint: ${thumb}" "Information"
}


##associate the certificate with the application registration
#$keyValue = [System.Convert]::ToBase64String($certificate.GetRawCertData())
#Connect-AzureRmAccount -Subscription $subscriptionid -Tenant $tenantid -AccountId $accountid
#New-AzureRmADAppCredential -ApplicationId $appId -CertValue $keyValue -StartDate $certificate.GetEffectiveDateString() -EndDate $certificate.GetExpirationDateString() 


#now we can connect as the TDG CORE Service Principle that is connected to the TDG Core App Registration
#Connect-AzureAD -TenantId $tenantid -ApplicationId $appId -CertificateThumbprint $thumb
carole-ann.mahoney

#can query by name or objectId
$groupid = Get-AzureADGroup -ObjectId "9ff73295-ab47-46f6-81df-6e382a6548c5" #-SearchString "ROMTDG-USERLIST"
$useradd = Get-AzureADUser | select userprincipalname,objectid | where {$_.UserPrincipalName -like ‘carole-ann.mahoney@tc.gc.ca’}
$users = $useradd.objectId
foreach($user in $users){Add-AzureADGroupMember -ObjectId $groupid.ObjectId -RefObjectId $user}
# SIG # Begin signature block
# MIIFpQYJKoZIhvcNAQcCoIIFljCCBZICAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU3JYghRQOVAF/9PuP6BHAkuNG
# DK6gggM5MIIDNTCCAh2gAwIBAgIQd4fU+4/9kaFA69GGrZCBpjANBgkqhkiG9w0B
# AQUFADAhMR8wHQYDVQQDDBZhYXJvbi5sZWJsYW5jQFRDLkdDLkNBMB4XDTIxMDcw
# OTA0MTg0N1oXDTIzMDcwOTA0Mjg0N1owITEfMB0GA1UEAwwWYWFyb24ubGVibGFu
# Y0BUQy5HQy5DQTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAJ2jjxuK
# u3KVvRgoP68UqnnoPvWh+REEDIk1Q3YifglLSHKKfDTGfsbzZ2LegOPnIHiUA/bD
# WfNS+aqxCJd2rVYOA6wLiFsNwV/AZjqwPqWqZX4fNJJszDMQBISTB0uYNveTlSRD
# HJa+bvtyO+rvWtMLqPiQo8tlNbV20DQikU+ntDeBxDHwS92oTrGIFQ5feXvQWuHE
# 8c2v+TVJmUOeO9ID6YYxfKF5F/jY0QrnaidaecK0R++DLpozU3ovAAEqkaF8x5F1
# 0Q8a+6sfrFY1omKhHDBHI8U9xpnCjY1tPtz/wsrA+MGzG1OfvMO4nH1GKrC/TdOD
# 5ptS+b8UwVAa3r0CAwEAAaNpMGcwDgYDVR0PAQH/BAQDAgeAMBMGA1UdJQQMMAoG
# CCsGAQUFBwMDMCEGA1UdEQQaMBiCFmFhcm9uLmxlYmxhbmNAVEMuR0MuQ0EwHQYD
# VR0OBBYEFPMyFCNOAIFHYMN12k4N5Hrskj5LMA0GCSqGSIb3DQEBBQUAA4IBAQBK
# +oM4WRRMkgMk/T0wpUDlpHk2wNRlHSGSciUaDPCK7vwdnWKNqWlj4/o7KVs7kpdv
# HThcYeHIvK5LoyVZXmlV00y+F3cLdpXOsxavtnnuz/Q/Hod7RfP2iicAsKlRUG0Z
# mDTy4wyoSPlRfZ3CB1kFo8tN8YwauslZqNHCBF3ChxNm4VWjXHBSwmNp+1Ro+36N
# SWDRfwSN4vEdblePgptEz2to9396cG9b+ivWIjMqAGJEne9xbF5L/L6cIbVLxBcb
# Cm9yn181p1oKRdv/hMf12OAfOu0Mv7qbvFUdJO0sySNCWkBnjjUUqDWQtm6ZDA24
# 68PpIcp+tqNfLzSxjpBsMYIB1jCCAdICAQEwNTAhMR8wHQYDVQQDDBZhYXJvbi5s
# ZWJsYW5jQFRDLkdDLkNBAhB3h9T7j/2RoUDr0YatkIGmMAkGBSsOAwIaBQCgeDAY
# BgorBgEEAYI3AgEMMQowCKACgAChAoAAMBkGCSqGSIb3DQEJAzEMBgorBgEEAYI3
# AgEEMBwGCisGAQQBgjcCAQsxDjAMBgorBgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEW
# BBSQePJah2rqVYpLwTefSKFKrveQRjANBgkqhkiG9w0BAQEFAASCAQBkdxrSQrXt
# OClm9Pruo2Khc3Tv4oTXYrcF14KYJ3RzqHT/JyUTdMcckBJY9Nz7CgrCmUhCWmGn
# 90Q2IpOStSfZpjFzKFJIgDdGaR/MyH0fK7Pmyd51kynqkgWHOMfyPE98XCnTPOll
# P8Ul9oCm/WyPWPDe79dVXK/mf8opebHdb0POiIEwhVpjaGJ6Q3DgGDpU10q2W8Y2
# do3BiEQh1o3IPbEZS/DQueSbhxz3YmJUQ9GrTfztg6fpQwSrll5WHZUvPY22Esw6
# lJErHK3E8LfKN8Jv+/ps5VpienpeV0NQwv8WwsidQOyhrzMAO0+sRddpQeCN6WVo
# g4iv5dToXSXI
# SIG # End signature block
