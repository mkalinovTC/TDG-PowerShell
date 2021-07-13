Import-Module Microsoft.PowerApps.Administration.PowerShell -Verbose

Install-Module PowerShellGet -Force

Install-Module –Name ExchangeOnlineManagement

Connect-AzureAD -AccountId aaron.leblanc@tc.gc.ca

#$Username = 'aaron.leblanc@tc.gc.ca'
#$Passwrod = ''
$EnvironmentName = '28c3ebb2-eb6a-4051-9882-80e82eb4e6a9'
$Username = 'a6adc57f-f130-4e0e-8cab-c0d6a26f8273'
$Passwrod = '2e5L2VU.an8-Smpcn.nu2wavk__sY5eocF'

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
$listOfMsFlow = Get-AdminFlow -EnvironmentName '28c3ebb2-eb6a-4051-9882-80e82eb4e6a9' #$environmentName #| where-object { !($_.Enabled -eq "True") } #| Select-Object FlowName
$count = 1;

foreach ($flow in $listOfMsFlow) {

    try {

        Write-Host "Flow Name " $flow.FlowName $count $flow.DisplayName

        $CancellationRequest = "4b36fc0c-31cd-6775-3e0f-22fd723ea434"
        $FollowupRequest = "3e3d0e3a-d341-a9df-2b83-6a7bfddeb8a6"
        $RevisedQuarterRequest = "cb1d42f8-5575-847a-32df-6df0c4b45191"

        #if ($flow.FlowName -eq $CancellationRequest -or $flow.FlowName -eq $FollowupRequest -or $flow.FlowName -eq $RevisedQuarterRequest) {
            #TDG Inspections - 
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
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUsXZyi2QuKslkmUvZedE51u3a
# FdSgggM5MIIDNTCCAh2gAwIBAgIQd4fU+4/9kaFA69GGrZCBpjANBgkqhkiG9w0B
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
# BBR+9x6mm7GEk6l9BW9lKAjbaMaAbzANBgkqhkiG9w0BAQEFAASCAQA6G64DyNS4
# NV8usGkBNDZwIyNBexKbzBN+n+v+BjOVLhzVsy0Os4usdYl+s4zq4cme1HzFFOlU
# QwUZ6I9wOvqyTM4Nn1AuQuQPSo7tZ3dVu9OfeReXYvINtLWjL1pgwa2QDXGzrC7B
# KB/G4a1dxL53YGK0YmHNG5cYE6naUGDtRKGi724PZ72QP/58+Tlf/cWdlfrRiALs
# xjYJQgYkF7jtgdhJkvtm29fKpn1lMSMMm9iO2/vL0vM1YLBrQDT9YoJ3N7J4o3OH
# Vaxz9zPhSCF0AZXSLbBtJVyxmzpy4YLOAoNl/q2w68vEJP9n45EVITUldqrfLTDi
# VDFCW0xxdlDI
# SIG # End signature block
