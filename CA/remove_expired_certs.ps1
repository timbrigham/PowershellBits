# remove any expired certificates on a given machine's local machine store. 

write-host "This script expects to run under an account with administrative rights to the remote computer in question"
$Computer = Read-Host "Enter the computer name to connect to"

Invoke-Command -ComputerName $computer -ScriptBlock { gci -recurse cert:\localmachine\my | Where-Object {$_ -is [System.Security.Cryptography.X509Certificates.X509Certificate2] -and $_.NotAfter -lt (Get-Date)} |remove-item } 
