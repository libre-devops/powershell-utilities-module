function Connect-AzAccountWithManagedIdentity
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$SubscriptionId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$TenantId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$ClientId
    )

    try
    {
        Write-Verbose "Attempting to connect to Azure with a managed identity."

        # Check if ClientId is provided
        if (-not [string]::IsNullOrEmpty($ClientId))
        {
            Write-Verbose "ClientId provided. Attempting to connect using the specified managed identity."
            $connectParams = @{
                Identity = $true
                AccountId = $ClientId
                ErrorAction = 'Stop'
            }
        }
        else
        {
            Write-Verbose "No ClientId provided. Attempting to connect using the system assigned managed identity."
            $connectParams = @{
                Identity = $true
                ErrorAction = 'Stop'
            }
        }

        # If TenantId is provided, add it to the connection parameters
        if (-not [string]::IsNullOrEmpty($TenantId))
        {
            $connectParams.TenantId = $TenantId
        }

        # Attempt to connect
        Connect-AzAccount @connectParams | Out-Null
        Write-Information "[$( $MyInvocation.MyCommand.Name )] Info: Connected to Azure with managed identity successfully."

        # Set the subscription context if provided
        if (-not [string]::IsNullOrEmpty($SubscriptionId))
        {
            Write-Verbose "[$( $MyInvocation.MyCommand.Name )] Info: SubscriptionId provided. Attempting to set context to $SubscriptionId."
            Set-AzContext -SubscriptionId $SubscriptionId | Out-Null
            Write-Information "[$( $MyInvocation.MyCommand.Name )] Info: Context set to $SubscriptionId successfully."
        }

        Write-Information "[$( $MyInvocation.MyCommand.Name )] Success: Successfully logged in to Azure using managed identity."
    }
    catch
    {
        Write-Error "[$( $MyInvocation.MyCommand.Name )] Error: Failed to log in to Azure with the managed identity: $_"
        throw
    }
}
