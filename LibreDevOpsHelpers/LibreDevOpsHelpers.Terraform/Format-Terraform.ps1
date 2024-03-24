function Format-Terraform
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string]$TerraformProjectPath = (Get-Location).Path,

        [Parameter(Mandatory = $false)]
        [bool]$SortVariables = $true,

        [Parameter(Mandatory = $false)]
        [bool]$SortOutputs = $true,

        [Parameter(Mandatory = $false)]
        [bool]$SortTerraform = $true,

        [Parameter(Mandatory = $false)]
        [string]$VariablesFileName = "variables.tf",

        [Parameter(Mandatory = $false)]
        [string]$OutputsFileName = "outputs.tf"
    )

    try
    {
        # Navigate to Terraform project path
        Write-Verbose "[$( $MyInvocation.MyCommand.Name )] Info: Navigating to Terraform project path: $TerraformProjectPath"
        Push-Location -Path $TerraformProjectPath

        # Sort variables.tf if specified
        if ($SortVariables -and (Test-Path $VariablesFileName))
        {
            Write-Verbose "[$( $MyInvocation.MyCommand.Name )] Info: Sorting variables file: $VariablesFileName"
            $variablesContent = Get-Content $VariablesFileName -Raw
            $sortedVariables = Sort-TerraformVariables -VariablesContent $variablesContent
            $sortedVariables | Set-Content $VariablesFileName
            Write-Verbose "[$( $MyInvocation.MyCommand.Name )] Info: Sorted variables in $VariablesFileName successfully."
        }
        else
        {
            Write-Verbose "[$( $MyInvocation.MyCommand.Name )] Info: Variables file not found or sorting not requested."
        }

        # Sort outputs.tf if specified
        if ($SortOutputs -and (Test-Path $OutputsFileName))
        {
            Write-Verbose "[$( $MyInvocation.MyCommand.Name )] Info: Sorting outputs file: $OutputsFileName"
            $outputsContent = Get-Content $OutputsFileName -Raw
            $sortedOutputs = Sort-TerraformOutputs -OutputsContent $outputsContent
            $sortedOutputs | Set-Content $OutputsFileName
            Write-Verbose "[$( $MyInvocation.MyCommand.Name )] Info: Sorted outputs in $OutputsFileName successfully."
        }
        else
        {
            Write-Verbose "[$( $MyInvocation.MyCommand.Name )] Info: Outputs file not found or sorting not requested."
        }

        # Check if terraform command exists before formatting
        $terraformPath = Get-Command terraform -ErrorAction SilentlyContinue
        if ($null -ne $terraformPath -and $SortTerraform)
        {
            Write-Verbose "[$( $MyInvocation.MyCommand.Name )] Info: Terraform found at: $( $terraformPath.Source ). Running terraform fmt -recursive`."
            terraform fmt -recursive | Out-Null
            Write-Verbose "[$( $MyInvocation.MyCommand.Name )] Info: Terraform configuration files formatted successfully."
        }
        else
        {
            Write-Verbose "[$( $MyInvocation.MyCommand.Name )] Warning: Terraform command not found. Skipping formatting."
        }
    }
    catch
    {
        Write-Error "[$( $MyInvocation.MyCommand.Name )] Error: An error occurred: $_"
        throw
    }
    finally
    {
        # Return to original directory
        Pop-Location
        Write-Verbose "[$( $MyInvocation.MyCommand.Name )] Info: Returned to original directory."
    }
}
