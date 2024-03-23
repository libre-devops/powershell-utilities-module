function Set-AzCurrentClientIpToNsg
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$NsgResourceId,

        [Parameter(Mandatory)]
        [bool]$AddRule,

        [Parameter(Mandatory = $false)]
        [string]$RuleName = "TemporaryAllowClientIPInbound",

        [Parameter(Mandatory = $false)]
        [int]$Priority = 4000,

        [Parameter(Mandatory = $false)]
        [string]$Direction = "Inbound",

        [Parameter(Mandatory = $false)]
        [string]$Access = "Allow",

        [Parameter(Mandatory= $false)]
        [string]$Protocol = "*",

        [Parameter(Mandatory = $false)]
        [string]$SourcePortRange = "*",

        [Parameter(Mandatory = $false)]
        [string]$DestinationPortRange = "*",

        [Parameter(Mandatory = $false)]
        [string]$DestinationAddressPrefix = "VirtualNetwork",

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

            $resourceIdParts = $NsgResourceId -split '/'
            $resourceGroupName = $resourceIdParts[4]
            Write-Verbose "[$( $MyInvocation.MyCommand.Name )] Info: NSG Resource group name: $resourceGroupName "
            $nsgName = $resourceIdParts[-1]
            Write-Verbose "[$( $MyInvocation.MyCommand.Name )] Info: NSG name: $nsgName"

            # Look up the NSG using the provided Resource ID
            $nsg = Get-AzNetworkSecurityGroup -Name $nsgName -ResourceGroupName $resourceGroupName
        }
        catch
        {
            Write-Error "[$( $MyInvocation.MyCommand.Name )] An error occurred during Azure session verification or NSG retrieval: $_"
            return
        }
    }

    Process {
        try
        {
            $currentIp = (Invoke-RestMethod -Uri $ClientIpAddressCheckerUrl).Trim()
            if (-not $currentIp)
            {
                Write-Error "[$( $MyInvocation.MyCommand.Name )] Error: Failed to obtain current IP."
                return
            }
            Write-Verbose "[$( $MyInvocation.MyCommand.Name )] Info: Current Client IP is $currentIp"

            $sourceAddressPrefix = $currentIp
            $existingRule = $nsg.SecurityRules | Where-Object { $_.Name -eq $RuleName }

            if ($AddRule)
            {
                if ($existingRule)
                {
                    Write-Verbose "[$( $MyInvocation.MyCommand.Name )] Info: Rule $RuleName already exists. Updating it with the new IP address."
                    # Remove existing rule to update
                    $nsg.SecurityRules.Remove($existingRule) | Out-Null
                }

                # Adding the rule
                $rule = New-AzNetworkSecurityRuleConfig -Name $RuleName `
                                                        -Access $Access `
                                                        -Protocol $Protocol `
                                                        -Direction $Direction `
                                                        -Priority $Priority `
                                                        -SourceAddressPrefix $sourceAddressPrefix `
                                                        -SourcePortRange $SourcePortRange `
                                                        -DestinationAddressPrefix $DestinationAddressPrefix `
                                                        -DestinationPortRange $DestinationPortRange
                $nsg.SecurityRules.Add($rule) | Out-Null

                Write-Verbose "[$( $MyInvocation.MyCommand.Name )] Info: Rule $RuleName has been added/updated successfully."
            }
            else
            {
                if ($existingRule)
                {
                    $nsg.SecurityRules.Remove($existingRule) | Out-Null
                    Write-Verbose "[$( $MyInvocation.MyCommand.Name )] Info: Rule $RuleName has been removed successfully."
                }
                else
                {
                    Write-Verbose "[$( $MyInvocation.MyCommand.Name )] Info: Rule $RuleName does not exist. No action needed."
                }
            }
        }
        catch
        {
            Write-Error "[$( $MyInvocation.MyCommand.Name )] Error: An error occurred: $_"
        }
    }

    End {
        try
        {
            # Applying changes to the NSG
            Set-AzNetworkSecurityGroup -NetworkSecurityGroup $nsg | Out-Null
            Write-Verbose "[$( $MyInvocation.MyCommand.Name )] Info: NSG has been updated successfully."
        }
        catch
        {
            Write-Error "[$( $MyInvocation.MyCommand.Name )] Error: Failed to update NSG: $_"
        }
    }
}
