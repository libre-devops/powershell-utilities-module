function Connect-AzCliAccountWithServicePrincipal
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ApplicationId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$TenantId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Secret,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$SubscriptionId
    )

    try
    {
        # Build the command to execute
        $loginCommand = "az login --service-principal -u `"$ApplicationId`" -p `"$Secret`" --tenant `"$TenantId`""

        # Execute the command
        Invoke-Expression $loginCommand
        Write-Verbose "Successfully logged in to Azure with the provided service principal."

        if (-not [string]::IsNullOrEmpty($SubscriptionId))
        {
            $setSubscriptionCommand = "az account set --subscription `"$SubscriptionId`""
            Invoke-Expression $setSubscriptionCommand
            Write-Verbose "Subscription context set to $SubscriptionId."
        }

        Write-Information "[$( $MyInvocation.MyCommand.Name )] Success: Successfully logged in to Azure CLI with service principal."
    }
    catch
    {
        Write-Error "[$( $MyInvocation.MyCommand.Name )] Error: Failed to log in to Azure CLI with the provided service principal details: $_"
        throw
    }
}
