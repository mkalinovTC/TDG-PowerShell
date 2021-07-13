$environmentName = '9745b475-6d3b-466a-ae03-894e7ab94717'

#PREPROD b911dfe7-96c6-4e48-af4e-1ba5130ad297
#ACC: '835365c6-e90a-426b-879d-d9b4e2db879d'

#prod
#9745b475-6d3b-466a-ae03-894e7ab94717


$listOfMsFlow = Get-AdminFlow -EnvironmentName $environmentName #| where-object { !($_.Enabled -eq "True") } #| Select-Object FlowName
$count = 1;

foreach ($flow in $listOfMsFlow) {

    try {

        Write-Host $count ": " $flow.FlowName $flow.DisplayName

        Write-Host "Attempting to turn on flow: " $flow.FlowName; 
        Enable-AdminFlow -EnvironmentName $environmentName -FlowName $flow.FlowName
        $count = $count + 1;
        Write-Host "Turned on " $flow.FlowName
        

        #Disable-AdminFlow -EnvironmentName $environmentName -FlowName $flow.FlowName
        # Write-Host "Turn Off." $flow
    }
    catch {
        Write-Host "Failed to Turn On. " $flow.FlowName
        Write-host $_.Exception.Message
    }

}

#Get-AdminPowerAppEnvironment *rom-acc-tdg-tcd365*

#Enable-AdminFlow -EnvironmentName 835365c6-e90a-426b-879d-d9b4e2db879d -FlowName [Guid]

#Get-AdminFlowOwnerRole -EnvironmentName [Guid] -Owner [Guid]
# SIG # Begin signature block
# MIIFpQYJKoZIhvcNAQcCoIIFljCCBZICAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU9Chu/l1ZK1bD9Bblku2DPgIm
# ok2gggM5MIIDNTCCAh2gAwIBAgIQd4fU+4/9kaFA69GGrZCBpjANBgkqhkiG9w0B
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
# BBTMW3fC782dXh/q1JT5SNx03OmJ+jANBgkqhkiG9w0BAQEFAASCAQB8X/BYmhUI
# KdXj3bVfjHHjFSGAic8gJb5kXPrFb5OfmEWqUVqc0uuWg2Lb6iT4TqhXF0+9Y8Zr
# 2COoSIB/w9RADXle6poWjxwo/UHyslIkBadF8T41doy5bO9BmvUTJ6wbX/RMq/w9
# sbz7tdw6WrRktkUA0zksyyNxafi02XD0p8NzeLTEDNU/K0BFLZzOtc3yqDwaz211
# rA2YS7VA2o3OujeTA/WY+pUQPCHmV3ySIPHTydni60znmuAl8PYFn1Tmu47CbNA9
# hRc384uz24zeR6NKhkDdu8uhPkuodQpCKviUwg9t4KCCiRyTIw2eRSJQFSUMyqZX
# zukbeTpz2Prt
# SIG # End signature block
