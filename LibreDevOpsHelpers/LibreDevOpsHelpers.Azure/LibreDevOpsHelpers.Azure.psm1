[CmdletBinding()]
param()

# Dot-source the scripts
. $PSScriptRoot\Connect-AzAccountWithAccessToken.ps1
. $PSScriptRoot\Connect-AzAccountWithManagedIdentity.ps1
. $PSScriptRoot\Connect-AzAccountWithServicePrincipal.ps1
. $PSScriptRoot\Connect-AzCliAccountWithManagedIdentity.ps1
. $PSScriptRoot\Connect-AzCliAccountWithServicePrincipal.ps1
. $PSScriptRoot\Set-AzCurrentClientIpToNsg.ps1
. $PSScriptRoot\Set-AzCurrentClientIpToKeyvault.ps1
. $PSScriptRoot\Set-AzCurrentClientIpToStorageAccount.ps1
. $PSScriptRoot\Show-AzResourceId.ps1
. $PSScriptRoot\Asset-AzStorageContainerExists.ps1
