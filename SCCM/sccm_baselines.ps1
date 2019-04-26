$ComputerName = "."

$Baselines = Get-WmiObject -ComputerName $ComputerName -Namespace root\ccm\dcm -Class SMS_DesiredConfiguration -Filter 'Name like "%Baseline%"'
$Baselines | ForEach-Object 	{  echo $_.name; echo $_.version;   }
$Baselines | ForEach-Object {  
	([wmiclass]"\\.\root\ccm\dcm:SMS_DesiredConfiguration").TriggerEvaluation( 	$_.Name, $_.Version ) 
}	


