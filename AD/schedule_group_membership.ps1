# This script displays dialogs to add users / computers to groups that have an expiration date set. 
# This requires that Active Directory has PAM functionality enabled. 

$usersToAdd    =  Get-ADUser -Filter *  |select-object -property samaccountname,name |`
	sort name | Out-GridView -Title 'Users to Add To Group' -OutputMode Multiple
	
$computersToAdd    =  Get-ADComputer -Filter *  |select-object -property samaccountname,name |`
	sort name | Out-GridView -Title 'Computers to Add To Group' -OutputMode Multiple
	
$groupsToAddTo  =  Get-AdGroup -Filter * |select-object -property samaccountname,name | `
	sort name | Out-GridView -Title 'Group To Add To' -OutputMode Multiple

[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') | Out-Null
$NumberOfDays = [Microsoft.VisualBasic.Interaction]::InputBox('The number of days until the group membership is removed.', `
'Number Of Days Until Removal', "30")

#write-host "User List:"
$userArray = @()
$usersToAdd | foreach-object { $userArray += get-aduser $_.samaccountname }
#$userArray
#write-host "=================================="
#write-host "=================================="
#write-host "=================================="

#write-host "Computer List:"
$computerArray = @()
$computersToAdd | foreach-object { $computerArray += get-adcomputer $_.samaccountname }
#$computerArray
#write-host "=================================="
#write-host "=================================="
#Write-host "=================================="


$bothArrays = $computerArray + $userArray
#$bothArrays


write-host "Group List:"
$groupArray = @()
$groupsToAddTo | foreach-object { $groupArray += get-adgroup $_.samaccountname }
#$groupArray
#write-host "=================================="
#write-host "=================================="
#write-host "=================================="


$TimeLimit = New-TimeSpan -Days $NumberOfDays
#$TimeLimit

$groupArray | foreach-object {
	Add-ADGroupMember $_ -Members $bothArrays -MemberTimeToLive $TimeLimit
}


