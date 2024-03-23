function Connect-AzAccountWithServicePrincipal
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

        [string]$SubscriptionId
    )

    try
    {
        $SecureSecret = $Secret | ConvertTo-SecureString -AsPlainText -Force
        $Credential = New-Object System.Management.Automation.PSCredential ($ApplicationId, $SecureSecret)

        Write-Verbose "Attempting to connect to Azure with the provided service principal."
        Connect-AzAccount -ServicePrincipal -Credential $Credential -Tenant $TenantId -ErrorAction Stop | Out-Null
        Write-Information "[$( $MyInvocation.MyCommand.Name )] Info: Connected to account successfully."

        if (-not [string]::IsNullOrEmpty($SubscriptionId))
        {
            Write-Verbose "SubscriptionId provided. Attempting to set context to $SubscriptionId."
            Set-AzContext -SubscriptionId $SubscriptionId | Out-Null
            Write-Information "[$( $MyInvocation.MyCommand.Name )] Info: Context set to $SubscriptionId successfully."
        }

        Write-Information "[$( $MyInvocation.MyCommand.Name )] Success: Successfully logged in to Azure."
    }
    catch
    {
        Write-Error "[$( $MyInvocation.MyCommand.Name )] Error: Failed to log in to Azure with the provided service principal details: $_"
        throw
    }
}
