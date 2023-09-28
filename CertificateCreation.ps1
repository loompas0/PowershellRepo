# Manipulate self signed certificate in PowerShell

# Use some Variables to make the code clear
$store = "cert:\CurrentUser\My" #location on the certificate in my windows local machine
$params = @{
    CertStoreLocation = $store
    Subject = "CN=Loompas0"
    FriendlyName = "Loompas0" #Add a friendly name for better comprehension
    KeyLength = 2048
    KeyAlgorithm = "RSA" 
    KeyUsage = "DataEncipherment"
    Type = "DocumentEncryptionCert"
    NotAfter = (Get-Date).AddMonths(60)
   }
   
   

# First create a Certificate and store it to default store
$LoompasCert=New-SelfSignedCertificate @params

# Create a path  to my newly created certificate
$LoompasPath = $store+'\'+$LoompasCert.Thumbprint
# list all certs 
Write-Host "All local certificates"
Get-ChildItem -path $store
#List My cert
Write-Host "My newly created certificate"
Get-ChildItem -path $LoompasPath
# ls cert:\CurrentUser\My #Another way to list all certificates

# Exporting/Importing certificate

$Passwd = ConvertTo-SecureString -String "Strasbourg0" -Force -AsPlainText 
# $ZertoPassword = Read-Host "Enter Zerto password" -AsSecureString
# Write-Output $ZertoPassword
# $plainPwd =[Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($ZertoPassword))
# Write-Output $plainPwd
$PrivateKey = "./Loompas0.pfx"
$PublicKey = "./Loompas0.cer"

# Export private key as PFX certificate, to use those Keys on different machine/user
Export-PfxCertificate -FilePath $PrivateKey -Cert $LoompasCert -Password $Passwd

# Export Public key as CER certificate, to share with other users
Export-Certificate -FilePath $PublicKey -Cert $LoompasCert

# Lets try to use that 
#  First Encryption 
$message = "My secret message"
$cipher = $message  | Protect-CmsMessage -To "Loompas0"
Write-Host "Cipher:" -ForegroundColor Green 
Write-Host $cipher  -ForegroundColor Red
#  Second Decryption 
$clearText = $cipher | Unprotect-CmsMessage

Write-Host "Decrypted message:" -ForegroundColor Green
Write-Host $clearText -ForegroundColor Yellow


# remove my certificate created before
remove-Item -path $LoompasPath

<#

#Remove certificate from store
$cert | Remove-Item

# Add them back:
# Add private key on your machine
Import-PfxCertificate -FilePath $PrivateKey -CertStoreLocation $store -Password $Passwd

# This is for other users (so they can send you encrypted messages)
Import-Certificate -FilePath $PublicKey -CertStoreLocation $store

#>