# Manipulate self signed certificate in PowerShell

# Use some Variables to make the code clear
$store = "cert:\CurrentUser\My"
$params = @{
    CertStoreLocation = $store
    Subject = "CN=Loompas0"
    KeyLength = 2048
    KeyAlgorithm = "RSA" 
    KeyUsage = "DataEncipherment"
    Type = "DocumentEncryptionCert"
    NotAfter = (Get-Date).AddMonths(60)
   }
   
   

# First create a Certificate and store it to default store
$LoompasCert=New-SelfSignedCertificate @params

# list all certs 
Get-ChildItem -path $store

# Exporting/Importing certificate

$Passwd = ConvertTo-SecureString -String "Strasbourg0" -Force -AsPlainText 
$PrivateKey = "./Loompas0.pfx"
$PublicKey = "./Loompas0.cer"

# Export private key as PFX certificate, to use those Keys on different machine/user
Export-PfxCertificate -FilePath $PrivateKey -Cert $LoompasCert -Password $Passwd

# Export Public key, to share with other users
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


# remove all certificate created before
Remove-Item -Path $store/* 

<#

#Remove certificate from store
$cert | Remove-Item

# Add them back:
# Add private key on your machine
Import-PfxCertificate -FilePath $PrivateKey -CertStoreLocation $store -Password $Passwd

# This is for other users (so they can send you encrypted messages)
Import-Certificate -FilePath $PublicKey -CertStoreLocation $store

#>