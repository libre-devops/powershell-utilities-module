function Test-PackerExists
{
    [CmdletBinding()]
    param ()

    $packerCommand = Get-Command packer -ErrorAction Stop

    if ($packerCommand -ne $null)
    {
        Write-Verbose "[$( $MyInvocation.MyCommand.Name )] Success: Packer found at: $( $packerCommand.Source )"
    }
    else
    {
        throw "[$( $MyInvocation.MyCommand.Name )] Error: Packer is not installed or not in PATH. Exiting."
    }
}
