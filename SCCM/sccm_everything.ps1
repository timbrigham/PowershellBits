# This is a basic script to run all of the common SCCM client tasks / baselines / compliance check

# Force run as admin
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{   
$location = Get-Location
$arguments = "& '" + $myinvocation.mycommand.definition + "' -Location '$location'" + $myinvocation.mycommand.Parameters
Start-Process powershell -WorkingDirectory $location -Verb runAs -ArgumentList $arguments 
sleep 30 
Break
}

Invoke-WMIMethod -Namespace root\ccm -Class SMS_Client -Name ResetPolicy -ArgumentList 1
$Server = "."
Write-Host "Run the 'Actions' in the Configuration Manager Console" -foreground "magenta"
Invoke-WMIMethod -ComputerName $Server -Namespace root\ccm -Class SMS_CLIENT -Name TriggerSchedule "{00000000-0000-0000-0000-000000000121}"
Invoke-WMIMethod -ComputerName $Server -Namespace root\ccm -Class SMS_CLIENT -Name TriggerSchedule "{00000000-0000-0000-0000-000000000003}"
Invoke-WMIMethod -ComputerName $Server -Namespace root\ccm -Class SMS_CLIENT -Name TriggerSchedule "{00000000-0000-0000-0000-000000000010}"
Invoke-WMIMethod -ComputerName $Server -Namespace root\ccm -Class SMS_CLIENT -Name TriggerSchedule "{00000000-0000-0000-0000-000000000001}" 
Invoke-WMIMethod -ComputerName $Server -Namespace root\ccm -Class SMS_CLIENT -Name TriggerSchedule "{00000000-0000-0000-0000-000000000021}"
Invoke-WMIMethod -ComputerName $Server -Namespace root\ccm -Class SMS_CLIENT -Name TriggerSchedule "{00000000-0000-0000-0000-000000000022}"
Invoke-WMIMethod -ComputerName $Server -Namespace root\ccm -Class SMS_CLIENT -Name TriggerSchedule "{00000000-0000-0000-0000-000000000002}"
Invoke-WMIMethod -ComputerName $Server -Namespace root\ccm -Class SMS_CLIENT -Name TriggerSchedule "{00000000-0000-0000-0000-000000000031}"
Invoke-WMIMethod -ComputerName $Server -Namespace root\ccm -Class SMS_CLIENT -Name TriggerSchedule "{00000000-0000-0000-0000-000000000108}" 
Invoke-WMIMethod -ComputerName $Server -Namespace root\ccm -Class SMS_CLIENT -Name TriggerSchedule "{00000000-0000-0000-0000-000000000113}"
Invoke-WMIMethod -ComputerName $Server -Namespace root\ccm -Class SMS_CLIENT -Name TriggerSchedule "{00000000-0000-0000-0000-000000000111}"
Invoke-WMIMethod -ComputerName $Server -Namespace root\ccm -Class SMS_CLIENT -Name TriggerSchedule "{00000000-0000-0000-0000-000000000032}"

Write-Host "Run all baselines attached to this computer. " -foreground "magenta"
$Baselines = Get-WmiObject -ComputerName $Server -Namespace root\ccm\dcm -Class SMS_DesiredConfiguration -Filter 'Name like "%Baseline%"'
$Baselines | ForEach-Object 	{  echo $_.name; echo $_.version;   }
$Baselines | ForEach-Object {  
	([wmiclass]"\\$server\root\ccm\dcm:SMS_DesiredConfiguration").TriggerEvaluation( 	$_.Name, $_.Version ) 
}	


Write-Host "Submit a compliance state message to SCCM,  report back." -foreground "magenta"
$SCCMUpdatesStore = New-Object -ComObject Microsoft.CCM.UpdatesStore
$SCCMUpdatesStore.RefreshServerComplianceState()

sleep 30