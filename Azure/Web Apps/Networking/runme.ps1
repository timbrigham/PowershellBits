# This code derived from https://gist.github.com/Swimburger/b2d58bff38156b73a5417b7f818fc5be

# It expands on and requires the following fields:

# -ResourceGroupName name of the resource group from Azure interface
# -AppServiceName name of the app service, or slot. For slots, use the format "app service/slot name" here
# -SubscriptionId the subscription ID that your resource is hosted under. 
# -ResourceType the type of the object that needs to be edited. 
# -RulePriority the priority that will be set for *all* rules added for a given set.
# This will be Microsoft.Web/sites/config for the main instance, and Microsoft.Web/sites/slots/config for any slots. 
# I also included a small script .\ClearRestrictedIPAzureAppService.ps1 that will wipe out any existing rules. 

# These are for production instances 
.\ClearRestrictedIPAzureAppService.ps1  `
	-ResourceGroupName "AppServicesResource" `
	-AppServiceName "AppService" `
	-ResourceType "Microsoft.Web/sites/config" `
	-SubscriptionId  "xxxxxx"
	
.\AddCloudflareRestrictedIPApp.ps1 `
	-ResourceGroupName "AppServicesResource" `
	-AppServiceName "AppService" `
	-ResourceType "Microsoft.Web/sites/config" `
	-SubscriptionId  "xxxxxx" `
	-RulePriority 100 
	
.\AddAvailabilityRestrictedIPApp.ps1 `
	-ResourceGroupName "AppServicesResource" `
	-AppServiceName "AppService" `
	-ResourceType "Microsoft.Web/sites/config" `
	-SubscriptionId  "xxxxxx" `
	-RulePriority 200 

# These are for the QA instance
.\ClearRestrictedIPAzureAppService.ps1  `
	-ResourceGroupName "AppServicesResource" `
	-AppServiceName "AppService/qa" `
	-ResourceType "Microsoft.Web/sites/slots/config" `
	-SubscriptionId  "xxxxxx"
	
.\AddCloudflareRestrictedIPApp.ps1 `
	-ResourceGroupName "AppServicesResource" `
	-AppServiceName "AppService/qa" `
	-ResourceType "Microsoft.Web/sites/slots/config" `
	-SubscriptionId  "xxxxxx" `
	-RulePriority 100 
	
.\AddAvailabilityRestrictedIPApp.ps1 `
	-ResourceGroupName "AppServicesResource" `
	-AppServiceName "AppService/qa" `
	-ResourceType "Microsoft.Web/sites/slots/config" `
	-SubscriptionId  "xxxxxx" `
	-RulePriority 200 
	
