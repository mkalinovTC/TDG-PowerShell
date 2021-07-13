#elevate to admin
#===========================================================
if (!
    #current role
    (New-Object Security.Principal.WindowsPrincipal(
        [Security.Principal.WindowsIdentity]::GetCurrent()
    #is admin?
    )).IsInRole(
        [Security.Principal.WindowsBuiltInRole]::Administrator
    )
) {
    #elevate script and exit current non-elevated runtime
    Start-Process `
        -FilePath 'powershell' `
        -ArgumentList (
            #flatten to single array
            '-File', '.\AddUserToSecurityGroup.ps1'`
        ) `
        -Verb RunAs
}
#===========================================================


# SIG # Begin signature block
# MIIFpQYJKoZIhvcNAQcCoIIFljCCBZICAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUZ3dBbLvKVJ31UuHI+83yPJz0
# sVagggM5MIIDNTCCAh2gAwIBAgIQd4fU+4/9kaFA69GGrZCBpjANBgkqhkiG9w0B
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
# BBQf9YbFADJ2f3DrQ/sQD3z39Mc47TANBgkqhkiG9w0BAQEFAASCAQAbp+uG3fCL
# OVf75yTrSdJoum7BZDDMcgUiJIG1sUgzLeKD9T83RFqrrynrQ2ZDacaFamUAaABN
# Sf6AwS1D+bL4B2YPRcXKRc2C9Dalqpgi+vnpcJGms0Hji3NnMNv3rGIX+RW3UdvD
# P0NktxlpisROEr2LUA8LOCGtJoIQYU1BIbeo/KY9d4O3PSpzsQwkAa9dDLbAL15t
# IZNpREuHgyurNTzFwPIrU9V50QccFQtk8hHhOjy0AaFBf/P6cosmTnPgFEjQaaer
# mcaJt7EUfd4nhPSsFOos65rdgiV2dHCbCrC+ra4RYXhAiHZtlTds2qYCDeFyFPdr
# m3dvQeeXNq6o
# SIG # End signature block
