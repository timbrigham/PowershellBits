# Read computer name, output description 
 while ($true)
 {
 $computer = Read-Host -Prompt 'Computer Name'
 get-adcomputer $computer -Properties * | format-table CN, Description
 }
