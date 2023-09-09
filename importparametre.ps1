## use psd1 file 

Write-Host "content of .psd1 file"
Write-Host ****New-line****
$DCFile = Import-PowerShellDataFile -Path ".\example.psd1" -ErrorAction Stop
Write-Host $DCFile.DetailsServer.IpServer

## use json file

Write-Host 
Write-Host "content of json file"
Write-Host "second file"
# Read file 
$DCFile = Get-Content .\datacenters.json -Raw | ConvertFrom-Json 
Write-Host $DCFile.DataCenters.DC1.ServerIp

## change content of the file
# $DCFile.DataCenters.DC1.ServerIp = $DCFile.DataCenters.DC1.ServerIp + " + 1" 
# Write-Host $DCFile.DataCenters.DC1.ServerIp
# $DCFile | ConvertTo-Json -Depth 3 |Out-File .\newDC.json

