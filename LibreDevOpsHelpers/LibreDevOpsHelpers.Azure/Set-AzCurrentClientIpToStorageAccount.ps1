function Set-AzCurrentClientIpToStorageAccount
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$StorageAccountResourceId,

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
                throw "User is not logged into Azure. Please login using Connect-AzAccount."
            }
            Write-Verbose "[$( $MyInvocation.MyCommand.Name )] Info: AzContext is set...continuing"

            $resourceIdParts = $StorageAccountResourceId -split '/'
            $subscriptionId = $resourceIdParts[2]
            $resourceGroupName = $resourceIdParts[4]
            $storageAccountName = $resourceIdParts[-1]

            Write-Verbose "[$( $MyInvocation.MyCommand.Name )] Info: Fetching Storage Account: $storageAccountName in resource group: $resourceGroupName"
            $storageAccount = Get-AzStorageAccount -Name $storageAccountName -ResourceGroupName $resourceGroupName
        }
        catch
        {
            Write-Error "[$( $MyInvocation.MyCommand.Name )] Error: An error occurred during Azure session verification or Storage Account retrieval: $_"
            return
        }
    }

    Process {
        try
        {
            $currentNetworkAcls = $storageAccount.NetworkRuleSet
            $currentIp = (Invoke-RestMethod -Uri $ClientIpAddressCheckerUrl).Trim()
            Write-Verbose "[$( $MyInvocation.MyCommand.Name )] Info: Current client IP is $currentIp"

            $currentIps = $currentNetworkAcls.IpRules | ForEach-Object { $_.IPAddressOrRange }
            Write-Verbose "[$( $MyInvocation.MyCommand.Name )] Info: Rules that already exist on the storage account are $currentIps"

            $ipAlreadyExists = $currentIps -contains $currentIp
            $newIpRules = $currentNetworkAcls.IpRules

            if ($AddClientIP -and -not $ipAlreadyExists)
            {
                $ipRule = New-Object Microsoft.Azure.Commands.Management.Storage.Models.PSIpRule
                $ipRule.IPAddressOrRange = $currentIp
                $newIpRules += $ipRule
            }
            elseif (-not $AddClientIP)
            {
                $newIpRules = $newIpRules | Where-Object { $_.IPAddressOrRange -ne $currentIp }
            }

            # Update the network rule set
            Update-AzStorageAccountNetworkRuleSet -ResourceGroupName $resourceGroupName -AccountName $storageAccountName -IpRule $newIpRules
            Write-Verbose "[$( $MyInvocation.MyCommand.Name )] Info: Storage Account network rules updated successfully."
        }
        catch
        {
            Write-Error "[$( $MyInvocation.MyCommand.Name )] Error: An error occurred: $_"
        }
    }
}
