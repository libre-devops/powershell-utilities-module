function Connect-AzAccountWithServicePrincipal
{
    param (
        [string]$ApplicationId,
        [string]$TenantId,
        [string]$Secret,
        [string]$SubscriptionId
    )

    try
    {
        $SecureSecret = $Secret | ConvertTo-SecureString -AsPlainText -Force
        $Credential = New-Object System.Management.Automation.PSCredential ($ApplicationId, $SecureSecret)
        Connect-AzAccount -ServicePrincipal -Credential $Credential -Tenant $TenantId -ErrorAction Stop | Out-Null

        if (-not [string]::IsNullOrEmpty($SubscriptionId))
        {
            Set-AzContext -SubscriptionId $SubscriptionId | Out-Null
        }

        Write-Host "[$( $MyInvocation.MyCommand.Name )] Success: Successfully logged in to Azure." -ForegroundColor Cyan
    }
    catch
    {
        Write-Error "[$( $MyInvocation.MyCommand.Name )] Error: Failed to log in to Azure with the provided service principal details: $_"
        throw $_
    }
}

function ResourceId-Parser
{
    param (
        [string]$ResourceId
    )

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
