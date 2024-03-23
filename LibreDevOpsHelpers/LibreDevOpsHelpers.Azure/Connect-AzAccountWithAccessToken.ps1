function Connect-AzAccountWithAccessToken
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$AccessToken,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$SubscriptionId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$ApiVersion = "2020-01-01" # Default API version
    )

    try
    {
        # Set the Authorization header with the access token
        $authHeader = @{
            'Authorization' = "Bearer $AccessToken"
        }

        # Construct the subscription URL with the API version
        $subscriptionUrl = "https://management.azure.com/subscriptions/${SubscriptionId}?api-version=$ApiVersion"

        # Logging URL for debugging purposes
        Write-Verbose "Calling URL: $subscriptionUrl"

        $response = Invoke-RestMethod -Uri $subscriptionUrl -Method Get -Headers $authHeader

        Write-Verbose "Successfully called Azure REST API with the provided access token."
        Write-Information "[$( $MyInvocation.MyCommand.Name )] Info: Retrieved subscription details: $( $response.id )"
    }
    catch
    {
        Write-Error "[$( $MyInvocation.MyCommand.Name )] Error: Failed to call Azure REST API with the access token: $_"
        throw
    }
}
