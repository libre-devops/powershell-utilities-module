function Test-TofuExists
{
    [CmdletBinding()]
    param ()

    $tofuCommand = Get-Command tofu -ErrorAction Stop

    if ($null -ne $tofuCommand)
    {
        Write-Verbose "[$( $MyInvocation.MyCommand.Name )] Success: Tofu found at: $( $tofuCommand.Source )"
    }
    else
    {
        throw "[$( $MyInvocation.MyCommand.Name )] Error: Tofu is not installed or not in PATH. Exiting."
    }
}
