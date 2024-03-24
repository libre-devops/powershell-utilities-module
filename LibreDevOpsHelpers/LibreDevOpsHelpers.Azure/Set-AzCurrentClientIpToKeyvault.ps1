function Set-AzCurrentClientIpToKeyvault
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$KeyvaultResourceId,

        [Parameter(Mandatory)]
        [bool]$AddClientIP,

        [Parameter(Mandatory = $false)]
        [string]$ClientIpAddressCheckerUrl = "https://checkip.amazonaws.com"
    )

    Begin {
        try
        {
            $context = Get-AzContext
            if (-not $context)
            {
                throw "[$( $MyInvocation.MyCommand.Name )] Error: User is not logged into Azure. Please login using Connect-AzAccount."
            }
            Write-Verbose "[$( $MyInvocation.MyCommand.Name )] Info: AzContext is set...continuing"

            $resourceIdParts = $KeyvaultResourceId -split '/'
            $subscriptionId = $resourceIdParts[2]
            $resourceGroupName = $resourceIdParts[4]
            $keyVaultName = $resourceIdParts[-1]

            Write-Verbose "[$( $MyInvocation.MyCommand.Name )] Info: Fetching Key Vault: $keyVaultName in resource group: $resourceGroupName"
            $keyVault = Get-AzKeyVault -VaultName $keyVaultName -ResourceGroupName $resourceGroupName -SubscriptionId $subscriptionId
        }
        catch
        {
            Write-Error "[$( $MyInvocation.MyCommand.Name )] Error: An error occurred during Azure session verification or Key Vault retrieval: $_"
            return
        }
    }

    Process {
        try
        {
            $currentNetworkAcls = $keyVault.NetworkAcls
            $currentIp = (Invoke-RestMethod -Uri $ClientIpAddressCheckerUrl).Trim()
            Write-Verbose "[$( $MyInvocation.MyCommand.Name )] Info: Current client IP is $currentIp"

            # No change needed here, just fetch the current IP rules
            $currentIps = $currentNetworkAcls.IpAddressRanges
            Write-Verbose "[$( $MyInvocation.MyCommand.Name )] Info: Rules that already exist on the key vault are $currentIps"

            # Check if the current IP already exists in the list without adding /32 to existing entries
            $ipAlreadyExists = $currentIps -contains $currentIp -or $currentIps -contains "${currentIp}/32"
            $newIpRules = @($currentIps)

            if ($AddClientIP -and -not $ipAlreadyExists)
            {
                Write-Verbose "[$( $MyInvocation.MyCommand.Name )] Info: Adding current client IP to Key Vault network rules."
                # Append /32 only if the IP does not already have a subnet mask
                $newIpRules += if ($currentIp -notmatch '.+/\d+$')
                {
                    "${currentIp}/32"
                }
                else
                {
                    $currentIp
                }
            }
            elseif (-not $AddClientIP -and $ipAlreadyExists)
            {
                Write-Verbose "[$( $MyInvocation.MyCommand.Name )] Info: Removing current client IP from Key Vault network rules."
                # Remove both the plain IP and the IP with /32, to cover both scenarios
                $newIpRules = $newIpRules | Where-Object { $_ -ne $currentIp -and $_ -ne "${currentIp}/32" }
            }
            else
            {
                Write-Verbose "[$( $MyInvocation.MyCommand.Name )] Info: No changes needed for the IP rules."
                return
            }

            # This check now ensures that we don't add /32 to IPs that already have a subnet
            $newIpRules = $newIpRules | Where-Object { $_ -and $_.Trim() -ne '' }

            Write-Verbose "[$( $MyInvocation.MyCommand.Name )] Info: New ip rules are $newIpRules"

            # Validate the final list of IP rules
            $validIpRules = $newIpRules | Where-Object { $_ -match '^\d+\.\d+\.\d+\.\d+(/\d+)?$' }
            Write-Verbose "[$( $MyInvocation.MyCommand.Name )] Info: Valid IP rules are $validIpRules"

            if (-not $validIpRules)
            {
                Write-Error "No valid IP rules to update. Please check the IP format."
                return
            }

            Update-AzKeyVaultNetworkRuleSet -VaultName $keyVaultName -ResourceGroupName $resourceGroupName `
            -IpAddressRange $validIpRules -Bypass $currentNetworkAcls.Bypass -DefaultAction $currentNetworkAcls.DefaultAction

            Write-Verbose "[$( $MyInvocation.MyCommand.Name )] Info: Key Vault network rules updated successfully."
        }
        catch
        {
            Write-Error "[$( $MyInvocation.MyCommand.Name )] Error: An error occurred: $_"
        }
    }
}
