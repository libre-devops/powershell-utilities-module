function Format-Tofu
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string]$TofuProjectPath = (Get-Location).Path,

        [Parameter(Mandatory = $false)]
        [bool]$SortVariables = $true,

        [Parameter(Mandatory = $false)]
        [bool]$SortOutputs = $true,

        [Parameter(Mandatory = $false)]
        [bool]$SortTofu = $true,

        [Parameter(Mandatory = $false)]
        [string]$VariablesFileName = "variables.tf",

        [Parameter(Mandatory = $false)]
        [string]$OutputsFileName = "outputs.tf"
    )

    try
    {
        # Navigate to Tofu project path
        Write-Verbose "[$( $MyInvocation.MyCommand.Name )] Info: Navigating to Tofu project path: $TofuProjectPath"
        Push-Location -Path $TofuProjectPath

        # Sort variables.tf if specified
        if ($SortVariables -and (Test-Path $VariablesFileName))
        {
            Write-Verbose "[$( $MyInvocation.MyCommand.Name )] Info: Sorting variables file: $VariablesFileName"
            $variablesContent = Get-Content $VariablesFileName -Raw
            $sortedVariables = Sort-TofuVariables -VariablesContent $variablesContent
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
            $sortedOutputs = Sort-TofuOutputs -OutputsContent $outputsContent
            $sortedOutputs | Set-Content $OutputsFileName
            Write-Verbose "[$( $MyInvocation.MyCommand.Name )] Info: Sorted outputs in $OutputsFileName successfully."
        }
        else
        {
            Write-Verbose "[$( $MyInvocation.MyCommand.Name )] Info: Outputs file not found or sorting not requested."
        }

        # Check if tofu command exists before formatting
        $tofuPath = Get-Command tofu -ErrorAction SilentlyContinue
        if ($null -ne $tofuPath -and $SortTofu)
        {
            Write-Verbose "[$( $MyInvocation.MyCommand.Name )] Info: Tofu found at: $( $tofuPath.Source ). Running tofu fmt -recursive`."
            tofu fmt -recursive | Out-Null
            Write-Verbose "[$( $MyInvocation.MyCommand.Name )] Info: Tofu configuration files formatted successfully."
        }
        else
        {
            Write-Verbose "[$( $MyInvocation.MyCommand.Name )] Warning: Tofu command not found. Skipping formatting."
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
