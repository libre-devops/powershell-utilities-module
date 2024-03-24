function Assert-AzStorageContainerExists
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$StorageAccountResourceId,

        [Parameter(Mandatory = $true)]
        [string]$ContainerName
    )

    Begin {
        try
        {
            $context = Get-AzContext
            if (-not $context)
            {
                throw "[$( $MyInvocation.MyCommand.Name )] User is not logged into Azure. Please login using Connect-AzAccount."
            }

            $resourceIdParts = $StorageAccountResourceId -split '/'
            $subscriptionId = $resourceIdParts[2]
            $resourceGroupName = $resourceIdParts[4]
            $storageAccountName = $resourceIdParts[-1]

            Set-AzContext -Subscription $subscriptionId
            Write-Verbose "[$( $MyInvocation.MyCommand.Name )] Info: AzContext is set...continuing"


            # Get the Storage Account
            $storageAccount = Get-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageAccountName
        }
        catch
        {
            throw "[$( $MyInvocation.MyCommand.Name )] Error in setting up the Azure context: $_"
            return
        }
    }

    Process {
        try
        {
            # Create a storage context using OAuth token
            $ctx = New-AzStorageContext -StorageAccountName $storageAccount.StorageAccountName -UseConnectedAccount

            # Check if the Blob Container Exists
            $container = Get-AzStorageContainer -Name $ContainerName -Context $ctx -ErrorAction SilentlyContinue

            # Create the Container if it Doesn't Exist
            if ($null -eq $container)
            {
                New-AzStorageContainer -Name $ContainerName -Context $ctx
                Write-Verbose "[$( $MyInvocation.MyCommand.Name )] Success: Container '$ContainerName' created."
            }
            else
            {
                Write-Verbose "[$( $MyInvocation.MyCommand.Name )] Info: Container '$ContainerName' already exists."
            }
        }
        catch
        {
            throw "[$( $MyInvocation.MyCommand.Name )] Error: in processing the container creation: $_"
        }
    }

}
