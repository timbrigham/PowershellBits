Param( 
    [Parameter(Mandatory = $true)] 
    [string] $ResourceGroupName, 
    [Parameter(Mandatory = $true)] 
    [string] $AppServiceName, 
    [Parameter(Mandatory = $true)] 
    [string] $ResourceType, 
    [Parameter(Mandatory = $true)] 
    [string] $SubscriptionId 
)

$ErrorActionPreference = "Stop"

Import-Module Az

if($Null -eq (Get-AzContext)){
    Login-AzAccount
}

$NewIpRestrictions = @();
$NewIpRestrictions += @{
        ipAddress = "Any"; 
        action = "Allow";
        priority = 1;
        name = "Reset to Default";
        description = "Reset to Default";
        tag = "Default";
    }

Select-AzSubscription -SubscriptionId $SubscriptionId

$APIVersion = ((Get-AzResourceProvider -ProviderNamespace Microsoft.Web).ResourceTypes | Where-Object ResourceTypeName -eq sites).ApiVersions[0]

$WebAppConfig = Get-AzResource -ResourceName $AppServiceName  -ResourceType $ResourceType -ResourceGroupName $ResourceGroupName -ApiVersion $APIVersion
$WebAppConfig.Properties.ipSecurityRestrictions = $NewIpRestrictions

Set-AzResource -ResourceId $WebAppConfig.ResourceId -Properties $WebAppConfig.Properties -ApiVersion $APIVersion
