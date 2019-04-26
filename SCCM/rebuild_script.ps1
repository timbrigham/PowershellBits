# Written to ease the pain of removing and rebuild a system repeatedly.
$theDomain="test.com"
$theMachine="workstation1"
$sccmServer="servername"
$virusConsole="https://avserver.domain.com"


# Remove from AD 
#Remove-ADComputer wsvm-010 #-whatif 
Get-ADComputer -Identity "wsvm-010" | Remove-ADObject -Recursive

# Remove from DNS server
Remove-DnsServerResourceRecord -computername statler -zonename "$theDomain" -name "$workstation1" -RRType "A" #-whatif

# remove from DNS cache
ipconfig /flushdns 

# Remove from SCCM 
$comp = gwmi -cn $servername -namespace root\sms\site_uks -class sms_r_system -filter "Name='$theMachine'"
$comp.delete() 

# launch the virus management console for removal 
start $virusConsole

