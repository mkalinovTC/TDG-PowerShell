param(
    [Parameter(mandatory=$true)]
    [string] $LogPath
)

try{
    #Verify if MSOnline Module is available
    if (Get-Module -ListAvailable -Name MSonline) {
        #Import MSOnline Module
        import-module MSOnline -ErrorAction SilentlyContinue

        #Verify if the Microsoft.PowerApps.Administration.PowerShell Module and Microsoft.PowerAPps.PowerShell are installed
        if (Get-Module -ListAvailable -Name Microsoft.PowerApps.Administration.PowerShell) {
            if (Get-Module -ListAvailable -Name Microsoft.PowerApps.PowerShell) {
        
                #Test if logpath exists
                If(Test-Path $LogPath) { 
                    #Start script
                    Try{
                        #Object collections
                        $flowCollection = @()
                        $environmentCollection = @()

                        #Connect to the correct O365 Tenant
                        Connect-MsolService 
                        
                        #Connect to the Flow Environment
                        Add-PowerAppsAccount

                        #Retrieve all users UPN and ID
                        $users = Get-MsolUser -All | Select-Object UserPrincipalName, ObjectId | Sort-Object DisplayName

                        #Retrieve all flow environments
                        $environments = Get-FlowEnvironment | Sort-Object EnvironmentName
                        
                        #Retrieve all flows
                        $flows = get-AdminFlow | Sort-Object EnvironmentName
                      
                        #loop through all environments
                        foreach($environment in $environments){
                            #fill the collection with information
                            $envProperties = $environment.internal.properties
                            [datetime]$createdTime = $envProperties.createdTime
                            $environmentCollection += new-object psobject -property @{displayName = $envProperties.displayName;InternalName = $environment.EnvironmentName;SKU = $envProperties.environmentSku;EnvType = $envProperties.environmentType;Region = $envProperties.azureRegionHint;Created = $createdTime;CreatedBy = $envProperties.createdby.displayname}
                        }

                        #loop through all flows
                        foreach($flow in $flows){
                            #fill the collection with information
                            $flowProperties = $flow.internal.properties
                            $creatorName = $users | where-object{$_.ObjectId -eq $flowProperties.creator.UserID}
                            
                            $triggers = $flowProperties.definitionsummary.triggers
                            $actions = $flowProperties.definitionsummary.actions | where-object {$_.swaggerOperationId}
                            
                            $triggerString = ""
                            foreach($trigger in $triggers){
                                if($triggerString -ne ""){
                                    $triggerString = $triggerString + "<br />"
                                }
                                $triggerString = $triggerString + "$($trigger.swaggerOperationId)"
                            }
                            
                            $actionsString = ""
                            foreach($action in $actions){
                                if($actionsString -ne ""){
                                    $actionsString = $actionsString + "<br />"
                                }
                                $actionsString = $actionsString + "$($action.swaggerOperationId)"
                            }
                            
                            
                            [nullable[datetime]]$modifiedTime = $flow.LastModifiedTime
                            [nullable[datetime]]$createdTime = $flowProperties.createdTime
                            
                            $flowCollection += new-object psobject -property @{displayName = $flowProperties.displayName;environment = $flowProperties.Environment.name;State = $flowProperties.State;Triggers = $triggerString;Actions = $actionsString;Created = $createdTime;Modified = $modifiedTime;CreatedBy = $creatorName.userPrincipalName}
                        }    

                        #We now have our collections so we are building the HTML page to get a direct view
                        #List of all Flow environments
                        $article = "<h2>List of all Flow environments</h2>"
                        $article += "<table>
                                    <tr>
                                        <th>displayName</th>
                                        <th>InternalName</th>
                                        <th>SKU</th>
                                        <th>Type</th>
                                        <th>Region</th>
                                        <th>Created</th>
                                        <th>CreatedBy</th>
                                    </tr>"
                        
                        foreach($environmentColl in $environmentCollection){
                        $article += "<tr>
                                        <td>$($environmentColl.displayName)</td>
                                        <td>$($environmentColl.InternalName)</td>
                                        <td>$($environmentColl.SKU)</td>
                                        <td>$($environmentColl.EnvType)</td>
                                        <td>$($environmentColl.Region)</td>
                                        <td>$($environmentColl.Created)</td>
                                        <td>$($environmentColl.CreatedBy)</td>
                                    </tr>"
                        }
                        
                        $article += "</table>"

                        #List of all Flows
                        $article += "<h2>List of all Flows</h2>"
                        $article += "<table>
                                    <tr>
                                        <th>displayName</th>
                                        <th>environment</th>
                                        <th>State</th>
                                        <th>Triggers</th>
                                        <th>Actions</th>
                                        <th>Created</th>
                                        <th>Modified</th>
                                        <th>CreatedBy</th>
                                    </tr>"
                        
                        foreach($flowColl in $flowCollection){
                        $article += "<tr>
                                        <td>$($flowColl.displayName)</td>
                                        <td>$($flowColl.environment)</td>
                                        <td>$($flowColl.State)</td>
                                        <td>$($flowColl.Triggers)</td>
                                        <td>$($flowColl.Actions)</td>
                                        <td>$($flowColl.Created)</td>
                                        <td>$($flowColl.Modified)</td>
                                        <td>$($flowColl.CreatedBy)</td>
                                    </tr>"
                        }
                        
                        $article += "</table>"

                        $date = get-date
                        $today = $date.ToString("ddMMyyyy_HHmm")
                        $LogPath = Join-Path $LogPath "HTMLFlowReport_$($today).html"    
                        
                        #Head
                        $head = "
                        <html xmlns=`"http://www.w3.org/1999/xhtml`">
                            <head>
                                <style>
                                    @charset `"UTF-8`";
 
                                    @media print {
                                        body {-webkit-print-color-adjust: exact;}
                                    }
                         
                                    div.container {
                                        width: 100%;
                                        border: 1px solid gray;
                                    }
                                     
                                    header {
                                        padding: 0.1em;
                                        color: white;
                                        background-color: #000033;
                                        color: white;
                                        clear: left;
                                        text-align: center;
                                        border-bottom: 2px solid #FF0066
                                    }
                                     
                                    footer {
                                        padding: 0.1em;
                                        color: white;
                                        background-color: #000033;
                                        color: white;
                                        clear: left;
                                        text-align: center;
                                        border-top: 2px solid #FF0066
                                    }
 
                                    article {
                                        margin-left: 20px;
                                        min-width:600px;
                                        min-height: 600px;
                                        padding: 1em;
                                    }
                                     
                                    th{
                                        border:1px Solid Black;
                                        border-Collapse:collapse;
                                        background-color:#000033;
                                        color:white;
                                    }
                                     
                                    th{
                                        border:1px Solid Black;
                                        border-Collapse:collapse;
                                    }
                                     
                                    tr:nth-child(even) {
                                      background-color: #dddddd;
                                    }
 
                                </style>
                            </head>
                        "
                        
                        #Header
                        $date = (get-date).tostring("dd-MM-yyyy")
                        $header = "
                            <h1>Flow Report</h1>
                            <h5>$($date)</h5>
                        "
                        
                     #   #Footer
                        $Footer = "
                            Copyright &copy;
                        "
                        
                        #Full HTML
                        $HTML = "
                            $($Head)
                            <body class=`"Inventory`">
                                <div class=`"container`">
                                    <header>
                                        $($Header)
                                    </header>
                                     
                                    <article>
                                        $($article)
                                    </article>
                                             
                                    <footer>
                                        $($footer)
                                    </footer>
                                </div>
                            </body>
                            </html>
                        " 
                        add-content $HTML -path $LogPath

                        Write-Host "Flow overview created at $($LogPath), it will also open automatically in 5 seconds" -foregroundcolor green

                        start-sleep -s 5
                        Invoke-Item $LogPath
                    }
                    catch{
                        write-host "Error occurred: $($_.Exception.Message), please post this error on https://www.cloudsecuritea.com" -foregroundcolor red
                    }
                } Else { 
                    Write-Host "The path $($LogPath) could not be found. Please enter a correct path to store the Office 365 subscription and license overview" -foregroundcolor yellow
                }
            }
            Else{Write-Host "The new Microsoft.PowerApps.PowerShell Module is not installed. Please install using the link in the blog" -foregroundcolor yellow}
        }
        Else{Write-Host "The new Microsoft.PowerApps.Administration.PowerShell Module is not installed. Please install using the link in the blog" -foregroundcolor yellow}
    } else {
        Write-Host "MSOnline module not loaded. Please install the MSOnline module with Install-Module MSOnline" -foregroundcolor yellow
    }
}
catch{
    write-host "Error occurred: $($_.Exception.Message)" -foregroundcolor red
}
# SIG # Begin signature block
# MIIFpQYJKoZIhvcNAQcCoIIFljCCBZICAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUaRMtbAIb9rUxjoaUmL9BdZGE
# Ov2gggM5MIIDNTCCAh2gAwIBAgIQd4fU+4/9kaFA69GGrZCBpjANBgkqhkiG9w0B
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
# BBS6wmkSh6au9K61Um8R9TgOociyNzANBgkqhkiG9w0BAQEFAASCAQBaxI5Oqtnp
# jUTX7rCVfKdrEfCiidkEQUaPIzecDs7J49dtSreVPGgWN4Tq2bykVEFEr1ld0Ee3
# EzO28ENNk6M4m13NofuD4p2AELhwkQzUqa1z1tewGg0B/hBKqWqztxF/rghY2c4Y
# CzNSPTkdl6zbYDQ8S/JEd+IHGIWxu/q/ZJachWl2KAtQ9FVZrrPR4snH0ANBxOX7
# XrHxDPNg/BpvAq80omMvKivFrhNR02UFvQe66wH+verBEkcczlnh5okRG4zOJOe5
# I3yw6jF4jcLUjB2vH52gS7uB7Aa89s6ZZvybDQ17SzMDhcet1yGDlueEhcdqbBWq
# ejCGYLPlQQmL
# SIG # End signature block
