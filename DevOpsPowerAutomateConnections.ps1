$Username = 'tdg.core@034gc.onmicrosoft.com'
$Passwrod = 'Oversight3!'
$EnvironmentName = '28c3ebb2-eb6a-4051-9882-80e82eb4e6a9'


#EnvironmentName  : d49d74cd-4fad-4a97-9bf4-85a284aa520f
#DisplayName      : rom-acc-tdg-data-tcd365
#
#EnvironmentName  : 835365c6-e90a-426b-879d-d9b4e2db879d
#DisplayName      : rom-acc-tdg-tcd365
#
#EnvironmentName  : d53e333c-ff57-4199-ab2c-922cd31a4225
#DisplayName      : rom-dev-tcd365
#
#EnvironmentName  : 28c3ebb2-eb6a-4051-9882-80e82eb4e6a9
#DisplayName      : rom-qa-tcd365




try {
    $modulePowerAppAdministrator = 'Microsoft.PowerApps.Administration.PowerShell'
    $modulePowerAppAdministrator = 'Microsoft.PowerApps.PowerShell'

    if (!(Get-Module -ListAvailable -Name $modulePowerAppAdministrator)) {
        Write-Host "Installing PowerAppsModule."
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Install-PackageProvider -Name NuGet -RequiredVersion 2.8.5.201 -Force
        Install-Module -Name Microsoft.PowerApps.Administration.PowerShell -Force -Verbose -Scope CurrentUser
        Install-Module -Name Microsoft.PowerApps.PowerShell -AllowClobber -Force -Verbose -Scope CurrentUser
        Write-Host "Installed Successfully PowerAppsModule."
    }
    else {
        Write-Host "Module already installed"
    }

}
catch {
    Write-host $_.Exception.Message
}

try {
    Write-Host "Connecting Target Instance of PowerApps."
    $pass = ConvertTo-SecureString $Passwrod -AsPlainText -Force
    Add-PowerAppsAccount -Username $Username -Password $pass
    Write-Host "Successfully Target Instance connected."
}
catch {
    Write-host $_.Exception.Message
}

try {
    Write-Host "Connecting Environment."

    $en = "*$EnvironmentName*"
    $environmentName = Get-PowerAppEnvironment $en | Select-Object -ExpandProperty EnvironmentName
    Write-Host "Connected Environment." $environmentName

    Get-FlowEnvironment $environmentName
}
catch {
    Write-host $_.Exception.Message
}

#$listOfMsFlow = ";
$listOfMsFlow = Get-AdminFlow -EnvironmentName $environmentName #| where-object { !($_.Enabled -eq "True") } #| Select-Object FlowName
$count = 1;

foreach ($flow in $listOfMsFlow) {

    try {

        Write-Host "Flow Name " $flow.FlowName $count $flow.DisplayName

        $CancellationRequest = "838c2d9c-34b3-4cb4-aadb-831e964b9599"
        $FollowupRequest = "3ccd74dc-7a0b-4c08-9b1b-c2efe4a4fe36"
        $Infraction = "ce28d121-cf6d-2aaf-82e6-fbaea328d232"

        #if (#$flow.FlowName -eq $CancellationRequest -or $flow.FlowName -eq $FollowupRequest -or 
            $flow.DisplayName.StartsWith("TDG Inspections")#) {
            #TDG Inspections - 
            Write-Host "Attempting to turn on flow: " $flow.FlowName; 
            Enable-AdminFlow -EnvironmentName $environmentName -FlowName $flow.FlowName
            $count = $count + 1;
            Write-Host "Turned on " $flow.FlowName
        #}


        #Disable-AdminFlow -EnvironmentName $environmentName -FlowName $flow.FlowName
        # Write-Host "Turn Off." $flow
    }
    catch {
        Write-Host "Failed to Turn On. " $flow.FlowName
        Write-host $_.Exception.Message
    }

}
# SIG # Begin signature block
# MIIFpQYJKoZIhvcNAQcCoIIFljCCBZICAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUIL9RogTGsxW8oQnDa4wNV9I0
# chOgggM5MIIDNTCCAh2gAwIBAgIQd4fU+4/9kaFA69GGrZCBpjANBgkqhkiG9w0B
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
# BBS5NbHOE/OCjYC73k1vZxA7wLf9BDANBgkqhkiG9w0BAQEFAASCAQBPFBUTPP2/
# uJ5AaKip/Mjt1Jc6QRd/zcxDGWrGCBG+scnUGxfVDevCitncrYXZWP4XOWQuM7iM
# GXhWZaa9GRa4o7prXfAc+8Pj58yO5NEir7qD4i1RWWMJzp6Y5Yi7Vo6iMFR0sn1y
# eBlvJxbR3294IW5vUggkN/WRxIf4IGfxj6DXXdZAb4+7GO/9sfZeNUENVZ8qAMz1
# ueHnxwtemVTAw+aTv3aEfGfv57RW5uYWGBfgmkG4ORkxiX5y7jgmmArgV/oGZvRF
# L25FgQ3qOLQtJlaz5NS5LftxoNFV4SRhP5WBXUFKT9gFZvZ27hnazDKw2lOcKc8v
# 3pEXXh5Gg+0E
# SIG # End signature block
