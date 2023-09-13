#encrypt string and write it to json file

# $ClearString = Read-Host “Please give a string to encrypt”

$SecureString = Read-Host "please give a string to encrypt" -AsSecureString
$clearText = ConvertFrom-SecureString -SecureString $SecureString -AsPlainText
write-host "The secure string is $Cleartext"
Write-Host $SecureString
$EncryptedData = ConvertFrom-SecureString -SecureString $SecureString
Write-Host "the data is encrypted $EncryptedData"

$JSonString = @"
{
    "Secret": "$EncryptedData",
    "Age": 29
}
"@
$JsonObject = ConvertFrom-Json $JSonString
Write-Host "Json's Object"
Write-Host $JsonObject
$JSonString | Out-File ./DataEncrypted.json

# now lets read from json and decrypt the string 
$EncryptedFile = Get-Content -path .\DataEncrypted.json -Raw | ConvertFrom-Json -ErrorAction Stop
$NbLines = $EncryptedFile.count
Write-Host "I HAve $NbLines lines in the file"
$FirstSecret = $EncryptedFile.Secret
Write-Host "The secret is $FirstSecret" -ForegroundColor Green
If ($FirstSecret -ne $EncryptedData)
{
    Write-Host "File is different than before" -ForegroundColor Red
}

$SecureSecret = ConvertTo-SecureString -String $FirstSecret
Write-Host "The Secure secret: $SecureSecret" -ForegroundColor Blue

$ClearSecret = ConvertFrom-SecureString -SecureString $SecureSecret -AsPlainText
Write-host "The secret entered (in clear text)  $ClearSecret" -ForegroundColor Yellow

