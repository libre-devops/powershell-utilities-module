#
# Module manifest for module 'LibreDevOpsHelpers.Azure'
#
# Generated by: Craig Thacker
#
# Generated on: 03/19/2024
#

@{
# Script module or binary module file associated with this manifest.
    RootModule = 'LibreDevOpsHelpers.Packer.psm1'

    # Version number of this module.
    ModuleVersion = '0.0.3'

    # Supported PSEditions
    #CompatiblePSEditions = @('Core', 'Desktop')

    # ID used to uniquely identify this module
    GUID = 'cabac124-6597-4450-8f67-889372614fe2'

    # Author of this module
    Author = 'Craig Thacker'

    # Company or vendor of this module
    CompanyName = 'Libre DevOps'

    # Copyright statement for this module
    Copyright = '(c) Craig Thacker. All rights reserved.'

    # Description of the functionality provided by this module
    Description = 'Packer helper functions for LibreDevOps'

    # Minimum version of the PowerShell engine required by this module
    #PowerShellVersion = '5.1'

    # Modules that must be imported into the global environment prior to importing this module
    #    RequiredModules = @(
    #        @{ ModuleName = 'Az.Accounts' },
    #        @{ ModuleName = 'Az.Network' },
    #        @{ ModuleName = 'Az.KeyVault' }
    #    )


    # Functions to export from this module
    FunctionsToExport = '*'

    # Cmdlets to export from this module
    CmdletsToExport = '*'

    # Variables to export from this module
    VariablesToExport = '*'

    # Aliases to export from this module
    AliasesToExport = '*'

    # Private data to pass to the module specified in RootModule/ModuleToProcess
    PrivateData = @{
        PSData = @{
        # Tags applied to this module
            Tags = @('azure', 'devops', 'powershell', 'cloud')

            # A URL to the license for this module
            LicenseUri = 'https://raw.githubusercontent.com/libre-devops/powershell-helpers/main/LICENSE'

            # A URL to the main website for this project
            ProjectUri = 'https://github.com/libre-devops/powershell-helpers'

            # A URL to an icon representing this module
            IconUri = 'https://libredevops.org/favicon.ico'
        } # End of PSData hashtable
    } # End of PrivateData hashtable
}

