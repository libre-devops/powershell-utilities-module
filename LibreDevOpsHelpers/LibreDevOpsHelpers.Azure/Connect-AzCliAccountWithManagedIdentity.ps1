function Connect-AzCliAccountWithManagedIdentity
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$SubscriptionId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$ClientId
    )

    try
    {
        Write-Verbose "Attempting to use Azure Managed Identity."

        # Use the managed identity to set the Azure subscription context if a SubscriptionId is provided
        if (-not [string]::IsNullOrEmpty($SubscriptionId))
        {
            $setSubscriptionCommand = "az account set --subscription `"$SubscriptionId`""
            Invoke-Expression $setSubscriptionCommand
            Write-Verbose "Subscription context set to $SubscriptionId."
        }

        # If ClientId is provided, this indicates the use of a user-assigned managed identity
        if (-not [string]::IsNullOrEmpty($ClientId))
        {
            Write-Verbose "Note: ClientId was provided for a user-assigned managed identity. Ensure this script is run on a resource with access to that identity."
        }

        Write-Information "[$( $MyInvocation.MyCommand.Name )] Info: Using Azure Managed Identity. Ensure this script is executed in a context where a Managed Identity is available."
    }
    catch
    {
        Write-Error "[$( $MyInvocation.MyCommand.Name )] Error: Failed to use Azure Managed Identity: $_"
        throw
    }
}
