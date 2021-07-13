#requires -runasadministrator 

# Paolo Frigo, https://www.scriptinglibray.com

# This scripts generates a self-signed certificate for CodeSigning and exports to a PFX Format

#SETTINGS
$CertificateName = "aaronleblanc"
$OutPutPFXFilePath = "C:\SigningCertificates\aaronleblanc.pfx"
$MyStrongPassword = ConvertTo-SecureString -String "Inspection1!" -Force -AsPlainText 

New-SelfSignedCertificate -subject $CertificateName -Type CodeSigning  | Export-PfxCertificate -FilePath $OutPutPFXFilePath -password $MyStrongPassword 
Write-Output "PFX Certificate `"$CertificateName`" exported: $OutPutPFXFilePath"

$MyCertFromPfx = Get-PfxCertificate -FilePath "C:\SigningCertificates\aaronleblanc.pfx"
Get-ChildItem "C:\Users\leblaaa\source\Powershell Scripts\*.ps1" | Set-AuthenticodeSignature -Certificate $MyCertFromPfx
