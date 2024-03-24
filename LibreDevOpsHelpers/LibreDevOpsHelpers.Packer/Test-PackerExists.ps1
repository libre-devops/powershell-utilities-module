function Test-PackerExists
{
    [CmdletBinding()]
    param ()

    $packerCommand = Get-Command packer -ErrorAction Stop

    if ($null -ne $packerCommand)
    {
        Write-Verbose "[$( $MyInvocation.MyCommand.Name )] Success: Packer found at: $( $packerCommand.Source )"
    }
    else
    {
        throw "[$( $MyInvocation.MyCommand.Name )] Error: Packer is not installed or not in PATH. Exiting."
    }
}
