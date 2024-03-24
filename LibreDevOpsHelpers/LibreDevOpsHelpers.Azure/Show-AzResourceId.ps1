function Show-AzResourceId
{
    [CmdletBinding()]
    param (
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]$ResourceId
    )

    try
    {
        $resourceIdParts = $ResourceId -split '/'
        $subscriptionId = $resourceIdParts[2]
        $resourceGroupName = $resourceIdParts[4]
        $resourceName = $resourceIdParts[-1]

        return [PSCustomObject]@{
            SubscriptionId = $subscriptionId
            ResourceGroupName = $resourceGroupName
            ResourceName = $resourceName
        }
    }
    catch
    {
        throw "[$( $MyInvocation.MyCommand.Name )] Error: Resource ID is not in expected format or invalid: $_"
    }
}
