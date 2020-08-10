# Assumes you have already run Connect-AzureRmAccount

$StorageContext = New-AzureStorageContext -StorageAccountName 'XXXX' -StorageAccountKey 'YYYYYYYY'
$destination_path = 'C:\Temp'  


$containers  = Get-AzureStorageContainer -Context $StorageContext
New-Item -ItemType Directory -Force -Path $destination_path  

ForEach ( $container in $containers ) {
 $blobs = Get-AzureStorageBlob -Container $container.Name -Context $StorageContext 
 
 ForEach ( $blob in $blobs ){
	$blobName = [string] $blob.Name
	$containerName = $container.Name 

	New-Item -ItemType Directory -Force -Path $destination_path\$containerName  
	Get-AzureStorageBlobContent -Force -Container $containerName `
		-Blob $blobName `
		-Destination $destination_path\$containerName `
		-Context $StorageContext  
 }
 
}




